# SPDX-FileCopyrightText: 2022-present Intel Corporation
#
# SPDX-License-Identifier: Apache-2.0

{{/*
Expand the name of the chart.
*/}}
{{- define "wcmp-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "wcmp-app.fullname" -}}
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
{{- define "wcmp-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "wcmp-app.labels" -}}
helm.sh/chart: {{ include "wcmp-app.chart" . }}
{{ include "wcmp-app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "wcmp-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "wcmp-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "wcmp-app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "wcmp-app.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
wcmp-app image name
*/}}
{{- define "wcmp-app.imagename" -}}
{{- if .Values.global.image.registry -}}
{{- printf "%s/" .Values.global.image.registry -}}
{{- else if .Values.image.registry -}}
{{- printf "%s/" .Values.image.registry -}}
{{- end -}}
{{- printf "%s:" .Values.image.repository -}}
{{- if .Values.global.image.tag -}}
{{- .Values.global.image.tag -}}
{{- else -}}
{{- tpl .Values.image.tag . -}}
{{- end -}}
{{- end -}}

{{/*
registry name
*/}}
{{- define "wcmp-app.registryname" -}}
{{- if .Values.global.image.registry -}}
{{- printf "%s/" .Values.global.image.registry -}}
{{- else if .Values.image.registry -}}
{{- printf "%s/" .Values.image.registry -}}
{{- end -}}
{{- end -}}

{{/*
wcmp-app consensus image name
*/}}
{{- define "wcmp-app.store.consensus.imagename" -}}
{{- if or .Values.store.consensus.image.tag .Values.global.store.consensus.image.tag -}}
{{- if .Values.global.store.consensus.image.registry -}}
{{- printf "%s/" .Values.global.store.consensus.image.registry -}}
{{- else if .Values.store.consensus.image.registry -}}
{{- printf "%s/" .Values.store.consensus.image.registry -}}
{{- end -}}
{{- printf "%s:" .Values.store.consensus.image.repository -}}
{{- if .Values.global.store.consensus.image.tag -}}
{{- .Values.global.store.consensus.image.tag -}}
{{- else -}}
{{- .Values.store.consensus.image.tag -}}
{{- end -}}
{{- else -}}
""
{{- end -}}
{{- end -}}

{{/*
wcmp-app consensus store name
*/}}
{{- define "wcmp-app.store.consensus.name" -}}
{{- if .Values.store.consensus.name -}}
{{- printf "%s" .Values.store.consensus.name -}}
{{- else -}}
{{- printf "%s-consensus-store" ( include "wcmp-app.fullname" . ) -}}
{{- end -}}
{{- end -}}