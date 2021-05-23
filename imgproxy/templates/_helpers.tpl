{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "imgproxy.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "imgproxy.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- default (printf "%s-%s" .Release.Name $name) .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Template to generate secrets for a private Docker repository for K8s to use
*/}}
{{- define "imgproxy.imagePullSecrets" }}
{{- with .Values.image.pullSecrets -}}
{{- if .enabled }}
{{- $username := required "image.pullSecrets.username" .username -}}
{{- $registry := required "image.pullSecrets.registry" .registry -}}
{{- $password := required "image.pullSecrets.password" .password -}}
{{- printf "{\"auths\": {\"%s\": {\"auth\": \"%s\"}}}" $registry (printf "%s:%s" $username $password | b64enc) | b64enc }}
{{- end }}
{{- end -}}
{{- end -}}

{{/*
Template to generate service account annotation for AWS IAM Role
https://docs.aws.amazon.com/eks/latest/userguide/specify-service-account-role.html
*/}}
{{- define "aws.iamRoleAnnotation" }}
{{- with .Values.features.aws -}}
{{- $id := required "features.aws.accountId" .accountId -}}
{{- $role := required "features.aws.iamRoleName" .iamRoleName -}}
{{- $value := printf "arn:aws:iam::%s:role/%s" $id $role -}}
{{- printf "eks.amazonaws.com/role-arn: %s" (quote $value) }}
{{- end }}
{{- end -}}
