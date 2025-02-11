import requests
from time import sleep


def liveness_check():
    try:
        response = requests.get("http://takeoff-controller-svc:3000/status")
        if response.status_code == 200:
            return True
        else:
            print("Request failed with status code:", response.status_code)
    except Exception as e:
        print("Request failed, ", e)
    return False


if __name__ == "__main__":
    while not liveness_check():
        print("Controller is not ready yet. Retrying in 1 second...")
        sleep(1)
    print("Controller is up and running")
