import os
import tempfile
import requests
import time
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.serialization import pkcs12

def get_unix_time_range(duration_secs=300):
    """Returns (start_time, end_time) as UNIX timestamps"""
    end_time = int(time.time())
    start_time = end_time - duration_secs
    return str(start_time), str(end_time)

def fetch_f5xc_data():
    start_time, end_time = get_unix_time_range()
    F5_XC_URL = os.environ.get("F5_XC_URL")
    P12_PATH = os.environ.get("P12_PATH")
    P12_PASSWORD = os.environ.get("P12_PASSWORD")
    LB_NAME = os.environ.get("LB_NAME")

    PAYLOAD_all_lb = {
        "field_selector":{
            "node":{
                "metric":{
                    "downstream":[
                    "HTTP_ERROR_RATE","RESPONSE_THROUGHPUT","REQUEST_THROUGHPUT","HTTP_RESPONSE_LATENCY","HTTP_REQUEST_RATE","REQUEST_TO_ORIGIN_RATE"
                ]},
                "healthscore":{
                    "types":["HEALTHSCORE_OVERALL"]
                }
            }
        },
        "step":"300s",
        "start_time":start_time,
        "end_time":end_time,
        "label_filter":[
            {"label":"LABEL_VHOST_TYPE","op":"EQ","value":"HTTP_LOAD_BALANCER"}
        ],
        "group_by":["VHOST"]
    }

    PAYLOAD_individual_lb = {
        "field_selector": {
            "node": {
                "metric": {
                    "downstream": [
                        "HTTP_REQUEST_RATE", "HTTP_ERROR_RATE", "REQUEST_THROUGHPUT", "RESPONSE_THROUGHPUT",
                        "CLIENT_RTT", "SERVER_RTT", "HTTP_ERROR_RATE_4XX", "HTTP_ERROR_RATE_5XX",
                        "HTTP_RESPONSE_LATENCY", "HTTP_APP_LATENCY", "TCP_ERROR_RATE_CLIENT",
                        "TCP_ERROR_RATE_UPSTREAM", "TCP_CONNECTION_DURATION"
                    ]
                },
                "healthscore": {
                    "types": ["HEALTHSCORE_OVERALL"]
                }
            }
        },
        "step": "auto",
        "start_time": start_time,
        "end_time": end_time,
        "label_filter": [{
            "label": "LABEL_VHOST",
            "op": "EQ",
            "value": f"ves-io-http-loadbalancer-{LB_NAME}"
        }],
        "group_by": ["VHOST", "NAMESPACE"]
    }
    with open(P12_PATH, 'rb') as f:
        p12_data = f.read()

    private_key, certificate, _ = pkcs12.load_key_and_certificates(
        p12_data, P12_PASSWORD.encode()
    )

    with tempfile.NamedTemporaryFile(delete=False, suffix='.pem') as cert_file, \
         tempfile.NamedTemporaryFile(delete=False, suffix='.key') as key_file:

        cert_file.write(certificate.public_bytes(serialization.Encoding.PEM))
        cert_file.flush()

        key_file.write(private_key.private_bytes(
            encoding=serialization.Encoding.PEM,
            format=serialization.PrivateFormat.TraditionalOpenSSL,
            encryption_algorithm=serialization.NoEncryption()
        ))
        key_file.flush()

        cert = (cert_file.name, key_file.name)

        headers = {
            "accept": "application/json",
            "content-type": "application/json",
            "user-agent": "Mozilla/5.0"
        }
        responses = []
        for payload in [PAYLOAD_all_lb, PAYLOAD_individual_lb]:
            response = requests.post(F5_XC_URL, headers=headers, json=payload, cert=cert)
            response.raise_for_status()
            responses.append(response.json())

        return responses

#########To handle response for multiple request
from flask import Flask, Response

app = Flask(__name__)

def extract_prometheus_metrics(responses):
    metrics_output = []

    for data in responses:
        nodes = data.get("data", {}).get("nodes", [])
        for node in nodes:
            node_id = node.get("id", {})
            vhost = node_id.get("vhost", "unknown_vhost")

            node_data = node.get("data", {})
            metric_data = node_data.get("metric") or {}

            # Process metric data
            for direction in ["upstream", "downstream"]:
                metrics = metric_data.get(direction, [])
                for metric in metrics:
                    mtype = metric.get("type")
                    unit = metric.get("unit", "unitless")
                    raw_values = metric.get("value", {}).get("raw", [])

                    if not raw_values:
                        continue

                    latest = raw_values[-1]
                    value = latest.get("value")
                    timestamp = latest.get("timestamp")

                    if value is None:
                        continue

                    prom_name = f"f5xc_{direction}_{mtype.lower()}".replace("-", "_")
                    metrics_output.append(f"# HELP {prom_name} Metric type: {mtype}, unit: {unit}")
                    metrics_output.append(f"# TYPE {prom_name} gauge")
                    metrics_output.append(
                        f'{prom_name}{{direction="{direction}",vhost="{vhost}"}} {value} {int(timestamp) * 1000}'
                    )

            # Process healthscore data
            health_data = (node_data.get("healthscore") or {}).get("data", [])
            for health in health_data:
                htype = health.get("type")
                values = health.get("value", [])
                if not values:
                    continue

                latest = values[-1]
                value = latest.get("value")
                timestamp = latest.get("timestamp")

                if value is None:
                    continue

                prom_name = f"f5xc_healthscore_{htype.lower()}".replace("-", "_")
                metrics_output.append(f"# HELP {prom_name} Healthscore metric type: {htype}")
                metrics_output.append(f"# TYPE {prom_name} gauge")
                metrics_output.append(
                    f'{prom_name}{{vhost="{vhost}"}} {value} {int(timestamp) * 1000}'
                )

    return "\n".join(metrics_output)

@app.route("/metrics")
def metrics():
    responses = fetch_f5xc_data()  # Now a list of responses
    output = extract_prometheus_metrics(responses)
    return Response(output, mimetype="text/plain")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8888)