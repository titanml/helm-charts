# Takeoff System Dependencies

This directory contains a [Helmfile](https://helmfile.readthedocs.io/en/latest/) containing all cluster wide dependencies needed run the [takeoff](../charts/takeoff/) or [takeoff-console](../charts/takeoff-console/) charts.

## Prerequisites
Before you begin, ensure you have the following installed:
- kubectl (version 1.18 or later)
- Helm (version 3.x)
- Helm diff plugin (optional, only required if running `helmfile apply`): [install guide](https://github.com/databus23/helm-diff?tab=readme-ov-file#install)

## Usage

1. **Install Helmfile**
   Install Helmfile by following the instructions in the [official documentation](https://helmfile.readthedocs.io/en/latest/#installation).

   If using linux:
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

2. **Deploy with Helmfile**
   From this directory, run the following command to deploy all dependencies:
   ```
   PROMETHEUS_STORAGE_CLASS="<storage-class>" helmfile sync
   # `helmfile apply` can be used on a live cluster instead of `sync`: and will only apply changes.
   # The PROMETHEUS_STORAGE_CLASS environment variable must be supplied.
   ```

   See `values.yaml` for configuration.

4. **Verify Deployments**
   After deployment, verify that all components are running:
   ```bash
   kubectl get all -n keda
   kubectl get all -n monitoring
   kubectl get all -n argocd
   ```
