<p align="center">
  <a href="https://imgproxy.net">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="assets/logo-dark.svg?sanitize=true">
      <source media="(prefers-color-scheme: light)" srcset="assets/logo-light.svg?sanitize=true">
      <img alt="imgproxy logo" src="assets/logo-light.svg?sanitize=true">
    </picture>
  </a>
</p>

<p align="center"><strong>
  <a href="https://imgproxy.net">Website</a> |
  <a href="https://imgproxy.net/blog/">Blog</a> |
  <a href="https://docs.imgproxy.net">Documentation</a> |
  <a href="https://imgproxy.net/#pro">imgproxy Pro</a>
</strong></p>

<p align="center">
  <a href="https://github.com/imgproxy/imgproxy/pkgs/container/imgproxy"><img alt="Docker" src="https://img.shields.io/badge/Docker-0068F1?style=for-the-badge&logo=docker&logoColor=fff" /></a>
  <a href="https://bsky.app/profile/imgproxy.net"><img alt="Bluesky" src="https://img.shields.io/badge/Bluesky-0068F1?style=for-the-badge&logo=bluesky&logoColor=fff" /></a>
  <a href="https://x.com/imgproxy_net"><img alt="X" src="https://img.shields.io/badge/X.com-0068F1?style=for-the-badge&logo=x&logoColor=fff" /></a>
  <a href="https://mastodon.social/@imgproxy"><img alt="X" src="https://img.shields.io/badge/Mastodon-0068F1?style=for-the-badge&logo=mastodon&logoColor=fff" /></a>
  <a href="https://discord.gg/5GgpXgtC9u"><img alt="Discord" src="https://img.shields.io/badge/Discord-0068F1?style=for-the-badge&logo=discord&logoColor=fff" /></a>
</p>

<p align="center">
  <a href="https://github.com/imgproxy/imgproxy-helm/actions">
    <img alt="GH Check" src="https://img.shields.io/github/actions/workflow/status/imgproxy/imgproxy-helm/check.yml?branch=master&label=Check&style=for-the-badge" />
  </a>
</p>

---

This repo contains a [Helm chart](https://github.com/imgproxy/imgproxy-helm/tree/master/imgproxy) to deploy imgproxy.

[imgproxy](https://github.com/imgproxy/imgproxy#imgproxy) is a fast and secure standalone server for resizing and converting remote images. The main principles of imgproxy are simplicity, speed, and security.

## TL;DR

To install imgproxy to your kubernetes cluster simply run:

```shell
helm repo add imgproxy https://helm.imgproxy.net/

helm upgrade -i imgproxy imgproxy/imgproxy
```

> [!IMPORTANT]
> This readme shows documentation for chart version 1.x.
>
> * For previous version see the [v0.9.0](https://github.com/imgproxy/imgproxy-helm/tree/0.9.0) tag
>

## Introduction

imgproxy can be used to provide a fast and secure way to replace all the image resizing code of your web application (like calling ImageMagick or GraphicsMagick, or using libraries), while also being able to resize everything on the fly, fast and easy. imgproxy is also indispensable when handling lots of image resizing, especially when images come from a remote source.

imgproxy does one thing — resizing remote images — and does it well. It works great when you need to resize multiple images on the fly to make them match your application design without preparing a ton of cached resized images or re-doing it every time the design changes.

imgproxy is a Go application, ready to be installed and used in any Unix environment — also ready to be containerized using Docker.

See this article for a good intro and all the juicy details! [imgproxy: Resize your images instantly and securely](https://evilmartians.com/chronicles/introducing-imgproxy)

See [official README](https://github.com/imgproxy/imgproxy#imgproxy) for more.

## Prerequisites

* Kubernetes 1.4+ with Beta APIs enabled

## Installing chart

```shell
helm repo add imgproxy https://helm.imgproxy.net/

helm upgrade -i imgproxy imgproxy/imgproxy
```

The command deploys imgproxy on the Kubernetes cluster in the default configuration. The [configuration section](#configuration) lists various ways to override default configuration during deployment.

> **Tip:** To list all releases use `helm list`

## Uninstalling the Chart

```shell
helm delete imgproxy
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

Specify each parameter using the `--set key=value[,key=value]` argument to helm install or provide your own file via `-f values.yaml`. For example,

```shell
helm upgrade -i imgproxy \
  --namespace imgproxy \
  --set image.tag=v3.28.0 \
  imgproxy/imgproxy
```

The above command installs a specified version of imgproxy.

## Supported Chart values

### Environment Variables

Use the `env` part of the values to configuse imgproxy server itself.
Check the [documentation](https://docs.imgproxy.net/configuration) for the list of supported variables.

```yaml
# values.yml
---
# ...
env:
  FOO: bar
```

### Additional secrets

If you want to manage your keys in a more secure manner prepare Secrets (via External Secrets Operator, Sealed Secrets, etc)

```yaml
# values.yaml
resources:
  addSecrets:
    - improxy-external-secrets
```


### Image

Options for downloading the imgproxy image

|Value|Description|Default|
|-----|-----------|-------|
|**image.pullSecrets.password**|Password to your private registry|``|
|**image.pullSecrets.registry**|URL of a private registry you want to authorize to|``|
|**image.pullSecrets.username**|Login to your private registry|``|
|**image.addPullSecrets**|List of existing image pull secrets|`[]`|

### Resources

|Value|Description|Default|
|-----|-----------|-------|
|**resources.deployment.affinity**|Node and inter-pod affinity configuration||
|**resources.deployment.annotations**|Custom annotations for imgproxy deployment|`{}`|

|Value|Description|Default|
|-----|-----------|-------|
|**resources.pod.annotations**|Custom annotations for imgproxy pod|`{}`|
|**resources.pod.labels**|Custom labels for imgproxy pods|`{}`|

|Value|Description|Default|
|-----|-----------|-------|
|**resources.deployment.lifecylcle**|Lifecycle hook for the preStart or PreStop commands||
|**resources.deployment.livenessProbe**|Timeouts and counters for the liveness probe||
|**resources.deployment.minReadySeconds**|Minimum ready seconds for the statement set||
|**resources.deployment.nodeSelector**|A node selector labels||
|**resources.deployment.priority.level**|The level of the pod priority|`0`|
|**resources.deployment.priority.name**|The name of the priority class||
|**resources.deployment.priority.preempting**|If the pod should be preempting (k8s v1.19+)|`true`|
|**resources.deployment.readinessProbe**|Timeouts and counters for the readiness probe||
|**resources.deployment.replicaCount**|How many pods with imgproxy should be running simultaneously (DEPRECATED, use replicas.default instead!)|`1`|
|**resources.deployment.replicas.cpuUtilization**|The target percentage for the average CPU utilization by pods after which they should be scaled.|`80`|
|**resources.deployment.replicas.default**|How many pods with imgproxy should be running after deployment|`1`|
|**resources.deployment.replicas.maxCount**|The maximum number of pods the imgproxy can be scaled to.|`1`|
|**resources.deployment.replicas.minCount**|The minimal number of pods the imgproxy can be scaled to.|`1`|
|**resources.deployment.replicas.stabilizationInterval**|The number of seconds for which past recommendations should be considered while scaling up or scaling down (0 - 3600) to prevent flapping.|`300`|
|**resources.deployment.replicas.stepCount**|The max number of pods to be added/dropped during autoscaling step.|`1`|
|**resources.deployment.replicas.stepSeconds**|The period in seconds (1-1800) during which up to `stepCount` pods can be added or dropped by autoscaler.|`60`|
|**resources.deployment.resources**|Hash of resource limits for your pods|`{}`|
|**resources.deployment.securityContext**|Hash of security context settings for your pods|`{}`|
|**resources.deployment.containerSecurityContext**|Security context setting for containers, see [the docs](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container)|`{}`|
|**resources.deployment.terminationGracePeriodSeconds**|A custom amount of time to terminate the app|`30`|
|**resources.deployment.tolerations**|Tolerations for Kubernetes taints||
|**resources.deployment.topologySpreadConstraints**|topologySpreadConstraints for distributing pods across zones|`[]`|

|Value|Description|Default|
|-----|-----------|-------|
|**resources.podDisruptionBudget.enabled**|Enable or disable a disruption budget policy|`false`|
|**resources.podDisruptionBudget.maxUnavailable**|maxUnavailable option for the PodDisruptionBudget|`0`|
|**resources.podDisruptionBudget.minAvailable**|minAvailable option for the PodDisruptionBudget|`0`|

|Value|Description|Default|
|-----|-----------|-------|
|**resources.serviceAccount.existingName**|The name of an existing service account to be used by deployments|``|
|**resources.serviceAccount.annotations**|Annotations for the Kubernetes service account for imgproxy|``|
|**resources.serviceAccount.aws.accountId**|The AWS Account ID to authenticate via IAM|``|
|**resources.serviceAccount.aws.iamRoleName**|The name of the AWS IAM Role to authenticate via IAM|``|

|Value|Description|Default|
|-----|-----------|-------|
|**resources.service.type**|Kubernetes service type for imgproxy|`ClusterIP`|
|**resources.service.loadBalancerIP**|Load balancer ip for service type "LoadBalancer"|''|
|**resources.service.loadBalancerSourceRanges**| Load balancer source ranges for service type "LoadBalancer"|`[]|
|**resources.service.externalTrafficPolicy**| Enable client source IP preservation |`Cluster`|
|**resources.service.nodePort**|Set the initial value when Kubernetes type is NodePort|``|

### Ingress configuration

|Value|Description|Default|
|-----|-----------|-------|
|**resources.ingress.acme**|Enables the ingress resource annotation which tells cert-manager to issue a Let's Encrypt certificate|`false`|
|**resources.ingress.annotations**|Additional annotations for the ingress resource||
|**resources.ingress.enabled**|When true, enables ingress resource for imgproxy|`false`|
|**resources.ingress.health.whitelist**|Comma separated string of CIDR addresses that are allowed to access `/health` url of imgproxy||
|**resources.ingress.hosts**|Hostnames for the ingress resource to use|`["example.com"]`|
|**resources.ingress.pathSuffix**|Suffix to be added to path prefix, for example wildcard '*' for AWS balancer||
|**resources.ingress.tls**|TLS config array||
|**resources.ingress.tls[].hosts**|Hostnames this tls secret is used for|`["example.com"]`|
|**resources.ingress.tls[].secretName**|Name of the k8s Secret resource which stores crt & key for the ingress resource||

See `values.yaml` for some more Kubernetes-specific configuration options.

### Persistence

Options to mount a persistent volume.

|Value|Description|Default|
|-----|-----------|-------|
|**persistence.enabled**|Enable persistence for deployment.|`false`|
|**persistence.name**|Set name for persistent volume claim.|`imgproxy-data`|
|**persistence.existingClaim**|Reference an existing PVC instead of creating a new one.|`""`|
|**persistence.mountPath**|Mount path for PVC in the imgproxy pod.|`/images`|
|**persistence.subPath**|Mount sub path of the persistent volume.|`""`|
|**persistence.accessModes**|Access modes for the persistent volume.|`- ReadWriteOnce`|
|**persistence.size**|Storage size of the PV.|`10Gi`|
|**persistence.storageClass**|Set the storageClass for the persistent volume claim.|`""`|
|**persistence.dataSource**|Create a PV from a data source (e.g. snapshot).|`""`|
