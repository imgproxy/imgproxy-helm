# Helm chart for imgproxy

This repo contains a [Helm chart](https://github.com/imgproxy/imgproxy-helm/tree/master/imgproxy) to deploy imgproxy.

[imgproxy](https://github.com/imgproxy/imgproxy#imgproxy) is a fast and secure standalone server for resizing and converting remote images. The main principles of imgproxy are simplicity, speed, and security.

## TL;DR

To install imgproxy to your kubernetes cluster simply run:

```shell
helm repo add imgproxy https://helm.imgproxy.net/

# With Helm 3
helm upgrade -i imgproxy imgproxy/imgproxy

# With Helm 2
helm upgrade -i --name imgproxy imgproxy/imgproxy
```

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

# With Helm 3
helm upgrade -i imgproxy imgproxy/imgproxy

# With Helm 2
helm upgrade -i --name imgproxy imgproxy/imgproxy
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
  --set image.tag=v2.10.0 \
  imgproxy/imgproxy
```

The above command installs a specified version of imgproxy.

## Supported Chart values

### URL Signature Settings

|Value|Description|Default|
|-----|-----------|-------|
|**features.urlSignature.enabled**|enable URL encoding|`true`|
|**features.urlSignature.key**|hex-encoded key for URL encoding|**CHANGE IT!!!**|
|**features.urlSignature.salt**|hex-encoded salt for URL encoding|**CHANGE IT!!!**|
|**features.urlSignature.signatureSize**|number of bytes to use for signature before encoding to Base64|`32`|

### Imgproxy Server Settings

|Value|Description|Default|
|-----|-----------|-------|
|**features.server.readTimeout**|the maximum duration (in seconds) for reading the entire image request, including the body|`10`|
|**features.server.writeTimeout**|the maximum duration (in seconds) for writing the response|`10`|
|**features.server.keepAliveTimeout**|the maximum duration (in seconds) to wait for the next request before closing the connection. When set to 0, keep-alive is disabled|`10`|
|**features.server.downloadTimeout**|the maximum duration (in seconds) for downloading the source image|`5`|
|**features.server.concurrency**|the maximum number of image requests to be processed simultaneously|`double number of CPU cores`|
|**features.server.maxClients**|the maximum number of simultaneous active connections|`concurrency * 10`|
|**features.server.ttl**|duration in seconds sent in Expires and Cache-Control: max-age headers|`3600`|
|**features.server.setCanonicalHeader**|when true and the source image has http or https scheme, set rel="canonical" HTTP header to the value of the source image URL.|`false`|
|**features.server.cacheControlPassthrough**|when true and source image response contains Expires or Cache-Control headers, reuse those header|`false`|
|**features.server.soReuseport**|when true, enables SO_REUSEPORT socket option (currently on linux and darwin only)|`false`|
|**features.server.pathPrefix**|URL path prefix.||
|**features.server.userAgent**|User-Agent header that will be sent with source image request|`imgproxy/%current_version`|
|**features.server.useEtag**|when true, enables using ETag header for the cache control|`false`|
|**features.server.customRequestHeaders**|`PRO:` list of custom headers that imgproxy will send while requesting the source image, divided by `\;` (can be redefined by IMGPROXY_CUSTOM_HEADERS_SEPARATOR)||
|**features.server.customResponseHeaders**|`PRO:` list of custom response headers, divided by \; (can be redefined by IMGPROXY_CUSTOM_HEADERS_SEPARATOR)||
|**features.server.customHeadersSeparator**|`PRO:` string that will be used as a custom headers separator|`\;`|
|**features.server.enableDebugHeaders**|when true, imgproxy will add X-Origin-Content-Length header with the value is size of the source image.|`false`|

### Imgproxy Security Settings

|Value|Description|Default|
|-----|-----------|-------|
|**features.security.secret**|the authorization token. If specified, request should contain the `Authorization: Bearer %secret%` header||
|**features.security.maxSrcResolution**|the maximum resolution of the source image, in megapixels.|`16.8`|
|**features.security.maxSrcFileSize**|the maximum size of the source image, in bytes.|`0` (disabled)|
|**features.security.maxAnimationFrames**|the maximum of animated image frames to being processed.|`1`|
|**features.security.maxSvgCheckBytes**|the maximum number of bytes imgproxy will read to recognize SVG.|`32KB`|
|**features.security.allowOrigin**|when set, enables CORS headers with provided origin. CORS headers are disabled by default.|`false`|
|**features.security.allowedSources**|whitelist of source image URLs prefixes divided by comma. When blank, imgproxy allows all source image URLs.||
|**features.security.ignoreSslVerification**|When true, disables SSL verification|`false`|
|**features.security.developmentErrorsMode**|when true, imgproxy will respond with detailed error messages. Not recommended for production because some errors may contain stack trace|`false`|

### Image Compression Settings

|Value|Description|Default|
|-----|-----------|-------|
|**features.compression.quality**|quality of the resulting image, percentage|`80`|
|**features.compression.formatQuality**|default quality of the resulting image per format, comma divided.||
|**features.compression.gzipCompression**|GZip compression level|`5`|
|**features.compression.jpegProgressive**|when true, enables progressive compression of JPEG|`false`|
|**features.compression.jpegNoSubsample**|`PRO:` when true, chrominance subsampling is disabled. This will improve quality at the cost of larger file size|`false`|
|**features.compression.jpegTrellisQuant**|`PRO:` when true, enables trellis quantisation for each 8x8 block. Reduces file size but increases compression time|`false`|
|**features.compression.jpegOvershootDeringing**|`PRO:` when true, enables overshooting of samples with extreme values.||
|**features.compression.jpegOptimizeScans**|`PRO:` when true, split the spectrum of DCT coefficients into separate scans. Reduces file size but increases compression time. Requires IMGPROXY_JPEG_PROGRESSIVE to be true|`false`|
|**features.compression.jpegQuantTable**|quantization table to use. Supported values are: 0-8|`0`|
|**features.compression.pngInterlaced**|when true, enables interlaced compression of PNG|`false`|
|**features.compression.pngQuantize**|when true, enables PNG quantization. libvips should be built with libimagequant support|`false`|
|**features.compression.pngQuantizationColors**|maximum number of quantization palette entries. Should be between 2 and 256|`256`|
|**features.compression.gifOptimizeFrames**|`PRO:` when true, enables GIF frames optimization; this may produce a smaller result, but may increase compression time|`false`|
|**features.compression.gifOptimizeTransparency**|`PRO:` when true, enables GIF transparency optimization; this may produce a smaller result, but may increase compression time|`false`|
|**features.compression.avifSpeed**|controls the CPU effort spent improving compression (0-8).|`5`|

### Detection of WEBP/Avif Support by Browsers

|Value|Description|Default|
|-----|-----------|-------|
|**features.formatsSupportDetection.webp.enabled**|Enables WebP support detection. When the file extension is omitted in the imgproxy URL and browser supports WebP, imgproxy will use it as the resulting format|`false`|
|**features.formatsSupportDetection.webp.enforced**|Enables WebP support detection and enforces WebP usage. If the browser supports WebP, it will be used as resulting format even if another extension is specified in the imgproxy URL|`false`|
|**features.formatsSupportDetection.avif.enabled**|Enables AVIF support detection.|`false`|
|**features.formatsSupportDetection.avif.enforced**|Enables AVIF support detection and enforces AVIF usage|`false`|

### Imgproxy Client Hints

|Value|Description|Default|
|-----|-----------|-------|
|**features.clientHintsSupport.enabled**|Enables Client Hints support when the width is ommited for automatic responsive images|`false`|

### Video Thumbnails

|Value|Description|Default|
|-----|-----------|-------|
|**features.videoThumbnails.enabled**|`PRO:` when true, enables video thumbnails generation|`false`|
|**features.videoThumbnails.probeSize**|`PRO:` the maximum amount of bytes used to determine the format. Lower values can decrease memory usage but can produce inaccurate data or even lead to errors|`5000000`|
|**features.videoThumbnails.maxAnalyzeDuration**|`PRO:` the maximum of milliseconds used to get the stream info. Low values can decrease memory usage but can produce inaccurate data or even lead to errors. When set to 0, the heuristic is used|`0`|
|**features.videoThumbnails.second**|`PRO:` the timestamp of the frame in seconds that will be used for a thumbnail|`1`|

### Watermark

|Value|Description|Default|
|-----|-----------|-------|
|**features.watermark.data**|Base64-encoded image data||
|**features.watermark.path**|Path to the locally stored image||
|**features.watermark.url**|Watermark image URL||
|**features.watermark.opacity**|Watermark base opacity||
|**features.watermark.cacheSize**|`PRO:` size of custom watermarks cache. When set to 0, watermarks cache is disabled. By default 256 watermarks are cached|`256`|

### Unsharpening

|Value|Description|Default|
|-----|-----------|-------|
|**features.unsharpening.mode**|`PRO:` controls when unsharpenning mask should be applied (`auto`, `none`, `always`).|`auto`|
|**features.unsharpening.weight**|`PRO:` a floating-point number that defines how neighbor pixels will affect the current pixel.|`1`|
|**features.unsharpening.dividor**|`PRO:` a floating-point number that defines the unsharpening strength.|`24`|

### Fallback Image

|Value|Description|Default|
|-----|-----------|-------|
|**features.fallbackImage.data**|Base64-encoded image data. You can easily calculate it with `base64 tmp/fallback.png | tr -d '\n'`||
|**features.fallbackImage.url**|fallback image URL.||

### Skip Processing by imgproxy

|Value|Description|Default|
|-----|-----------|-------|
|**features.skipProcessing.formats**|list of formats that imgproxy shouldn't process, comma-divided.||

### Presets

|Value|Description|Default|
|-----|-----------|-------|
|**features.presets.definitions**|set of preset definitions, comma-divided||
|**features.presets.onlyPresets**|disable all URL formats and enable presets-only mode|`false`|

### AWS support

|Value|Description|Default|
|-----|-----------|-------|
|**features.aws.enabled**|When true, enables image fetching from Amazon S3 buckets|`false`|
|**features.aws.accountId**|AWS account ID (for authentication via IAM Role)||
|**features.aws.iamRoleName**|the name of IAM Role used for authentication||
|**features.aws.accessKeyId**|AWS Access Key ID||
|**features.aws.secretAccessKey**|AWS Secret Access Key||
|**features.aws.s3Region**|AWS Region||
|**features.aws.s3Endpoint**|Custom S3 endpoint to being used by imgproxy||

### Google Cloud Storage support

|Value|Description|Default|
|-----|-----------|-------|
|**features.gcs.enabled**|When true, enables image fetching from Google Cloud Storage|`false`|
|**features.gcs.jsonKey**|Google Cloud JSON key. When set, enables image fetching from Google Cloud Storage buckets||

### MS Azure Blob Storate support

|Value|Description|Default|
|-----|-----------|-------|
|**features.abs.enabled**|when true, enables image fetching from Azure Blob Storage containers|`false`|
|**features.abs.accountName**|Azure storage account name||
|**features.abs.accountKey**|Azure storage account key||
|**features.abs.endpoint**|custom Azure Blob Storage endpoint to being used by imgproxy||

### Integration to the New Relic

|Value|Description|Default|
|-----|-----------|-------|
|**features.newRelic.enabled**|Enables New Relic integration|`false`|
|**features.newRelic.licenseKey**|New Relic license key||
|**features.newRelic.appName**|New Relic application name||

### Error Reporting

|Value|Description|Default|
|-----|-----------|-------|
|**features.errorReporting.bugsnag.enabled**|Enable integration with Bugsnag|`false`|
|**features.errorReporting.bugsnag.key**|Bugsnag API key. When provided, enables errors reporting to Bugsnag||
|**features.errorReporting.bugsnag.env**|Bugsnag stage to report to||
|**features.errorReporting.honeybadger.enabled**|Enable integration with Honeybadger|`false`|
|**features.errorReporting.honeybadger.key**|Honeybadger API key.||
|**features.errorReporting.honeybadger.env**|Honeybadger env to report to|`production`|
|**features.errorReporting.sentry.enabled**|Enable integration with Sentry|`false`|
|**features.errorReporting.sentry.dsn**|Sentry project DSN.||
|**features.errorReporting.sentry.env**|Sentry environment to report to|`production`|
|**features.errorReporting.sentry.release**|Sentry release to report to|`imgproxy/{imgproxy version}`|
|**features.errorReporting.reportDownloadingErrors**|when true, imgproxy will report downloading errors|`true`|

### Logging

|Value|Description|Default|
|-----|-----------|-------|
|**features.logging.format**|the log format. The following formats are supported: ['pretty', 'structured', 'json']|`pretty`|
|**features.logging.level**|the log level. The following levels are supported error, warn, info and debug|`info`|
|**features.logging.syslog.enabled**|when true, enables sending logs to syslog|`false`|
|**features.logging.syslog.level**|maximum log level to send to syslog. Known levels are: crit, error, warning and info|`info`|
|**features.logging.syslog.network**|network that will be used to connect to syslog. When blank, the local syslog server will be used. Known networks are tcp, tcp4, tcp6, udp, udp4, udp6, ip, ip4, ip6, unix, unixgram and unixpacket||
|**features.logging.syslog.address**|address of the syslog service. Not used if IMGPROXY_SYSLOG_NETWORK is blank.||
|**features.logging.syslog.tag**|specific syslog tag|`imgproxy`|

### Memory Usage Tweaks

|Value|Description|Default|
|-----|-----------|-------|
|**features.memoryUsageTweaks.downloadBufferSize**|the initial size (in bytes) of a single download buffer. When zero, initializes empty download buffers|`0`|
|**features.memoryUsageTweaks.gzipBufferSize**|the initial size (in bytes) of a single GZip buffer. When zero, initializes empty GZip buffers. Makes sense only when GZip compression is enabled|`0`|
|**features.memoryUsageTweaks.freeMemoryInterval**|the interval (in seconds) at which unused memory will be returned to the OS.|`10`|
|**features.memoryUsageTweaks.bufferPoolCalibrationThreshold**|the number of buffers that should be returned to a pool before calibration|`1024`|

### Miscellaneous imgproxy Settings

|Value|Description|Default|
|-----|-----------|-------|
|**features.miscellaneous.baseUrl**|base URL part which will be added to every requestsd image URL.||
|**features.miscellaneous.useLinearColorspace**|when true, imgproxy will process images in linear colorspace. This will slow down processing. Note that images won’t be fully processed in linear colorspace while shrink-on-load is enabled (see below)|`false`|
|**features.miscellaneous.disableShrinkOnLoad**|when true, disables shrink-on-load for JPEG and WebP. Allows to process the whole image in linear colorspace but dramatically slows down resizing and increases memory usage when working with large images|`false`|
|**features.miscellaneous.stripColorProfile**|when `true`, imgproxy will transform the embedded color profile (ICC) to sRGB and remove it from the image.|`true`|
|**features.miscellaneous.autoRotate**|when `true`, imgproxy will auto rotate images based on the EXIF Orientation parameter (if available in the image meta data).|`true`|
|**features.miscellaneous.stripMetadata**|whether to strip all metadata (EXIF, IPTC, etc.) from JPEG and WebP output images|`true`|

### k8s deployment

Deployment specific options.

|Value|Description|Default|
|-----|-----------|-------|
|**image.pullSecrets.password**|Password to your private registry|``|
|**image.pullSecrets.registry**|URL of a private registry you want to authorize to|``|
|**image.pullSecrets.username**|Login to your private registry|``|
|**resources.deployment.affinity**|Node and inter-pod affinity configuration||
|**resources.deployment.annotations**|Custom annotations for imgproxy deployment|`{}`|
|**resources.pod.annotations**|Custom annotations for imgproxy pod|`{}`|
|**resources.pod.labels**|Custom labels for imgproxy pods|`{}`|
|**resources.deployment.readinessProbe**|Timeouts and counters for the readiness probe||
|**resources.deployment.livenessProbe**|Timeouts and counters for the liveness probe||
|**resources.deployment.nodeSelector**|A node selector labels||
|**resources.deployment.priority.name**|The name of the priority class||
|**resources.deployment.priority.level**|The level of the pod priority|`0`|
|**resources.deployment.priority.preempting**|If the pod should be preempting (k8s v1.19+)|`true`|
|**resources.podDisruptionBudget.enabled**|Enable or disable a disruption budget policy|`false`|
|**resources.podDisruptionBudget.maxUnavailable**|maxUnavailable option for the PodDisruptionBudget|`0`|
|**resources.podDisruptionBudget.minAvailable**|minAvailable option for the PodDisruptionBudget|`0`|
|**resources.deployment.replicaCount**|How many pods with imgproxy should be running simultaneously|`1`|
|**resources.deployment.resources**|Hash of resource limits for your pods|`{}`|
|**resources.deployment.tolerations**|Tolerations for Kubernetes taints||
|**resources.serviceAccount.annotations**|Annotations for the Kubernetes service account for imgproxy|``|
|**resources.service.type**|Kubernetes service type for imgproxy|`ClusterIP`|
|**resources.service.loadBalancerIP**|Load balancer ip for service type "LoadBalancer"|''|
|**resources.service.loadBalancerSourceRanges**| Load balancer source ranges for service type "LoadBalancer"|`[]|
|**resources.service.externalTrafficPolicy**| Enable client source IP preservation |`Cluster`|

### Ingress configuration

|Value|Description|Default|
|-----|-----------|-------|
|**resources.ingress.acme**|Enables the ingress resource annotation which tells cert-manager to issue a Let's Encrypt certificate|`false`|
|**resources.ingress.annotations**|Additional annotations for the ingress resource||
|**resources.ingress.enabled**|When true, enables ingress resource for imgproxy|`false`|
|**resources.ingress.health.whitelist**|Comma separated string of CIDR addresses that are allowed to access `/health` url of imgproxy||
|**resources.ingress.hosts**|Hostnames for the ingress resource to use|`["example.com"]`|
|**resources.ingress.tls**|TLS config array||
|**resources.ingress.tls[].hosts**|Hostnames this tls secret is used for|`["example.com"]`|
|**resources.ingress.tls[].secretName**|Name of the k8s Secret resource which stores crt & key for the ingress resource||

### Monitoring

Options to configure ServiceMonitor for Prometheus Operator.

|Value|Description|Default|
|-----|-----------|-------|
|**features.prometheus.enabled**|Set IMGPROXY_PROMETHEUS_BIND environment variable to bind metrics to port 8081|`false`|
|**features.prometheus.namespace**|Set IMGPROXY_PROMETHEUS_NAMESPACE environment variable to prepend prefix to the names of metrics|`""`|
|**resources.serviceMonitor.honorLabels**|Chooses the metric's labels on collisions with target labels|`true`|
|**resources.serviceMonitor.interval**|Interval at which metrics should be scraped (if it differs from default one)|`0`|
|**resources.serviceMonitor.namespace**|Namespace with PrometheusOperator|`monitoring`|
|**resources.serviceMonitor.selector**|Selector to select Pods|`release: prometheus-operator`|
|**resources.serviceMonitor.targetLabels**|Transfers mentioned labels on the Kubernetes Service onto the target|`["app","release"]`|

See `values.yaml` for some more Kubernetes-specific configuration options.

### Other

|Value|Description|Default|
|-----|-----------|-------|
|**nameOverride**|String to partially override imgproxy.fullname template with a string (will be appended to the release name)|`nil`|
|**fullnameOverride**|String to fully override imgproxy.fullname template with a string (will be used as pod name prefix instead of release name)|`nil`|

You can also add custom env variables for the latest version of imgproxy:

```yaml
# values.yml
---
# ...
features:
  # ...
  custom:
    FOO: bar
```

Notice, that all custom env variables are sent through the secret (encoded to base64 under the hood).
