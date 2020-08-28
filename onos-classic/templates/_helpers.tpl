{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 24 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 60 chars because some Kubernetes name fields are limited to 63 (by the DNS naming spec).
*/}}
{{- define "fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 60 | trimSuffix "-" -}}
{{- end -}}

{{- define "atomix.fullname" -}}
{{- printf "%s-%s" .Release.Name "atomix" | trunc 59 | trimSuffix "-" -}}
{{- end -}}

{{- define "onos-apps" -}}
{{- join "," . -}}
{{- end -}}
