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
