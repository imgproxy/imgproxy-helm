
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
