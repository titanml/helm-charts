# Takeoff management console

The takeoff management console is a simple & intuitive interface for creating, managing, and monitoring your LLM deployments. 

## TL;DR

```
helm repo add titanml titanml.github.io/helm-charts
helm install takeoff-console titanml/takeoff-console
```

## Configuration & installation details

## Architecture overview

This chart deploys the management console as two Kubernetes [Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) (one for the frontend, one for the backend), a [postgres](https://www.postgresql.org/) database, and a [Takeoff custom resource](https://github.com/titanml/helm-charts/charts/takeoff) which is managed by the [Takeoff Operator](https://github.com/titanml/helm-charts/charts/takeoff).
Authentication for the database-backend connection defaults to the values in templates/secret.yaml. 

To provide a custom secret (with `dbUser` and `dbPassword` keys), provide `--set secret.generate=false --set secret.name="my-secret"`.

## Resource requests & limits

This chart sets no resource requests or limits for the components. 
In a production environment, these should be set.
