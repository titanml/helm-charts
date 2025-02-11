## Usage

[Helm](https://helm.sh) must be installed to use the charts.  Please refer to
Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo as follows:

  helm repo add titanml https://titanml.github.io/helm-charts

If you had already added this repo earlier, run `helm repo update` to retrieve
the latest versions of the packages.  You can then run `helm search repo
titanml` to see the charts.

To install the takeoff chart:

    helm install takeoff titanml/takeoff

To uninstall the chart:

    helm uninstall takeoff


You can also access the example `values.yaml` files and more from [our release repository.](https://github.com/titanml/helm-charts)
