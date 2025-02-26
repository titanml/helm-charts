# TitanML Helm Charts

These chart allow you to deploy open source AI on Kubernetes at any scale.

## Pre-requisites

* Kubernetes 
* [kubectl](https://kubernetes.io/docs/reference/kubectl/kubectl/)
* [Helm](https://helm.sh/docs/intro/install/)

## Cluster Setup (optional)

We have certain cluster wide requirements necessary to allow our charts to run. You can install them by installing the `takeoff-system` helmfile [following the instructions here.](takeoff-system/README.md). This is a one off installation step and may already be completed, please check with your cluster administrator.

## Getting Started

We have two supported paths for users to control their AI deployments.

### Takeoff Management Console

This is a UI which is used to spin up and configured AI applications. This is useful for people less familiar with managing Kubernetes applications. Our deployment guide for this can be found [here](charts/takeoff-console/README.md).

### Takeoff Helm Chart

Interact directly with the helm chart to setup your own applications. This is recommended for more advanced users whom want more customisation. Our deployment guide for this can be found [here](charts/takeoff/README.md).
