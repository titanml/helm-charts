# TitanML Helm Charts

These charts allow you to deploy open source AI on Kubernetes at any scale.

## Pre-requisites

* Kubernetes 
* [kubectl](https://kubernetes.io/docs/reference/kubectl/kubectl/)
* [Helm](https://helm.sh/docs/intro/install/)

## Cluster Setup (optional)

We have certain cluster wide requirements necessary to allow our charts to run. You can install them by installing the `system` helmfile [following the instructions here.](system/README.md). This is a one off installation step and may already be completed, please check with your cluster administrator.

## Getting Started

We have two supported paths for users to control their AI deployments:

### Supported Installation Path - Management Console

This is a UI which is used to spin up and configured AI applications. This is useful for people less familiar with managing Kubernetes applications. Our deployment guide for this can be found [here](charts/console/README.md).

### Advanced Path - Model Orchestra Helm Chart

Interact directly with the helm chart to setup your own applications. This is recommended for more advanced users who want more customisation. Our deployment guide for this can be found [here](charts/model-orchestra/README.md).


## Glossary

* Cluster: a group of computing nodes, or worker machines, that run containerized applications, managed by a control plane that orchestrates and manages the cluster's resources and workloads.

* Console: a management interface that allows users to manipulate model orchestras. It also can be used for observability of the deployed models.

* Custom Resource Definition: a kubernetes object that extends the Kubernetes API and is available for use in the cluster.

* [Helm Operator](https://github.com/operator-framework/helm-operator-plugins): an open source Operator from the Operator Framework project

* Model Orchestra: the custom resource that we deploy which has the configuration for each application that the user wants to be reconciled by the model orchestra operator.

* Controller: a set of objects that are responsible to transforming a custom resource into a set of kubernetes native objects. Any custom resource that is deployed in the cluster is managed by an operator.

* Operator: the combination of a Custom Resource Definition and a Controller.

* [Operator Lifecycle Manager (OLM)](https://operator-framework.github.io/operator-controller/): a tool that helps install, update, and manage the lifecycle of all Operators and their associated services running across their clusters.

* Cluster Catalog: a custom resource that is defined by the OLM, it contains a list of available Operator bundles to the cluster.

* Cluster Extension: a custom resource that is managed by the OLM, it specifies a how to install of an operator from the cluster catalog.

* Catalog: our helm chart that deploys the Cluster Catalog and Cluster Extensions as well as the Model Orchestra CRD.

* Gateway: the entrypoint into the model orchestra, it receives all requests to individual models and routes them to the correct queue exposed by a grpc server.

* Reader: an individual model that is running in the model orchestra. It connects to the grpc server of the Gateway to pull requests and process them.

* Consumer Group: the Gateway manages many queues which are intended for specific readers. The group of collective readers that pull from a single queue is called a consumer group. Note, readers can belong to more than one consumer group, it is a mapping from one queue to many readers.
