# SPDX-FileCopyrightText: 2022 2020-present Open Networking Foundation <info@opennetworking.org>
#
# SPDX-License-Identifier: Apache-2.0

{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "global.name" -}}
{{- default .Chart.Name .Values.global.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "global.fullname" -}}
{{- if .Values.global.fullnameOverride -}}
{{- .Values.global.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.global.nameOverride -}}
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
{{- define "global.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "global.labels" -}}
helm.sh/chart: {{ include "global.chart" . }}
{{ include "global.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "global.selectorLabels" -}}
app.kubernetes.io/name: {{ include "global.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
global consensus image name
*/}}
{{- define "global.atomix.store.consensus.imagename" -}}
{{- if .Values.global.atomix.store.consensus.image.tag -}}
{{- if .Values.global.atomix.store.consensus.image.registry -}}
{{- printf "%s/" .Values.global.atomix.store.consensus.image.registry -}}
{{- end -}}
{{- printf "%s:" .Values.global.atomix.store.consensus.image.repository -}}
{{- .Values.global.atomix.store.consensus.image.tag -}}
{{- else -}}
""
{{- end -}}
{{- end -}}



{{- define "global.atomix.consensus.cluster.name" -}}
{{- with .Values.global.atomix.store.consensus.name -}}
{{- . -}}
{{- else -}}
{{- printf "%s-consensus" .Release.Name -}}
{{- end -}}
{{- end -}}