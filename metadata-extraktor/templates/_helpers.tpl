{{/*
Expand the name of the chart.
*/}}
{{- define "metadata-extraktor.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "metadata-extraktor.fullname" -}}
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
{{- define "metadata-extraktor.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "metadata-extraktor.labels" -}}
helm.sh/chart: {{ include "metadata-extraktor.chart" . }}
{{ include "metadata-extraktor.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/created-by: {{ .Chart.Annotations.createdby }}
app.kubernetes.io/maintained-by: {{ .Chart.Annotations.maintainedby }}
app.kubernetes.io/component: {{ include "metadata-extraktor.name" . }}
app.kubernetes.io/part-of: {{ .Chart.Annotations.partof }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "metadata-extraktor.selectorLabels" -}}
app.kubernetes.io/name: {{ include "metadata-extraktor.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "metadata-extraktor.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "metadata-extraktor.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "metadata-extraktor.selectorLabelsNetwork" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "metadata-extraktor.selectorLabelsSideCar" -}}
app.kubernetes.io/name: {{ include "metadata-extraktor.name" . }}
{{- end }}

{{/*
Build image pull secret from docker login creds in the values.yaml
*/}}
{{- define "ulb.imagePullSecret" }}
{{- with .Values.image.imageCredentials }}
{{- printf "{\"auths\":{\"%s\":{\"username\":\"%s\",\"password\":\"%s\",\"auth\":\"%s\"}}}" .registry .username .password (printf "%s:%s" .username .password | b64enc) | b64enc }}
{{- end }}
{{- end }}

{{- define "ulb.environment" -}}
{{- if eq .Values.network.environment "prod-ms1"}}
wwu.io/nic_node: istio.ms1.k8s.wwu.de
{{- end }}
{{- if eq .Values.network.environment "prod-ms2"}}
wwu.io/nic_node: istio.ms2.k8s.wwu.de
{{- end }}
{{- if eq .Values.network.environment "staging-ms1"}}
wwu.io/nic_node: istio.ms1.staging.k8s.wwu.de
{{- end }}
{{- if eq .Values.network.environment "staging-ms2"}}
wwu.io/nic_node: istio.ms2.staging.k8s.wwu.de
{{- end }}
{{- end }}