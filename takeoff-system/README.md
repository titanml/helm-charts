# helm-deployment-project/helm-deployment-project/README.md

# Helm Deployment Project

This project is designed to facilitate the deployment of various dependencies required for the Titan Takeoff Stack using Helmfile. It provides a structured approach to manage Helm releases across different namespaces, ensuring that each component is deployed in an organized manner.

## Purpose

The primary goal of this project is to streamline the deployment process of the Titan Takeoff Stack dependencies, including KEDA, kube-prometheus-stack, and Argo CD. By using Helmfile, we can define and manage multiple Helm releases in a single configuration file.

## Prerequisites
Before you begin, ensure you have the following installed:
- Helm (version 3.x)
- kubectl (version 1.18 or later)

## Usage

1. **Install Helmfile**
   Install Helmfile by following the instructions in the [official documentation] or if using linux:
   ```bash
   curl -sSL https://raw.githubusercontent.com/upciti/wakemeops/main/assets/install_repository | sudo bash
   sudo apt install helmfile
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
   helmfile apply
   ```

4. **Verify Deployments**
   After deployment, verify that all components are running:
   ```bash
   kubectl get all -n keda
   kubectl get all -n monitoring
   kubectl get all -n argocd
   ```
