{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "scalelite.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified api app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "scalelite.fullname" -}}
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

{{- define "scalelite.databaseUrl" -}}
{{- if .Values.postgresql.enabled }}
{{- printf "postgresql://%s:%s@%s-postgresql/%s" .Values.postgresql.postgresqlUsername .Values.postgresql.postgresqlPassword .Release.Name .Values.postgresql.postgresqlDatabase }}
{{- else }}
{{- .Values.databaseUrl }}
{{- end }}
{{- end }}

{{- define "scalelite.redisUrl" -}}
{{- if .Values.redis.enabled }}
{{- printf "redis://:%s@%s-redis-headless" .Values.redis.password .Release.Name }}
{{- else }}
{{- .Values.redisUrl }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "scalelite.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "scalelite.labels" -}}
helm.sh/chart: {{ include "scalelite.chart" . }}
{{ include "scalelite.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "scalelite.selectorLabels" -}}
app.kubernetes.io/name: {{ include "scalelite.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Nginx selector labels
*/}}
{{- define "scalelite.nginxSelectorLabels" -}}
app.kubernetes.io/name: {{ include "scalelite.name" . }}-nginx
app.kubernetes.io/instance: {{ .Release.Name }}-nginx
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "scalelite.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "scalelite.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
