{{/* vim: set filetype=mustache: */}}
{{/* API versions for various resources and version-dependent feature flags. */}}

{{/* API version of Ingress. */}}
{{- define "imgproxy.versions.ingress" -}}
    {{- $kubeVersion := $.Capabilities.KubeVersion.Version }}
    {{- $apiVersions := $.Capabilities.APIVersions }}

    {{- if ($kubeVersion | semverCompare ">=1.22.0-0") -}}
        {{- if $apiVersions.Has "networking.k8s.io/v1" -}}
            {{- "networking.k8s.io/v1" -}}
        {{- end -}}
    {{- else if ($kubeVersion | semverCompare ">=1.19.0-0" | and ($apiVersions.Has "networking.k8s.io/v1")) -}}
        {{- "networking.k8s.io/v1" -}}
    {{- else if ($kubeVersion | semverCompare ">=1.14.0-0" | and ($apiVersions.Has "networking.k8s.io/v1beta1")) -}}
        {{- "networking.k8s.io/v1beta1" -}}
    {{- else if $apiVersions.Has "extensions/v1beta1" -}}
        {{- "extensions/v1beta1" -}}
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

{{/* API version of HorizontalPodAutoscaler. */}}
{{- define "imgproxy.versions.horizontalPodAutoscaler" -}}
    {{- $kubeVersion := $.Capabilities.KubeVersion.Version }}
    {{- $apiVersions := $.Capabilities.APIVersions }}

    {{- if $kubeVersion | semverCompare ">=1.23.0-0" -}}
        {{- "autoscaling/v2" -}}
    {{- else if $kubeVersion | semverCompare ">=1.19.0-0" | and ($apiVersions.Has "autoscaling/v2") -}}
        {{- "autoscaling/v2" -}}
    {{- else if $kubeVersion | semverCompare ">=1.12.0-0" | and ($apiVersions.Has "autoscaling/v2beta2") -}}
        {{- "autoscaling/v2beta2" -}}
    {{- else if $apiVersions.Has "autoscaling/v2beta1" }}
        {{- "autoscaling/v2beta1" -}}
    {{- end -}}
{{- end -}}

{{/* API version of pod disrutption budget */}}
{{- define "imgproxy.versions.podDisruptionBudget" }}
    {{- $kubeVersion := $.Capabilities.KubeVersion.Version }}
    {{- $apiVersions := $.Capabilities.APIVersions }}

    {{- if $kubeVersion | semverCompare ">=1.21.0-0" -}}
        {{- "policy/v1" -}}
    {{- else if $apiVersions.Has "policy/v1" }}
        {{- "policy/v1" -}}
    {{- else if $apiVersions.Has "policy/v1beta1" }}
        {{- "policy/v1beta1" -}}
    {{- end -}}
{{- end -}}

{{/* Check if preemption policy is supported for PriorityClass. */}}
{{- define "imgproxy.versions.features.priorityClassPreemptionPolicy" -}}
    {{- $.Capabilities.KubeVersion.Version | semverCompare ">= 1.19.0-0" }}
{{- end }}
