# System Dependencies

This directory contains a [Helmfile](https://helmfile.readthedocs.io/en/latest/) containing all the cluster wide dependencies needed run the [model-orchestra](../charts/model-orchestra/) or [console](../charts/console/) charts.

## Prerequisites
Before you begin, ensure you have the following installed:
- kubectl (version 1.18 or later)
- Helm (version 3.x)
- Helm diff plugin (optional if running `helmfile apply`): [install guide](https://github.com/databus23/helm-diff?tab=readme-ov-file#install)

## Installation

1. **Install Helmfile**
   Install Helmfile by following the instructions in the [official documentation](https://helmfile.readthedocs.io/en/latest/#installation) or if using linux:
   ```bash
   mkdir -p /tmp/helmfile/ && \
      sudo wget -P /tmp/helmfile/ https://github.com/helmfile/helmfile/releases/download/v1.0.0-rc.11/helmfile_1.0.0-rc.11_linux_amd64.tar.gz && \ 
      sudo tar -xxf /tmp/helmfile/helmfile_1.0.0-rc.11_linux_amd64.tar.gz -C /tmp/helmfile/ && \
      sudo mv /tmp/helmfile/helmfile /usr/local/bin && \
      sudo chmod +x /usr/local/bin/helmfile && \
      rm -rf /tmp/helmfile/
   ```
   or if using macOS:
   ```bash
   brew install helmfile
   ```

2. **Create Required Namespaces**
   Create the necessary namespaces for each dependency:
   ```bash
   kubectl create namespace keda && \
      kubectl create namespace monitoring && \
      kubectl create namespace argocd && \
      kubectl create namespace model-orchestra-operator-system
   ```

3. **Install Operator Lifecycle Manager (OLM)**
   ```bash
   curl -L -s https://github.com/operator-framework/operator-controller/releases/latest/download/install.sh | bash -s
   ```

3. **Get Helmfile and Edit**
   a. Download the Helmfile configuration file:
   ```bash
   wget https://raw.githubusercontent.com/titanml/helm-charts/refs/heads/main/system/helmfile.yaml
   ```
   b. **Important:** Edit the `helmfile.yaml` file to customize the prometheus storage class to one available in your cluster:


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
   kubectl get all -n model-orchestra-operator-system
   ```
