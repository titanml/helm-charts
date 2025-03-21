# Model Orchestra Operator Lifecycle Manager

The Model Orchestra Operator Lifecycle Manager (OLM) oversees Kubernetes operators, and specifically we use it to control the lifecycle of the Model Orchestra.

## Project Structure

```plaintext
operator-lifecycle-manager/
├── helm-charts/          # Operator's Helm charts
│   └── model-orchestra/  # Managed application chart
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

Model Orchestra are versioned helm charts. The operator that we use to reconcile this chart is the Helm Operator from the Operator Framework. This holds a version of the watched helm chart in it's running image and templates the resources needed using a values file compiled from the spec of the Model Orchestra Custom Resource. The Controller inside the Helm Operator holds a versioned snapshot of the helm chart files it is watching and so need to be managed carefully. We bundle versioned operators and store each bundle in a catalog with channels. A client in the cluster can then subscribe to a channel and install a specific operator or supported channel from the catalog.


