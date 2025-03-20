# Catalog

This is a Cluster Catalog from the [Operator Lifecycle Manager](https://operator-framework.github.io/operator-controller/) project which contains a list of all the available operators in the cluster. It also optionally creates a `ClusterExtension` which subscribes and installs a specific version of the operator available in the catalog from a specific channel.

## TL;DR

```
helm repo add titanml titanml.github.io/helm-charts
helm install catalog titanml/catalog
```

## Resources

This chart primarily deploys the Model Orchestra CRD, a Cluster Catalog, and Cluster Extensions. To see how to add new operators and create new catalog images see [here](../../system/operator-lifecycle-manager/README.md). By default, this chart will install a cluster catalog and a single cluster extension that subscribes to the `stable` channel.
