# SPDX-FileCopyrightText: 2022 2020-present Open Networking Foundation <info@opennetworking.org>
#
# SPDX-License-Identifier: Apache-2.0

{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "onos-topo.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "onos-topo.fullname" -}}
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
{{- define "onos-topo.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "onos-topo.labels" -}}
helm.sh/chart: {{ include "onos-topo.chart" . }}
{{ include "onos-topo.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "onos-topo.selectorLabels" -}}
app.kubernetes.io/name: {{ include "onos-topo.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
onos-topo image name
*/}}
{{- define "onos-topo.imagename" -}}
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
onos-topo consensus image name
*/}}
{{- define "onos-topo.atomix.store.multiRaft.imagename" -}}
{{- if or .Values.atomix.store.multiRaft.image.tag .Values.global.atomix.store.multiRaft.image.tag -}}
{{- if .Values.global.atomix.store.multiRaft.image.registry -}}
{{- printf "%s/" .Values.global.atomix.store.multiRaft.image.registry -}}
{{- else if .Values.atomix.store.multiRaft.image.registry -}}
{{- printf "%s/" .Values.atomix.store.multiRaft.image.registry -}}
{{- end -}}
{{- printf "%s:" .Values.atomix.store.multiRaft.image.repository -}}
{{- if .Values.global.atomix.store.multiRaft.image.tag -}}
{{- .Values.global.atomix.store.multiRaft.image.tag -}}
{{- else -}}
{{- .Values.atomix.store.multiRaft.image.tag -}}
{{- end -}}
{{- else -}}
""
{{- end -}}
{{- end -}}

{{/*
onos-topo consensus store name
*/}}
{{- define "onos-topo.atomix.store.multiRaft.name" -}}
{{- if .Values.global.atomix.store.multiRaft.enabled -}}
{{- if .Values.global.atomix.store.multiRaft.name -}}
{{- printf "%s" .Values.global.atomix.store.multiRaft.name -}}
{{- else -}}
{{- printf "%s-consensus-store" ( include "global.fullname" . ) -}}
{{- end -}}
{{- else -}}
{{- if .Values.atomix.store.multiRaft.name -}}
{{- printf "%s" .Values.atomix.store.multiRaft.name -}}
{{- else -}}
{{- printf "%s-consensus-store" ( include "onos-topo.fullname" . ) -}}
{{- end -}}
{{- end -}}
{{- end -}}
