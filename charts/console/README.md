# Management Console

The management console is a simple & intuitive interface for creating, managing, and monitoring your LLM deployments.

## TL;DR

```bash
helm repo add takeoff titanml.github.io/helm-charts
helm install console takeoff/console
```

### Pulling Console images

To access the Console images you need to make sure you are authenticated to pull from the TitanML DockerHub. To do this encode your docker auth into a k8s Secret. You can then make this accessible to k8s in your values.yaml file, so it can pull the container images:

```yaml
imagePullSecrets:
  - name: <SECRET_NAME>
```

Alternatively you can achieve it like so:

```bash
helm install console takeoff/console --set imagePullSecrets[0].name=<SECRET_NAME>
```

## Configuration & installation details

## Architecture overview

This chart deploys the management console as two Kubernetes [Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) (one for the frontend, one for the backend), a [postgres](https://www.postgresql.org/) database, and a [`InferenceStack` custom resource](https://github.com/titanml/helm-charts/charts/inference-stack) which is managed by the [Inference Stack Operator](./../../system/operator-lifecycle-manager/README.md).
Authentication for the database-backend connection defaults to the values in templates/secret.yaml.

To provide a custom secret (with `dbUser` and `dbPassword` keys), provide `--set secret.generate=false --set secret.name="my-secret"`.

## Resource requests & limits

This chart sets no resource requests or limits for the components.
In a production environment, these should be set.
