# Takeoff Operator Lifecycle Manager

The Takeoff Operator Lifecycle Manager (OLM) is a Kubernetes operator that manages the lifecycle of the Takeoff operator. It is responsible for installing the Takeoff operator and managing its lifecycle.

## Working thoughts

The OLM is a Kubernetes operator that manages the lifecycle of the Takeoff operator. This is essentially following the [OLM docs here](https://olm.operatorframework.io/docs/tasks/). The current working idea is to:
* Bundle up the operator so we can have versioned releases, these will be selected when you are deploying the Takeoff CR by apiVersion.
* Create a catalog in each cluster which can store the bundles. 
* Create subscriptions to the catalog to install the specific versions of the operator wanted.

### Installing the OLM

```bash
# Install the OLM binary
export ARCH=$(case $(uname -m) in x86_64) echo -n amd64 ;; aarch64) echo -n arm64 ;; *) echo -n $(uname -m) ;; esac) && \
    export OS=$(uname | awk '{print tolower($0)}') && \
    export OPERATOR_SDK_DL_URL=https://github.com/operator-framework/operator-sdk/releases/download/v1.39.1 && \
    curl -LO ${OPERATOR_SDK_DL_URL}/operator-sdk_${OS}_${ARCH}

# Make the binary executable and move into your PATH
chmod +x operator-sdk_${OS}_${ARCH} && sudo mv operator-sdk_${OS}_${ARCH} /usr/local/bin/operator-sdk
# Check the install
operator-sdk version
# Install OLM into the cluster
operator-sdk olm install

# Or could just be this script
curl -L -s https://github.com/operator-framework/operator-controller/releases/latest/download/install.sh | bash -s
```

### Bundle the operator

We need a `ClusterServiceVersion` (CSV) to define the template for the operator, it is analogous to a `Deployment` to a `Pod`. Together, your CSV and CRDs will form the package that you give to OLM to install an operator.

```bash
# Create bundle and push new bundle image
make bundle
make bundle-build-push

# Add to catalog
make add-bundle-to-catalog
make catalog-build-push

# Deploy catalog to cluster
make deploy-catalog
```