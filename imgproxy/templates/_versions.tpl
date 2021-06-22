{{/* vim: set filetype=mustache: */}}
{{/* API versions for various resources and version-dependent feature flags. */}}

{{/* API version of Ingress. */}}
{{- define "imgproxy.versions.ingress" -}}
    {{- $kubeVersion := $.Capabilities.KubeVersion.Version }}
    {{- $apiVersions := $.Capabilities.APIVersions }}

    {{- if ($kubeVersion | semverCompare "<1.14.0-0" | and ($apiVersions.Has "extensions/v1beta1")) -}}
        {{- "extensions/v1beta1" -}}
    {{- else if ($kubeVersion | semverCompare "<1.20.0-0" | and ($apiVersions.Has "networking.k8s.io/v1beta1")) -}}
        {{- "networking.k8s.io/v1beta1" -}}
    {{- else if $apiVersions.Has "networking.k8s.io/v1" -}}
        {{- "networking.k8s.io/v1" -}}
    {{- end -}}
{{- end -}}

{{/* API version of PriorityClass. */}}
{{- define "imgproxy.versions.priorityClass" -}}
    {{- $kubeVersion := $.Capabilities.KubeVersion.Version }}
    {{- $apiVersions := $.Capabilities.APIVersions }}

    {{- if ($kubeVersion | semverCompare "<1.14.0-0" | and ($apiVersions.Has "scheduling.k8s.io/v1beta1")) -}}
        {{- "scheduling.k8s.io/v1beta1" -}}
    {{- else if $apiVersions.Has "scheduling.k8s.io/v1" }}
        {{- "scheduling.k8s.io/v1" -}}
    {{- end -}}
{{- end -}}

{{/* Check if preemption policy is supported for PriorityClass. */}}
{{- define "imgproxy.versions.features.priorityClassPreemptionPolicy" -}}
    {{- $.Capabilities.KubeVersion.Version | semverCompare ">= 1.19.0-0" }}
{{- end }}
