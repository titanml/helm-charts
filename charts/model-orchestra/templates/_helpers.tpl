{{/*
Expand the name of the chart.
*/}}
{{- define "takeoff.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "takeoff.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "takeoff.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "takeoff.labels" -}}
helm.sh/chart: {{ include "takeoff.chart" . }}
{{ include "takeoff.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "takeoff.selectorLabels" -}}
app.kubernetes.io/name: {{ include "takeoff.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "takeoff.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "takeoff.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/* Set env vars for takeoff controller */}}
{{- define "takeoff.controllerEnv" -}}

{{/* Set the required env vars needed for each application deployment */}}
{{- $requiredEnv := dict }}
{{- $_ := set $requiredEnv "TAKEOFF_ADD_READER_ID_SUFFIX" (dict "value" "true") }}

{{/* Convert user set env vars into dict */}}
{{- $userEnv := dict }}
{{- range $envMap := .Values.controller.env }}
{{- if hasKey $envMap "value" }}
    {{- $_ := set $userEnv $envMap.name (dict "value" $envMap.value) }}
{{ else if hasKey $envMap "valueFrom" }}
    {{- $_ := set $userEnv $envMap.name (dict "valueFrom" $envMap.valueFrom) }}
{{- end }}
{{- end }}

{{/* Define the list to hold the env */}}
{{- $applicationEnv := list }}
{{/* Merge the template env with user env. Lets users overwrite default values. */}}
{{- $applicationEnvDict := merge $requiredEnv $userEnv }}

{{/* Loop through the merged env and append to the list */}}
{{- range $key, $value := $applicationEnvDict }}
    {{- if $value.value }}
        {{- $applicationEnv = append $applicationEnv (dict "name" $key "value" $value.value) }}
    {{- else if $value.valueFrom }}
        {{- $applicationEnv = append $applicationEnv (dict "name" $key "valueFrom" $value.valueFrom) }}
    {{- end }}
{{- end }}

{{- $applicationEnv | toYaml }}
{{- end }}