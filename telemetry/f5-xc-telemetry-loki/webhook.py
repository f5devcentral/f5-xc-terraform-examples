from flask import Flask, request, Response  # type: ignore
import json
import time
import requests

app = Flask(__name__)

LOKI_URL = "http://172.17.0.1:3100/loki/api/v1/push"

@app.route('/glr-webhook', methods=['POST'])
def glr_webhook():
    try:
        # Receive raw data from the POST request
        raw_body = request.get_data(as_text=True)
        log_lines = raw_body.strip().split('\n')

        # Parse each line into JSON
        logs = [json.loads(line) for line in log_lines if line.strip()]

        # Generate a timestamp for the log
        timestamp = str(int(time.time() * 1e9))

        # Format the logs to include the timestamp
        values = [[timestamp, json.dumps(log)] for log in logs]
        formatted_values = [[ts, line] for ts, line in values]

        # Create the payload for Loki
        payload = {
            "streams": [
                {
                    "stream": {"job": "f5-glr"},
                    "values": formatted_values
                }
            ]
        }

        # Set the headers and send the data to Loki
        headers = {"Content-Type": "application/json"}
        loki_response = requests.post(LOKI_URL, headers=headers, data=json.dumps(payload))

        # Check the response from Loki
        if loki_response.status_code != 204:
            return Response(f"Failed to send logs to Loki: {loki_response.text}", status=500)

        # Return a successful response
        return Response(status=204)

    except json.JSONDecodeError as e:
        # Handle JSON parsing errors
        return Response(f"JSON Decode Error: {str(e)}", status=400)

    except requests.exceptions.RequestException as e:
        # Handle issues with the request to Loki
        return Response(f"Request Error: {str(e)}", status=500)

    except Exception as e:
        # Catch any other exceptions
        return Response(f"Unexpected Error: {str(e)}", status=500)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)