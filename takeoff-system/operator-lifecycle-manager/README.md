# Takeoff Operator

This repository contains a Kubernetes Operator built using the Operator SDK's
Helm-based operator support. The operator manages a deployed takeoff cluster.

## Overview

A Helm-based operator leverages Helm charts to deploy and manage Kubernetes
resources. When you create a custom resource (CR), the operator:

1. Takes the values from your CR
2. Combines them with the Helm chart
3. Applies the resulting manifests to your cluster

This means you can use Kubernetes-native APIs to manage your Helm releases.

## Prerequisites

- Kubernetes cluster (1.16+)
- kubectl configured to communicate with your cluster
- Access to a container registry
- Helm (3.0+)

## Project Structure

```plaintext
takeoff-operator/
├── helm-charts/          # Operator's Helm charts
│   └── takeoff/         # Managed application chart
├── bundle/              # OLM bundle files
├── config/              # Operator configuration
└── Makefile            # Build and deployment commands
```

## Usage

### Development Workflow

The Makefile provides several commands to help with development:

1. Build and push the operator image:

```bash
make docker-build-push
```

This builds the operator image and pushes it to the configured registry. The
image tag is determined by the VERSION variable.

### Deployment

1. Install CRDs:

```bash
make install
```

2. Deploy the operator:

```bash
make deploy
```

3. To uninstall:

```bash
make undeploy
```

## Configuration

Key variables in the Makefile:

- `VERSION`: Defines the project version
- `IMG`: The operator image URL

## Chart Syncing

The operator maintains two versions of the Helm chart:

1. Source chart: Located at `../takeoff`
2. Operator chart: Located at `helm-charts/takeoff`

The operator chart is automatically synced from the source chart during
relevant operations (build, deploy, etc.). You can manually sync using:

```bash
make sync-charts
```

## Custom Resource Examples

Install the crds (`make install`), and deploy the controller (`make deploy`).
Then, you can create a Takeoff custom resource to deploy a takeoff cluster.

For example, to deploy a takeoff cluster with a single application, available
in the controller API as `hello-world`:

```yaml
apiVersion: charts.titanml.co/v1alpha1
kind: Takeoff
metadata:
  name: my-takeoff-cluster
spec:
  applications:
    hello-world:
      nodeSelector:
        nvidia.com/gpu.product: NVIDIA-GeForce-RTX-3060
      readerConfig:
        modelName: "unsloth/Llama-3.2-1B-Instruct"
        device: cuda
  imagePullSecrets:
    - name: regcred
```

## Notes

Some fields can't be reconciled yet. Specifically: anything in the
`readerConfig` and the controller config will change the config in the
corresponding pods, but the pods are not configured to reboot on change.
This will change in an ensuing version.
