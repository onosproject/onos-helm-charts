# SPDX-FileCopyrightText: 2022 2020-present Open Networking Foundation <info@opennetworking.org>
#
# SPDX-License-Identifier: Apache-2.0

{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "onos-config.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "onos-config.fullname" -}}
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
{{- define "onos-config.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
Common labels
*/}}
{{- define "onos-config.labels" -}}
helm.sh/chart: {{ include "onos-config.chart" . }}
{{ include "onos-config.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "onos-config.selectorLabels" -}}
app.kubernetes.io/name: {{ include "onos-config.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
onos-config image name
*/}}
{{- define "onos-config.imagename" -}}
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
onos-config consensus image name
*/}}
{{- define "onos-config.atomix.store.multiRaft.imagename" -}}
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
onos-config consensus store name
*/}}
{{- define "onos-config.atomix.store.multiRaft.name" -}}
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
{{- printf "%s-consensus-store" ( include "onos-config.fullname" . ) -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
openpolicyagent image name
*/}}
{{- define "openpolicyagent.imagename" -}}
{{- if .Values.global.openpolicyagent.image.registry -}}
{{- printf "%s/" .Values.global.openpolicyagent.image.registry -}}
{{- else if .Values.openpolicyagent.image.registry -}}
{{- printf "%s/" .Values.openpolicyagent.image.registry -}}
{{- end -}}
{{- printf "%s:" .Values.openpolicyagent.image.repository -}}
{{- if .Values.global.openpolicyagent.image.tag -}}
{{- .Values.global.openpolicyagent.image.tag -}}
{{- else -}}
{{- .Values.openpolicyagent.image.tag -}}
{{- end -}}
{{- end -}}

{{/*
  modelPlugins image names,
  takes the image name and the .Values to add the registry if any.
*/}}
{{- define "modelplugin.imagename" -}}
{{- if .Values.global.image.registry -}}
{{- printf "%s/" .Values.global.image.registry -}}
{{- else if .Values.image.registry -}}
{{- printf "%s/" .Values.image.registry -}}
{{- end -}}
{{- printf "%s" .image -}}
{{- end -}}
