import requests
import os
import yaml
import time
import contextlib

# Check once every 5 minutes
TIME_BETWEEN_INFERENCE_CHECKS_SECONDS = 60 * 5


def liveness_check():
    with contextlib.suppress(Exception):
        # Hacky way to get the reader id of the model running as it is generated with a random uuid suffix and in this k8s setup we
        # only have one reader running.
        with open("manifest.yaml", "r") as file:
            config = yaml.safe_load(file)
        reader_id = list(config["takeoff"]["readers_config"].keys())[0]

        response = requests.get("http://takeoff-controller-svc:3000/status", timeout=5)
        if response.status_code == 200:
            body = response.json()
            return reader_id in body["live_readers"]
    return False


def should_check_inference():
    should_check = True
    if os.path.exists("last_time_served"):
        with open("last_time_served", "r") as file:
            last_time_served = int(file.read())
        should_check = last_time_served + TIME_BETWEEN_INFERENCE_CHECKS_SECONDS < int(time.time())
    return should_check


def check_inference():
    with contextlib.suppress(Exception):
        with open("manifest.yaml", "r") as file:
            config = yaml.safe_load(file)
        consumer_groups = list(config["takeoff"]["readers_config"].values())[0]["consumer_group"]
        if "generate" in consumer_groups:
            response = requests.post(
                "http://takeoff-controller-svc:3000/generate",
                json={"text": "liveness test", "consumer_group": "generate", "max_new_tokens": 3},
                timeout=20,
            )
            print(response.json())
            if response.status_code == 200:
                return True
        elif "embed" in consumer_groups:
            response = requests.post(
                "http://takeoff-controller-svc:3000/embed",
                json={"text": "liveness test", "consumer_group": "embed"},
                timeout=20,
            )
            if response.status_code == 200:
                return True
        elif "rerank" in consumer_groups:
            response = requests.post(
                "http://takeoff-controller-svc:3000/classify",
                json={"text": ["liveness", "test"], "consumer_group": "rerank"},
                timeout=20,
            )
            if response.status_code == 200:
                return True
        else:
            print(f"Unknown consumer group: {consumer_groups}")
    return False


if __name__ == "__main__":
    if liveness_check():
        if should_check_inference():
            if check_inference():
                print("Inference is working")
                # If we have checked inference and it is working, we note the last successful check time and exit
                with open("last_time_served", "w") as file:
                    file.write(str(int(time.time())))
                os._exit(0)
            else:
                print("Inference isn't working")
                os._exit(1)
        else:
            print("Not checking inference")
            os._exit(0)
    else:
        print("Service is down")
        os._exit(1)
