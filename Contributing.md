# Product

We deploy AI models and expose intuitive APIs for customers to build with. The user interacts through a console/UI that lets them control anything about their deployed models.

### Terminology

* Cluster: a group of computing nodes, or worker machines, that run containerized applications, managed by a control plane that orchestrates and manages the cluster's resources and workloads.

* Console: a management interface that allows users to manipulate model orchestras. It also can be used for observability of the deployed models.

* Custom Resource Definition: a kubernetes object that extends the Kubernetes API and is available for use in the cluster.

* Model Orchestra: the custom resource that we deploy which has the configuration for each application that the user wants to be realised by the model orchestra operator.

* Controller: a set of objects that are responsible to transforming a custom resource into a set of kubernetes native objects. Any custom resource that is deployed in the cluster is managed by an operator.

* Operator: the combination of a Custom Resource Definition and a Controller.

* Operator Lifecycle Manager (OLM): a tool that helps install, update, and manage the lifecycle of all Operators and their associated services running across their clusters.

* Cluster Catalog: a custom resource that is defined by the OLM, it contains a list of available Operator bundles to the cluster.

* Cluster Extension: a custom resource that is managed by the OLM, it specifies a how to install of an operator from the cluster catalog.

* Gateway: the entrypoint into the model orchestra, it receives all requests to individual models and routes them to the correct queue exposed by a grpc server.

* Reader: an individual model that is running in the model orchestra. It connects to the grpc server of the Gateway to pull requests and process them.

* Consumer Group: the Gateway manages many queues which are intended for specific readers. The group of collective readers that pull from a single queue is called a consumer group. Note, readers can belong to more than one consumer group, it is a mapping from one queue to many readers.


### What do we deploy?

