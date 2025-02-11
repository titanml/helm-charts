You'll need the base values and secret values to launch the controller, as well as the per-deployment overwrite.
You'll also need to create the takeoff secret if you're not running this inside the private chart. Take your `~/.docker/config.json` and b64 encode it with:
```
echo -n 'that_file' | base64
```

```shell
apiVersion: v1
kind: Secret
metadata:
  name: takeoff-regcred
  namespace: <whatever ns you're deploying in'>
data:
  .dockerconfigjson: <b64 goes here!>
type: kubernetes.io/dockerconfigjson


```
You can then upgrade it with the application_values, which specify the reader details. 
Note that you'll need to adjust application_values to use the right cacheStorageClass for your chosen deployment. We'll probably fix this at some point.

```shell

#helm dependency build

helm install takeoff-helm . \
  -f values.yaml \
  -f secret_values.yaml \
  -f overwrites/values-local.yaml \
  -n <whatever_ns_you_deploy_in> \

```