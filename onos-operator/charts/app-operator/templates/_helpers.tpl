{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "app-operator.name" -}}
{{ include "onos-operator.name" . }}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "app-operator.fullname" -}}
{{ include "onos-operator.fullname" . }}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "app-operator.chart" -}}
{{ include "onos-operator.chart" . }}
{{- end -}}


{{/*
Common labels
*/}}
{{- define "app-operator.labels" -}}
{{ include "onos-operator.labels" . }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "app-operator.selectorLabels" -}}
{{ include "onos-operator.selectorLabels" . }}
{{- end -}}

{{/*
app-operator image name
*/}}
{{- define "app-operator.imagename" -}}
{{- if .Values.global.image.registry -}}
{{- printf "%s/" .Values.global.image.registry -}}
{{- else if .Values.image.registry -}}
{{- printf "%s/" .Values.image.registry -}}
{{- end -}}
{{- printf "%s:" .Values.image.repository -}}
{{- if .Values.global.image.tag -}}
{{- .Values.global.image.tag -}}
{{- else -}}
{{- .Values.image.tag -}}
{{- end -}}
{{- end -}}

{{/*
config-operator-init image name
*/}}
{{- define "config-operator-init.imagename" -}}
{{- if .Values.global.image.registry -}}
{{- printf "%s/" .Values.global.image.registry -}}
{{- else if .Values.image.registry -}}
{{- printf "%s/" .Values.image.registry -}}
{{- end -}}
{{- printf "onosproject/config-operator-init:" -}}
{{- if .Values.global.image.tag -}}
{{- .Values.global.image.tag -}}
{{- else -}}
{{- .Values.image.tag -}}
{{- end -}}
{{- end -}}

{{/*
app-operator scope
*/}}
{{- define "app-operator.scope" -}}
{{ include "onos-operator.scope" . }}
{{- end -}}
