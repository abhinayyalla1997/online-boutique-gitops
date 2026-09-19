{{/*
Common labels applied to every resource in this chart
*/}}
{{- define "online-boutique.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/part-of: online-boutique
{{- end }}

{{/*
Selector labels
*/}}
{{- define "online-boutique.selectorLabels" -}}
app: {{ .app }}
app.kubernetes.io/instance: {{ .release }}
{{- end }}

{{/*
Image helper — single ECR repo pattern
For ECR services (useGlobal: true), image.tag is the FULL tag as pushed by
CI/CD — already "<service-name>-<git-sha>" (see the app repo's ECR tagging
convention), so this does NOT re-prepend the service name:
  566279697030.dkr.ecr.us-east-1.amazonaws.com/online-boutique:frontend-<sha>
For Docker Hub services (useGlobal: false):
  redis:alpine
*/}}
{{- define "online-boutique.image" -}}
{{- $service := .service -}}
{{- $global := .global -}}
{{- if (default true $service.image.useGlobal) -}}
{{ $global.imageRegistry }}/{{ $global.imageRepository }}:{{ default $global.imageTag $service.image.tag }}
{{- else -}}
{{ $service.image.repository }}:{{ $service.image.tag }}
{{- end -}}
{{- end }}