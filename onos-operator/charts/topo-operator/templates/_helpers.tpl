# SPDX-FileCopyrightText: 2022 2020-present Open Networking Foundation <info@opennetworking.org>
#
# SPDX-License-Identifier: Apache-2.0

{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "topo-operator.name" -}}
{{ include "onos-operator.name" . }}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "topo-operator.fullname" -}}
{{ include "onos-operator.fullname" . }}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "topo-operator.chart" -}}
{{ include "onos-operator.chart" . }}
{{- end -}}


{{/*
Common labels
*/}}
{{- define "topo-operator.labels" -}}
{{ include "onos-operator.labels" . }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "topo-operator.selectorLabels" -}}
{{ include "onos-operator.selectorLabels" . }}
{{- end -}}

{{/*
topo-operator image name
*/}}
{{- define "topo-operator.imagename" -}}
{{ include "onos-operator.imagename" . }}
{{- end -}}

{{/*
topo-operator scope
*/}}
{{- define "topo-operator.scope" -}}
{{ include "onos-operator.scope" . }}
{{- end -}}
