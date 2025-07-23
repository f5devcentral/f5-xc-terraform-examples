from flask import Flask, jsonify
import requests
import json
import time
from datetime import datetime
from elasticsearch import Elasticsearch

# Initialize Flask app
app = Flask(__name__)

user_input = json.load(open('./user_inputs.json', 'r'))
xc_api_token = user_input["xc_api_token"]
http_lb_name = user_input["http_lb_name"]
tenant_name = user_input["tenant_name"]
namespace = user_input["namespace"]
es_url = user_input["es_url"]
elk_idx = user_input["elk_idx"]

API_URL = f"https://{tenant_name}.console.ves.volterra.io/api/data/namespaces/{namespace}/graph/service"
token = xc_api_token




# Elasticsearch connection details
ELASTICSEARCH_URL = es_url  # Replace with your Elasticsearch address
ELK_INDEX_NAME = elk_idx  # Name of the Elasticsearch index

# Initialize Elasticsearch client
es = Elasticsearch([ELASTICSEARCH_URL], http_auth=("elastic", "changeme"), timeout=60, max_retries=3, retry_on_timeout=True)

def get_unix_time_range(duration_secs=300):
    """Returns (start_time, end_time) as UNIX timestamps"""
    end_time = int(time.time())
    start_time = end_time - duration_secs
    return str(start_time), str(end_time)

# Function to fetch data from the API
def fetch_data():
    headers = {
        "Authorization": "APIToken " + token,  # CSRF Token or Session Cookie
        "Content-Type": "application/json",  # API expects JSON payloads
        "Host": f"{tenant_name}.console.ves.volterra.io"  # Host header for the API (optional)
    }
    start_time, end_time = get_unix_time_range()
    print(start_time, end_time)
    if http_lb_name != "":
        body = {"field_selector":{"node":{"metric":{"features":["ANOMALY_DETECTION","CONFIDENCE_INTERVAL"],"downstream":["HTTP_REQUEST_RATE", "HTTP_ERROR_RATE", "REQUEST_THROUGHPUT", "RESPONSE_THROUGHPUT","CLIENT_RTT", "SERVER_RTT", "HTTP_ERROR_RATE_4XX", "HTTP_ERROR_RATE_5XX","HTTP_RESPONSE_LATENCY", "HTTP_APP_LATENCY", "TCP_ERROR_RATE_CLIENT","TCP_ERROR_RATE_UPSTREAM", "TCP_CONNECTION_DURATION"
]}}},"step":"auto","end_time":end_time,"start_time":start_time,"label_filter":[{"label":"LABEL_VHOST","op":"EQ","value":f"ves-io-http-loadbalancer-{http_lb_name}"}],"group_by":["VHOST","NAMESPACE"]}
    else:
        body = {"field_selector":{"node":{"metric":{"downstream":["HTTP_ERROR_RATE","RESPONSE_THROUGHPUT","REQUEST_THROUGHPUT","HTTP_RESPONSE_LATENCY","HTTP_REQUEST_RATE","REQUEST_TO_ORIGIN_RATE"]}}},"step":"auto","end_time":end_time,"start_time":start_time,"label_filter":[{"label":"LABEL_VHOST_TYPE","op":"EQ","value":"HTTP_LOAD_BALANCER"}],"group_by":["VHOST"]}

    try:
        # API request
        res = requests.post(API_URL, headers=headers, json=body)
        res.raise_for_status()
        print("Raw API Response:", res.json())
        return res.json()  # Assuming the API returns data in JSON format
    except Exception as e:
        print(f"Error while fetching data: {e}")
        return {}

# Extract and transform the metrics into Elasticsearch-compatible JSON format
def transform_metrics(data):
    metrics = []  # List to hold transformed metrics/documents for Elasticsearch
    
    # Helper function to safely convert value(s) to integers
    def convert_to_float(value):
        if isinstance(value, list):
            # If value is a list, try converting each item
            return [convert_to_float(item) for item in value]
        try:
            return float(value)  # Convert value to integer if possible
        except (ValueError, TypeError):
            return value  # Return the original value if conversion fails

    ### PART 1: Process "nodes"
    nodes = data.get("data", {}).get("nodes", [])
    for node in nodes:
        node_id = node.get("id", {})
        vhost = node_id.get("vhost", "unknown")
        app_type = node_id.get("app_type", "unknown")
        
        downstream_metrics = node.get("data", {}).get("metric", {}).get("downstream", [])
        
        upstream_metrics = node.get("data", {}).get("metric", {}).get("upstream", [])
        cnt = 1
        param = []
        # Process downstream metrics
        for metric in downstream_metrics:
            fetched_type = metric.get("type", {})
            metric_entry = {
                "@timestamp": datetime.utcnow().isoformat(),  # UTC time
                "node_id_vhost": vhost,
                "node_id_app_type": app_type,
                "direction": "downstream",
                "metric_type": metric.get("type", "UNKNOWN"),
                "metric_unit": metric.get("unit", "UNKNOWN_UNIT"),
                "metric_values": metric.get("value", {}),
                "type": metric.get("type", {}),
                f"{fetched_type}_values": convert_to_float(metric.get("value", {}).get('raw', [{}])[0].get('value'))                
            }
            metrics.append(metric_entry)
            cnt+=1


        for metric in upstream_metrics:
            metric_entry = {
                "@timestamp": datetime.utcnow().isoformat(),
                "node_id_vhost": vhost,
                "node_id_app_type": app_type,
                "direction": "upstream",
                "metric_type": metric.get("type", "UNKNOWN"),
                "metric_unit": metric.get("unit", "UNKNOWN_UNIT"),
                "metric_values": convert_to_int(metric.get("value", {}))  # Convert values to int
            }
            metrics.append(metric_entry)
            
    ### PART 2: Process "edges"
    edges = data.get("data", {}).get("edges", [])
    for edge in edges:
        src_id = edge.get("src_id", {}).get("vhost", "unknown")
        dst_id = edge.get("dst_id", {}).get("vhost", "unknown")
        api_endpoints = edge.get("data", {}).get("api_endpoints", [])
        metrics_data = edge.get("data", {}).get("metric", {}).get("data", [])
        healthscore_data = edge.get("data", {}).get("healthscore", {}).get("data", [])
        
        # Process API endpoints
        for endpoint in api_endpoints:
            api_ep = endpoint.get("api_ep", {})
            pdf_info = endpoint.get("pdf_info", {})
            metric_entry = {
                "@timestamp": datetime.utcnow().isoformat(),
                "src_id_vhost": src_id,
                "dst_id_vhost": dst_id,
                "avg_latency": convert_to_int(api_ep.get("avg_latency", None)),
                "max_latency": convert_to_int(api_ep.get("max_latency", None)),
                "req_rate": convert_to_int(api_ep.get("req_rate", None)),
                "method": api_ep.get("method", "unknown"),
                "risk_score": convert_to_int(api_ep.get("risk_score", {}).get("score", None)),
                "security_risk": api_ep.get("security_risk", "unknown"),
                "api_attributes": api_ep.get("attributes", []),
                "pdf_info_stats": pdf_info.get("error_rate_stat", {})
            }
            metrics.append(metric_entry)
        # Process edge-level metric data
        for metric in metrics_data:
            metric_entry = {
                "@timestamp": datetime.utcnow().isoformat(),
                "src_id_vhost": src_id,
                "dst_id_vhost": dst_id,
                "metric_type": metric.get("type", "UNKNOWN"),
                "metric_unit": metric.get("unit", "UNKNOWN_UNIT"),
                "metric_values": convert_to_int(metric.get("value", {}))  # Convert values to int
            }
            metrics.append(metric_entry)
        # Process edge-level healthscore data
        for healthscore in healthscore_data:
            metric_entry = {
                "@timestamp": datetime.utcnow().isoformat(),
                "src_id_vhost": src_id,
                "dst_id_vhost": dst_id,
                "healthscore_type": healthscore.get("type", "UNKNOWN"),
                "healthscore_reason": healthscore.get("reason", "unknown"),
                "healthscore_value": convert_to_int(healthscore.get("value", []))  # Convert values to int
            }
            metrics.append(metric_entry)
            
    ### PART 3: Add Metadata (Optional)
    # Add top-level metadata to all documents for context, if needed
    global_metadata = {
        "step": data.get("step", "unknown"),
        "total_edges": len(edges),
        "total_nodes": len(nodes)
    }
    for metric in metrics:
        metric.update(global_metadata)  # Enrich metrics with global metadata
    
    return metrics


def send_to_elasticsearch(metrics):
    try:
        # Prepare bulk actions for efficient ingestion
        actions = []
        # Bulk actions must have valid metadata each followed by the document
        for metric in metrics:
            actions.append({ "index": { "_index": ELK_INDEX_NAME } })  # Metadata line
            actions.append(metric)  
        # Send bulk request to Elasticsearch
        response = es.bulk(body=actions)  # `body=` is required to specify the bulk request properly
        if response.get('errors', False):
            print("Errors occurred during bulk indexing:", response)
        else:
            print(f"Successfully indexed {len(metrics)} metrics into Elasticsearch.")
    except Exception as e:
        print(f"Error while sending metrics to Elasticsearch: {e}")

# Flask route to send metrics to ELK
@app.route("/send-metrics", methods=["POST"])
def send_metrics_to_elk():
    # Fetch data from API
    data = fetch_data()
    print("Raw API Response:", data)
    # Transform metrics into Elasticsearch-compatible format
    metrics = transform_metrics(data)    
    # Send metrics to Elasticsearch
    send_to_elasticsearch(metrics)
    # Return a success response
    return jsonify({"message": f"Sent {len(metrics)} metrics to Elasticsearch!"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8888)