# Takeoff System Dependencies

This directory contains a [Helmfile](https://helmfile.readthedocs.io/en/latest/) containing all the cluster wide dependencies needed run the [takeoff](../charts/takeoff/) or [takeoff-console](../charts/takeoff-console/) charts.

## Prerequisites
Before you begin, ensure you have the following installed:
- kubectl (version 1.18 or later)
- Helm (version 3.x)
- (optional if running `helmfile apply`) Helm diff plugin: [install guide](https://github.com/databus23/helm-diff?tab=readme-ov-file#install)

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

3. **Get Helmfile and Edit**
   a. Download the Helmfile configuration file:
   ```bash
   wget https://raw.githubusercontent.com/titanml/helm-charts/refs/heads/main/takeoff-system/helmfile.yaml
   ```
   b. Edit the `helmfile.yaml` file to customize the prometheus storage class to one available in your cluster:


4. **Deploy with Helmfile**
   Run the following command to deploy all dependencies:
   ```
   helmfile repos && helmfile sync
   # Or can run `helmfile apply` which will fetch from the repos, produce a diff and then sync.
   ```

5. **Verify Deployments**
   After deployment, verify that all components are running:
   ```bash
   kubectl get all -n keda
   kubectl get all -n monitoring
   kubectl get all -n argocd
   ```
