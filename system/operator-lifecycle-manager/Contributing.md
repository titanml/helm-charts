# Contributing Guide

## Installation

### Operator Lifecycle Manager (OLM)

This can be installed simply by running the following command:

```bash
curl -L -s https://github.com/operator-framework/operator-controller/releases/latest/download/install.sh | bash -s
```

This will create a catalogd manager and controller manager in the `olmv1-system` namespace. As well as setup the CRDs needed for the OLM.

### Create and publish new operator bundle

We bundle the operator and it's resources in a single image. This is then pushed to a container registry and can stored in our cluster catalog.

1. Set the `VERSION` and `CRD_VERSION` in the Makefile. The former is the semantically versioned `vX.Y.Z` and the CRD version we use the format `vX` (`v1alpha1`).

2. Create a new operator bundle: this will create and push a new operator image, and operator bundle image using the current helm file.

```bash
make bundle-build-push
```

### Create and publish a new catalog

The cluster catalog contains all the available versions of our model orchestra operator. To add your new version to the catalog you will need to edit the `./catalog/operator_catalog.yaml` file and add a new entry for your version.

* **NOTE: MAKE SURE NOT TO REMOVE OR CHANGE PREVIOUS VERSIONS AS CLIENTS MAY BE RELYING ON THEM**

```yaml
# This is the set of operator bundles that we support in our catalog. To add another version of the operator, add another bundle to the list.
Schema: olm.semver
GenerateMajorChannels: true
GenerateMinorChannels: false
# All new versions that we are confident in can be added to the fast channel, only mature releases should be added to the stable channel.
Stable:
  Bundles:
  - Image: docker.io/tytn/operator-bundle:0.1.0
  # Add your new version here like:
  # - Image: docker.io/tytn/operator-bundle:0.2.0
  # Note here we need the canonical image name.
Fast:
  Bundles:
  - Image: docker.io/tytn/operator-bundle:0.1.0
  # Add your new version here like:
  # - Image: docker.io/tytn/operator-bundle:0.2.0
  # Note here we need the canonical image name.
```

Once this is done you can push a new catalog image containing your new operator:

```bash
make catalog-build-push # Or make catalog-build-push DEV=1 to build and push the dev catalog
```

## Install the Catalog into your cluster

```bash
kubectl create namespace model-orchestra-operator-system
helm repo add titanml titanml.github.io/helm-charts
helm install catalog titanml/catalog -n model-orchestra-operator-system
```

See the [catalog README](../../charts/catalog/README.md) for more further details on installing specific versions of the operator.

## Custom Resource Examples

For example, to deploy a Model Orchestra with a single application:

```yaml
apiVersion: models.titanml.co/v1alpha1
kind: ModelOrchestra
metadata:
  name: my-model-orchestra
  labels:
    operatorVersion: 0.2.13 # This is the version of the operator you want to reconcile this CR
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

### Notes

Some fields can't be reconciled yet. Specifically: anything in the `readerConfig` and the gateway config will change the config in the corresponding pods, but the pods are not configured to reboot on change. This will change in an ensuing version.

## Managing Operator

Once the cluster catalog is correctly installed, you can install operators using the `clusterExtension` object provided by OLM.

```yaml
apiVersion: olm.operatorframework.io/v1
kind: ClusterExtension
metadata:
  name: model-orchestra-operator-v0-stable
spec:
  namespace: model-orchestra-operator-system # namespace to deploy the operator into
  source:
    sourceType: Catalog # source type to use: https://operator-framework.github.io/operator-controller/api-reference/operator-controller-api-reference/#sourceconfig
    catalog:
      # catalog filter: https://operator-framework.github.io/operator-controller/api-reference/operator-controller-api-reference/#catalogfilter
      packageName: model-orchestra-operator # name of the operator
      channels: [ "stable-v0" ] # channels to subscribe to
```

TThe OLM will then attempt to install all the non-skipped versions of the operator in the stable channel we have provided in the Cluster Catalog. We can also add the `/spec/source/catalog/version` field to fix the installation to a specific version. If not provided, the OLM will install the latest version in the channel.

Once we have a Cluster Extension specified we can dynamically release new versions of the operator to clients adding them to their Cluster Catalogs. The clients decide their install strategy and we provide all the versions via the `stable` and `fast` channels.
