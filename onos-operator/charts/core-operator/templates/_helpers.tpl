{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "core-operator.name" -}}
{{ include "onos-operator.name" . }}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "core-operator.fullname" -}}
{{ include "onos-operator.fullname" . }}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "core-operator.chart" -}}
{{ include "onos-operator.chart" . }}
{{- end -}}


{{/*
Common labels
*/}}
{{- define "core-operator.labels" -}}
{{ include "onos-operator.labels" . }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "core-operator.selectorLabels" -}}
{{ include "onos-operator.selectorLabels" . }}
{{- end -}}

{{/*
core-operator image name
*/}}
{{- define "core-operator.imagename" -}}
{{ include "onos-operator.imagename" . }}
{{- end -}}

{{/*
core-operator scope
*/}}
{{- define "core-operator.scope" -}}
{{ include "onos-operator.scope" . }}
{{- end -}}
