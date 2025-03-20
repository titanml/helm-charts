# Model Orchestra Operator Lifecycle Manager

The Model Orchestra Operator Lifecycle Manager (OLM) is a Kubernetes operator that manages the lifecycle of the Model Orchestra operator. It is responsible for installing the Model Orchestra Operator and managing its lifecycle.

## Working thoughts

The OLM is a Kubernetes operator that manages the lifecycle of the Model Orchestra operator. This is essentially following the [OLM docs here](https://olm.operatorframework.io/docs/tasks/). The current working idea is to:
* Bundle up the operator so we can have versioned releases, these will be selected when you are deploying the Model Orchestra CR by apiVersion.
* Create a catalog in each cluster which can store the bundles. 
* Create subscriptions to the catalog to install the specific versions of the operator wanted.

# Model Orchestra Operator

This repository contains a Kubernetes Operator built using the Operator SDK's
Helm-based operator support. The operator manages a deployed model orchestra.

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

## Usage

### Install the Operator Lifecycle Manager (OLM)

The Operator Lifecycle Manager (OLM) dependencies are needed to run multiple versions of our Model Orchestra operator in the same cluster. To do so run the following script with your `kubectl` cluster context set:

```bash
curl -L -s https://github.com/operator-framework/operator-controller/releases/latest/download/install.sh | bash -s
```

### Create a new operator bundle

The Makefile provides several commands to help with development:

1. Increment the `VERSION` and `CRD_VERSION` in the Makefile. These must be unique, for version we use the semver format `vX.Y.Z` and for the CRD version we use the format `vX` (`v1alpha1`).

2. Create a new operator bundle: this will create and push a new operator image, and operator bundle image using the current helm file.
```bash
make bundle-build-push
```

### Update the Cluster Catalog

The cluster catalog contains all the available versions of our model orchestra operator. To add your new version to the catalog you will need to edit the `./catalog/operator_catalog.yaml` file and add a new entry for your version.

**MAKE SURE NOT TO REMOVE OR CHANGE PREVIOUS VERSIONS AS CLIENTS MAY BE RELYING ON THEM**

```yaml
# This is the set of operator bundles that we support in our catalog. To add another version of the operator, add another bundle to the list.
Schema: olm.semver
GenerateMajorChannels: true
GenerateMinorChannels: false
Stable:
  Bundles:
  - Image: docker.io/tytn/operator-bundle:0.1.0
  # Add your new version here like:
  # - Image: docker.io/tytn/operator-bundle:0.2.0
  # Note here we need the canonical image name.
```

Once this is done you can push a new catalog image containing your new operator:

```bash
make catalog-build-push
```

```bash
kubectl create namespace model-orchestra-operator-system
helm install 
```

## Custom Resource Examples

For example, to deploy a Model Orchestra with a single application:

```yaml
apiVersion: models.titanml.co/v1alpha1
kind: ModelOrchestra
metadata:
  name: my-model-orchestra
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
`readerConfig` and the gateway config will change the config in the
corresponding pods, but the pods are not configured to reboot on change.
This will change in an ensuing version.
