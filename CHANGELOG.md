## 0.8.19 (2022-07-31)

* Fix broken env variables for imgproxy formats

## 0.8.18 (2022-07-27)

* Support imgproxy v.3.7.0

## 0.8.17 (2022-07-04)

* Support imgproxy v.3.6.0

## 0.8.16 (2022-06-18)

* Fix issue #77 (make authentication key file not required)
* Fix issue #76 (add a conditional apiVersion for PodDisruptionBudget in k8s v1.21+)

## 0.8.15 (2022-05-11)

* Support imgproxy v3.5.0

## 0.8.14 (2022-05-07)

* Fix YAML syntax for common labels

## 0.8.13 (2022-04-04)

* Add common labels to be used by every resource of the chart.

## 0.8.12 (2022-02-21)

* Add `ingressClassName` field for `ingress-health.yaml`.

## 0.8.11 (2022-02-15)

* Support custom annotations to the service (`resources.service.annotations`).

## 0.8.10 (2022-01-13)

* Fix unquoted numerics in `.Values.features`

## 0.8.9 (2021-12-20)

* Fix deployment by removing `spec.replicas` in presence of HPA

## 0.8.8 (2021-11-23)

* Support imgproxy v3.0.0.beta2
* Enable customization of ingress class name (`className`) and path type (`pathType`)

## 0.8.7 (2021-11-16)

* Add ability to set IMGPROXY_USE_S3=true without AWS credentials

## 0.8.6 (2021-11-12)

* Add ability to use existing image pull secrets

## 0.8.5 (2021-10-20)

* Enforce default CPU resource settings

## 0.8.4 (2021-10-07)

* Support imgproxy v3.0.0.beta1
* Fix use of values for Azure integration
* Add commented ENV values to secret for debugging

## 0.8.3 (2021-10-03)

* Fix horizontal pod autoscaler by adding explicit policies.

## 0.8.2 (2021-09-30)

* Add Readme.

## 0.8.1 (2021-09-29)

* Add annotations for ArtifactHub.
* Fix average CPU utilization in horizontal pod autoscaler.

## 0.8.0 (2021-09-28)

* Add checksum/env annotation to deployment to enable redeploy after changing secrets.
* Support environment variables passed to the pods through custom secrets.
* Support PVC for local files usage.
* Support horizontal pod autoscaling based on average cpu utilization.
* Update app version to `2.17.0`.

### Deprecated values

* .resources.deployment.replicaCount (to be removed in v0.9.0 in favor of .replicas.deployment.replicas.default)

## 0.7.9 (2021-09-05)

* Fix README concerning the `urlSignature.enabled` default value.
* Update app version to `2.16.6`.

## 0.7.8 (2021-07-13)

* Support a whitelist of ip-addresses for a health probe.

## 0.7.7 (2021-07-08)

* Add the chart-specific opinionated label `imgproxy: true` to all resources.

## 0.7.6 (2021-07-02)

* (Fix) versioning of Ingress for k8s 1.19+
* (Fix) docs

## 0.7.5 (2021-06-22)

* (Fix) versioning of k8s resources

## 0.7.4 (2021-06-17)

* (Fix) prometheus bind port

## 0.7.3 (2021-06-10)

* (Fix) apiVersion checkup in ingress config

## 0.7.2 (2021-06-04)

* (New) add custom labels to pods
* (New) support for custom env variables
* (New) support for external load balancer
* (New) support for ingress in k8s v1.22+
* (New) add priority class and level to pods

## 0.7.1 (2021-05-28)

* (Fix) .Values.image updated in `values.yaml`

## 0.7.0 (2021-05-27)

* (Breaking) rearrange keys in `values.yaml`
* (Breaking) add opinionated service account annotiations for AWS IAM role
* (New) add support for the following env variables
  - IMGPROXY_SET_CANONICAL_HEADER
  - IMGPROXY_ENABLE_DEBUG_HEADERS
  - IMGPROXY_MAX_SVG_CHECK_BYTES
  - IMGPROXY_ALLOW_ORIGIN
  - IMGPROXY_FORMAT_QUALITY
  - IMGPROXY_AVIF_SPEED
  - IMGPROXY_ENABLE_AVIF_DETECTION
  - IMGPROXY_ENFORCE_AVIF
  - IMGPROXY_UNSHARPENING_WEIGHT
  - IMGPROXY_UNSHARPENING_DIVIDOR
  - IMGPROXY_SKIP_PROCESSING_FORMATS
  - IMGPROXY_STRIP_COLOR_PROFILE
  - IMGPROXY_AUTO_ROTATE
* (Fix) add serviceMonitor only when Prometheus is enabled
* (Fix) readme file

## 0.6.4 (2021-05-27)

* (Add) support for service accounts

## 0.6.3 (2021-05-21)

* (Fix) enable `IMGPROXY_REPORT_DOWNLOADING_ERRORS` to be set to `false` explicitly

## 0.6.2 (2021-05-20)

* (New) Azure Blob Storage options (`useAbs`, `absName`, `absKey`, `absEndpoint`)

## 0.6.1 (2020-11-28)

* (Fix) readiness probe configuration when using pathPrefix
* (Fix) readme file

## 0.6.0 (2020-11-22)

* (Fix) deployment indentations
* (New) pod annotations values were renamed

## 0.5.11 (2020-11-20)

* (New) `videoThumbnailProbeSize` & `videoThumbnailMaxAnalyzeDuration` options for `v2.15.0` configuration

## 0.5.10 (2020-11-13)

* (New) imgproxy `v2.15.0`
* (New) `prometheusNamespace` to prepend prefix to the names of metrics
* (New) add deployment annotations

## 0.5.9 (2020-06-10)

* (Fix) Add forgotten `useGcs` value.

## 0.5.8 (2020-05-11)

* (New) imgproxy `v2.13.1`
* (Fix) remove unused `httpPort` variable from `values.yaml`

## 0.5.7 (2020-04-27)

* (New) imgproxy `v2.13.0`
* (New) Fallback image options
* (Fix) `IMGPROXY_VIDEO_THUMBNAIL_SECOND` env var should be quoted (by @ziofix)
* (Fix) conditions for annotatinons in ingress manifests
* (Fix) ingress-health manifest should not be tagged by acme tag - it will use the main secret for tls

## 0.5.6 (2020-04-17)

* (New) imgproxy `v2.12.0`
* (New) `pathPrefix` value for URL path prefix
* (New) `enableVideoThumbnails` & `videoThumbnailSecond` values for video thumbnail support
## 0.5.5 (2020-04-07)

* (New) `fullnameOverride` string to override generated resource names prefix

## 0.5.4 (2020-04-05)

* (New) `enablePrometheus` Boolean to bind Prometheus `/metrics` url to imgproxy

## 0.5.3 (2020-03-03)

* (Fix) indentation typo in ingress-health.yaml

## 0.5.2 (2020-03-02)

* (New) `ingress.health.whitelist` Comma separated string of CIDR addresses that are allowed to access `/health` url of imgproxy

## 0.5.1 (2020-02-25)

* (New) imgproxy v2.10.0
* (Fix) unnecessary empty environment variables were removed
* (Fix) quoted templated strings refactoring

## 0.5.0 (2020-02-03)

- (New) imgproxy `v2.9.0`
- (New) PRO options support
- (New) full support for `v2.9.0` options`
