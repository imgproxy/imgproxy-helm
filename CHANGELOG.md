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
