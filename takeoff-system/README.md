# helm-deployment-project/helm-deployment-project/README.md

# Helm Deployment Project

This project is designed to facilitate the deployment of various dependencies required for the Titan Takeoff Stack using Helmfile. It provides a structured approach to manage Helm releases across different namespaces, ensuring that each component is deployed in an organized manner.

## Purpose

The primary goal of this project is to streamline the deployment process of the Titan Takeoff Stack dependencies, including KEDA, kube-prometheus-stack, and Argo CD. By using Helmfile, we can define and manage multiple Helm releases in a single configuration file.

## Prerequisites
Before you begin, ensure you have the following installed:
- kubectl (version 1.18 or later)
- Helm (version 3.x)
- Helm diff plugin: [install guide](https://github.com/databus23/helm-diff?tab=readme-ov-file#install)

## Usage

1. **Install Helmfile**
   Install Helmfile by following the instructions in the [official documentation](https://helmfile.readthedocs.io/en/latest/#installation) or if using linux:
   ```bash
   sudo wget https://github.com/helmfile/helmfile/releases/download/v1.0.0-rc.11/helmfile_1.0.0-rc.11_linux_amd64.tar.gz && \ 
      sudo tar -xxf helmfile_1.0.0-rc.11_linux_amd64.tar.gz && \
      sudo rm helmfile_1.0.0-rc.11_linux_amd64.tar.gz && \
      sudo mv helmfile /usr/local/bin
   ```

2. **Create Required Namespaces**
   Create the necessary namespaces for each dependency:
   ```bash
   kubectl create namespace keda
   kubectl create namespace monitoring
   kubectl create namespace argocd
   ```

3. **Deploy with Helmfile**
   Run the following command to deploy all dependencies:
   ```
   TAKEOFF_SYSTEM_STORAGE_CLASS=<name-of-storage-class-in-your-cluster> helmfile apply -f https://raw.githubusercontent.com/titanml/helm-charts/refs/heads/main/takeoff-system/helmfile.yaml
   ```

4. **Verify Deployments**
   After deployment, verify that all components are running:
   ```bash
   kubectl get all -n keda
   kubectl get all -n monitoring
   kubectl get all -n argocd
   ```
