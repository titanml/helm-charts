# management console

The management console is a simple & intuitive interface for creating, managing, and monitoring your LLM deployments. 

## TL;DR

```
helm repo add titanml titanml.github.io/helm-charts
helm install console titanml/console
```

### Pulling Takeoff images

The Takeoff image for the controller and applications will be derived from the `appVersion` plus a '-cpu' and '-gpu' suffix respectively. You can override either of the tags by setting controller/application.image.tag in your values override.

Make sure you are authenticated to pull from the TitanML dockerhub, and have encoded this in a k8s Secret. You can then make this accessible to k8s in your values.yaml file, so it can pull the container images:

```
imagePullSecrets:
  - name: <SECRET_NAME>
```

Alternatively you can achieve it like so:

```
helm install takeoff titanml/takeoff-console --set imagePullSecrets[0].name=<SECRET_NAME>
```

## Configuration & installation details

## Architecture overview

This chart deploys the management console as two Kubernetes [Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) (one for the frontend, one for the backend), a [postgres](https://www.postgresql.org/) database, and a [Model Orchestra custom resource](https://github.com/titanml/helm-charts/charts/model-orchestra) which is managed by the [Model Orchestra Operator](./../../system/operator-lifecycle-manager/README.md).
Authentication for the database-backend connection defaults to the values in templates/secret.yaml. 

To provide a custom secret (with `dbUser` and `dbPassword` keys), provide `--set secret.generate=false --set secret.name="my-secret"`.

## Resource requests & limits

This chart sets no resource requests or limits for the components. 
In a production environment, these should be set.
