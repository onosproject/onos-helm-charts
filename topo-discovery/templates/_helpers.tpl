# SPDX-FileCopyrightText: 2022-present Intel Corporation
#
# SPDX-License-Identifier: Apache-2.0

{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "topo-discovery.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "topo-discovery.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "topo-discovery.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "topo-discovery.labels" -}}
helm.sh/chart: {{ include "topo-discovery.chart" . }}
{{ include "topo-discovery.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "topo-discovery.selectorLabels" -}}
app.kubernetes.io/name: {{ include "topo-discovery.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
topo-discovery image name
*/}}
{{- define "topo-discovery.imagename" -}}
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
