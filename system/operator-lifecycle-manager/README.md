# Inference Stack Operator Lifecycle Manager

The Inference Stack Operator Lifecycle Manager (OLM) oversees Kubernetes operators, and specifically we use it to control the lifecycle of the Inference Stack.

The operator we use is the [Helm Operator](https://github.com/operator-framework/helm-operator-plugins) from the [Operator Framework](https://operatorframework.io/). This operator holds a version of the watched (inference-stack) helm chart in it's running image and templates the resources needed using a values file compiled from the spec of the `InferenceStack` Custom Resource. We bundle versioned operators and store each bundle in a catalog with channels. Subscriptions can be configured to install a specific operator or supported channel from the catalog.

## Project Structure

```plaintext
operator-lifecycle-manager/
├── helm-charts/          # Operator's Helm charts
│   └── inference-stack/  # Managed application chart
├── bundle/               # OLM bundle files
├── config/               # Operator configuration, contains all the resources that make up a single operator excluding the CRD.
├── catalog/              # Operator catalog, houses the operator catalogs and their constructed manifests which are mounted in the catalog image.
├── Dockerfile            # Operator Dockerfile
├── Dockerfile.catalog    # Catalog Dockerfile
├── Dockerfile.controller # Controller Dockerfile
├── watches.yaml          # Operator watches
└── Makefile              # Build and deployment commands, get list of commands by running `make help`
```

## Architecture

### Overview

This is an overview of the Inference Stack Operator Lifecycle Manager:

![overview](olm.png)

### OLM v1 Components

From running the OLM [install script](../README.md#installation), a Catalogd and an Operator Controller are created in the `olmv1-system` namespace. These watch two CRDs, `ClusterCatalog` and `ClusterExtension`, respectively.

#### Catalogd

The Catalogd is responsible for unpacking file-based catalog images on a repository and storing them in it's cache so they can be queried via the HTTP API. It knows which catalogs to fetch and unpack by watching the `ClusterCatalog` CRD.

#### Operator Controller

The Operator Controller queries the Catalogd cache via the HTTP API and stores the catalog and the unpacked bundles in two separate caches.

### Author

An author is responsible for publishing both bundle and catalog images to a repository so they can be used in the cluster by the OLM. For a detailed guide on how to create and publish new operator bundles and catalogs see [Contributing.md](./Contributing.md).

### Bundle Resources

### Inference Stack Custom Resource Definition

### Cluster Catalog

### Cluster Extension
