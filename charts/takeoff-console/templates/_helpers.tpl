{{/*
Expand the name of the chart.
*/}}
{{- define "takeoff-console.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "takeoff-console.fullname" -}}
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
{{- define "takeoff-console.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "takeoff-console.labels" -}}
helm.sh/chart: {{ include "takeoff-console.chart" . }}
{{ include "takeoff-console.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "takeoff-console.selectorLabels" -}}
app.kubernetes.io/name: {{ include "takeoff-console.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "takeoff-console.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "takeoff-console.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/* Define the Takeoff CR name */}}
{{- define "takeoff-console.takeoffCrName" -}}
{{- printf "%s-t" (include "takeoff-console.fullname" .) -}}
{{- end }}

{{/* Create Backend Environment Variables for Zeus */}}
{{- define "takeoff-console.zeusBackendEnv" -}}

{{/* Create a template for necessary environment variables for Zeus backend */}}
{{- $templateEnv := dict }}
{{- $_ := set $templateEnv "ZEUS_DROP_TABLES_ON_INIT" (dict "value" "False") }}
{{- $_ := set $templateEnv "ZEUS_DB_HOST" (dict "value" (printf "%s-db" (include "takeoff-console.fullname" .))) }}
{{- $_ := set $templateEnv "ZEUS_DB_PORT" (dict "value" "5432") }}
{{- $_ := set $templateEnv "ZEUS_DB_NAME" (dict "value" "zeus") }}
{{- $_ := set $templateEnv "ZEUS_TAKEOFF_CR_NAME" (dict "value" (include "takeoff-console.takeoffCrName" .)) }}
{{- if .Values.secret.generate }}
    {{- $_ := set $templateEnv "ZEUS_DB_USER" (dict "valueFrom" (dict "secretKeyRef" (dict "name" (printf "%s-%s" (include "takeoff-console.fullname" .) .Values.secret.name) "key" .Values.secret.keys.dbUser))) }}
    {{- $_ := set $templateEnv "ZEUS_DB_PASSWORD" (dict "valueFrom" (dict "secretKeyRef" (dict "name" (printf "%s-%s" (include "takeoff-console.fullname" .) .Values.secret.name) "key" .Values.secret.keys.dbPassword))) }}
{{- else }}
    {{- $_ := set $templateEnv "ZEUS_DB_USER" (dict "valueFrom" (dict "secretKeyRef" (dict "name" .Values.secret.name "key" .Values.secret.keys.dbUser))) }}
    {{- $_ := set $templateEnv "ZEUS_DB_PASSWORD" (dict "valueFrom" (dict "secretKeyRef" (dict "name" .Values.secret.name "key" .Values.secret.keys.dbPassword))) }}
{{- end }}
{{- $_ := set $templateEnv "ZEUS_HELM_NAMESPACE" (dict "value" .Release.Namespace) }}
{{- $_ := set $templateEnv "ZEUS_HELM_RELEASE" (dict "value" (include "takeoff-console.fullname" .)) }}

{{/* Convert user set env vars into dict */}}
{{- $userEnv := dict }}
{{- range $envMap := .Values.backend.env }}
{{- if hasKey $envMap "value" }}
    {{- $_ := set $userEnv $envMap.name (dict "value" $envMap.value) }}
{{ else if hasKey $envMap "valueFrom" }}
    {{- $_ := set $userEnv $envMap.name (dict "valueFrom" $envMap.valueFrom) }}
{{- end }}
{{- end }}

{{/* Define the list to hold the env */}}
{{- $zeusBackendEnv := list }}
{{/* Merge the template env with user env. Lets users overwrite default values. */}}
{{- $zeusBackendEnvDict := merge $userEnv $templateEnv }}

{{/* Loop through the merged env and append to the list */}}
{{- range $key, $value := $zeusBackendEnvDict }}
    {{- if $value.value }}
        {{- $zeusBackendEnv = append $zeusBackendEnv (dict "name" $key "value" $value.value) }}
    {{- else if $value.valueFrom }}
        {{- $zeusBackendEnv = append $zeusBackendEnv (dict "name" $key "valueFrom" $value.valueFrom) }}
    {{- end }}
{{- end }}

{{- $zeusBackendEnv | toYaml }}
{{- end }}

{{/* Create Frontend Environment Variables for Zeus */}}
{{- define "takeoff-console.zeusFrontendEnv" -}}

{{/* Create a template for necessary environment variables for Zeus frontend */}}
{{- $templateEnv := dict }}
{{- $_ := set $templateEnv "ZEUS_TAKEOFF_CR_NAME" (dict "value" (include "takeoff-console.takeoffCrName" .)) }}
{{/* Add any other frontend-specific env vars here */}}

{{/* Convert user set env vars into dict */}}
{{- $userEnv := dict }}
{{- range $envMap := .Values.frontend.env }}
{{- if hasKey $envMap "value" }}
    {{- $_ := set $userEnv $envMap.name (dict "value" $envMap.value) }}
{{ else if hasKey $envMap "valueFrom" }}
    {{- $_ := set $userEnv $envMap.name (dict "valueFrom" $envMap.valueFrom) }}
{{- end }}
{{- end }}

{{/* Define the list to hold the env */}}
{{- $zeusFrontendEnv := list }}
{{/* Merge the template env with user env. Lets users overwrite default values. */}}
{{- $zeusFrontendEnvDict := merge $userEnv $templateEnv }}

{{/* Loop through the merged env and append to the list */}}
{{- range $key, $value := $zeusFrontendEnvDict }}
    {{- if $value.value }}
        {{- $zeusFrontendEnv = append $zeusFrontendEnv (dict "name" $key "value" $value.value) }}
    {{- else if $value.valueFrom }}
        {{- $zeusFrontendEnv = append $zeusFrontendEnv (dict "name" $key "valueFrom" $value.valueFrom) }}
    {{- end }}
{{- end }}

{{- $zeusFrontendEnv | toYaml }}
{{- end }}