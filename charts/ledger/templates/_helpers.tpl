{{- define "ledger.labels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/* Usage: include "ledger.componentLabels" (list . "api") */}}
{{- define "ledger.componentLabels" -}}
{{ include "ledger.labels" (index . 0) }}
app.kubernetes.io/component: {{ index . 1 }}
{{- end }}

{{- define "ledger.image" -}}
{{ required "image.registry is required" .Values.image.registry }}/ledger:{{ required "image.tag is required" .Values.image.tag }}
{{- end }}

{{- define "ledger.postgresHost" -}}
{{ .Release.Name }}-postgres
{{- end }}

{{- define "ledger.dbAddress" -}}
{{ include "ledger.postgresHost" . }}:5432/ledger?sslmode=disable
{{- end }}
