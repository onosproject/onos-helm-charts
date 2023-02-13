# SPDX-FileCopyrightText: 2022-present Intel Corporation
#
# SPDX-License-Identifier: Apache-2.0

{{/*
Expand the name of the chart.
*/}}
{{- define "fabric-underlay.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "fabric-underlay.fullname" -}}
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
{{- define "fabric-underlay.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "fabric-underlay.labels" -}}
helm.sh/chart: {{ include "fabric-underlay.chart" . }}
{{ include "fabric-underlay.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "fabric-underlay.selectorLabels" -}}
app.kubernetes.io/name: {{ include "fabric-underlay.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "fabric-underlay.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "fabric-underlay.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
fabric-underlay image name
*/}}
{{- define "fabric-underlay.imagename" -}}
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


{{- define "fabric-underlay.atomix.consensus.cluster.name" -}}
{{- if .Values.global.atomix.store.consensus.enabled -}}
{{- include "global.atomix.consensus.cluster.name" . -}}
{{- else -}}
{{- printf "%s-consensus" .Release.Name -}}
{{- end -}}
{{- end -}}

{{- define "fabric-underlay.atomix.consensus.store.name" -}}
{{- printf "%s-consensus" ( include "fabric-underlay.fullname" . ) -}}
{{- end -}}

{{- define "fabric-underlay.atomix.cache.store.name" -}}
{{- printf "%s-cache" ( include "fabric-underlay.fullname" . ) -}}
{{- end -}}
