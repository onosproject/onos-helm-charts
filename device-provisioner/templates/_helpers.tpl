# SPDX-FileCopyrightText: 2022-present Intel Corporation
#
# SPDX-License-Identifier: Apache-2.0

{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "device-provisioner.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "device-provisioner.fullname" -}}
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
{{- define "device-provisioner.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "device-provisioner.labels" -}}
helm.sh/chart: {{ include "device-provisioner.chart" . }}
{{ include "device-provisioner.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "device-provisioner.selectorLabels" -}}
app.kubernetes.io/name: {{ include "device-provisioner.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
device-provisioner image name
*/}}
{{- define "device-provisioner.imagename" -}}
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
device-provisioner consensus image name
*/}}
{{- define "device-provisioner.atomix.store.consensus.imagename" -}}
{{- if or .Values.atomix.store.consensus.image.tag .Values.global.atomix.store.consensus.image.tag -}}
{{- if .Values.global.atomix.store.consensus.image.registry -}}
{{- printf "%s/" .Values.global.atomix.store.consensus.image.registry -}}
{{- else if .Values.atomix.store.consensus.image.registry -}}
{{- printf "%s/" .Values.atomix.store.consensus.image.registry -}}
{{- end -}}
{{- printf "%s:" .Values.atomix.store.consensus.image.repository -}}
{{- if .Values.global.atomix.store.consensus.image.tag -}}
{{- .Values.global.atomix.store.consensus.image.tag -}}
{{- else -}}
{{- .Values.atomix.store.consensus.image.tag -}}
{{- end -}}
{{- else -}}
""
{{- end -}}
{{- end -}}

{{/*
device-provisioner consensus store name
*/}}
{{- define "device-provisioner.atomix.store.consensus.name" -}}
{{- if .Values.global.atomix.store.consensus.enabled -}}
{{- if .Values.global.atomix.store.consensus.name -}}
{{- printf "%s" .Values.global.atomix.store.consensus.name -}}
{{- else -}}
{{- printf "%s-consensus-store" ( include "global.fullname" . ) -}}
{{- end -}}
{{- else -}}
{{- if .Values.atomix.store.consensus.name -}}
{{- printf "%s" .Values.atomix.store.consensus.name -}}
{{- else -}}
{{- printf "%s-consensus-store" ( include "device-provisioner.fullname" . ) -}}
{{- end -}}
{{- end -}}
{{- end -}}