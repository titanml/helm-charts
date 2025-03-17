# Build the manager binary
FROM quay.io/operator-framework/helm-operator:v1.39.1

ENV HOME=/opt/helm
COPY --chmod=777 watches.yaml ${HOME}/watches.yaml
COPY --chmod=777 helm-charts  ${HOME}/helm-charts

WORKDIR ${HOME}
