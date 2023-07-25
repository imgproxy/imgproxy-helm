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

| Value                                       |Description|Default|
|---------------------------------------------|-----------|------|
| **features.server.readTimeout**             |the maximum duration (in seconds) for reading the entire image request, including the body|`10`|
| **features.server.writeTimeout**            |the maximum duration (in seconds) for writing the response|`10`|
| **features.server.keepAliveTimeout**        |the maximum duration (in seconds) to wait for the next request before closing the connection. When set to 0, keep-alive is disabled|`10`|
| **features.server.clientKeepAliveTimeout**  |the maximum duration (in seconds) to wait for the next request before closing the HTTP client connection. The HTTP client is used to download source images. When set to 0, keep-alive is disabled.|`90`|
| **features.server.downloadTimeout**         |the maximum duration (in seconds) for downloading the source image|`5`|
| **features.server.concurrency**             |the maximum number of image requests to be processed simultaneously|`double number of CPU cores`|
| **features.server.maxClients**              |the maximum number of simultaneous active connections|`concurrency * 10`|
| **features.server.ttl**                     |duration in seconds sent in Expires and Cache-Control: max-age headers|`31536000`|
| **features.server.setCanonicalHeader**      |when true and the source image has http or https scheme, set rel="canonical" HTTP header to the value of the source image URL.|`false`|
| **features.server.cacheControlPassthrough** |when true and source image response contains Expires or Cache-Control headers, reuse those header|`false`|
| **features.server.soReuseport**             |when true, enables SO_REUSEPORT socket option (currently on linux and darwin only)|`false`|
| **features.server.pathPrefix**              |URL path prefix.||
| **features.server.userAgent**               |User-Agent header that will be sent with source image request|`imgproxy/%current_version`|
| **features.server.useEtag**                 |when true, enables using ETag header for the cache control|`false`|
| **features.server.etagBuster**              |Change this to change ETags for all the images||
| **features.server.customRequestHeaders**    |`PRO:` list of custom headers that imgproxy will send while requesting the source image, divided by `\;` (can be redefined by IMGPROXY_CUSTOM_HEADERS_SEPARATOR)||
| **features.server.customResponseHeaders**   |`PRO:` list of custom response headers, divided by \; (can be redefined by IMGPROXY_CUSTOM_HEADERS_SEPARATOR)||
| **features.server.customHeadersSeparator**  |`PRO:` string that will be used as a custom headers separator|`\;`|
|**features.server.requestHeadersPassthrough**|`PRO:` A comma separated list of names of incoming request headers|``|
|**features.server.requestHeadersPassthrough**|`PRO:` A comma-separated list of names of source image response headers|``|
| **features.server.enableDebugHeaders**      |when true, imgproxy will add X-Origin-Content-Length header with the value is size of the source image.|`false`|
| **features.server.name**                    |`PRO:` The Server header value.|`imgproxy`|

### Imgproxy Security Settings

|Value|Description|Default|
|-----|-----------|-------|
|**features.security.secret**|the authorization token. If specified, request should contain the `Authorization: Bearer %secret%` header||
|**features.security.sourceUrlEncryptionKey**|hex-encoded key used for source URL encryption|``|
|**features.security.maxSrcResolution**|the maximum resolution of the source image, in megapixels.|`16.8`|
|**features.security.maxSrcFileSize**|the maximum size of the source image, in bytes.|`0` (disabled)|
|**features.security.maxAnimationFrames**|the maximum of animated image frames to being processed.|`1`|
|**features.security.maxAnimationFrameResolution**|The maximum resolution of the animated source image frame, in megapixels.|`0`|
|**features.security.maxSvgCheckBytes**|the maximum number of bytes imgproxy will read to recognize SVG.|`32KB`|
|**features.security.allowOrigin**|when set, enables CORS headers with provided origin. CORS headers are disabled by default.|`false`|
|**features.security.allowedSources**|whitelist of source image URLs prefixes divided by comma. When blank, imgproxy allows all source image URLs.||
|**features.security.allowLoopbackSourceAddresses**|when `true`, allows connecting to loopback IP addresses when requesting source images.|`false`|
|**features.security.allowLinkSourceAddresses**|when `true`, allows connecting to link-local multicast and unicast IP addresses when requesting source images.|`false`|
|**features.security.allowPrivateSourceAddresses**|when `true`, allows connecting to private IP addresses when requesting source images.|`true`|
|**features.security.ignoreSslVerification**|When true, disables SSL verification|`false`|
|**features.security.allowSecurityOptions**|when true, allows usage of security-related processing options such as `max_src_resolution`, `max_src_file_size`, `max_animation_frames`, and `max_animation_frame_resolution`|`false`|
|**features.security.developmentErrorsMode**|when true, imgproxy will respond with detailed error messages. Not recommended for production because some errors may contain stack trace|`false`|

### Image Compression Settings

|Value|Description|Default|
|-----|-----------|-------|
|**features.compression.quality**|quality of the resulting image, percentage|`80`|
|**features.compression.formatQuality**|default quality of the resulting image per format, comma divided.|`avif=65`|
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
|**features.compression.webpCompression**|`PRO:` The compression method to use. Supported values are lossy, near_lossless, and lossless|`lossy`|
|**features.compression.avifSpeed**|controls the CPU effort spent improving compression (0-8).|`9`|

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

### Smart Crop

|Value|Description|Default|
|-----|-----------|-------|
|**features.smartCrop.advanced**|`PRO:` Enables usage of the advanced smart crop method. Advanced smart crop may take more time than regular one, yet it produces better results.|`false`|
|**features.smartCrop.faceDetection**|`PRO:` Adds an additional fast face detection step to smart crop.|`false`|

### Fallback Image

|Value|Description|Default|
|-----|-----------|------|
|**features.fallbackImage.data**|Base64-encoded image data. You can easily calculate it with `base64 tmp/fallback.png | tr -d '\n'`||
|**features.fallbackImage.url**|fallback image URL.||
|**features.fallbackImage.httpCode**|HTTP code for the fallback image response.|`200`|
|**features.fallbackImage.ttl**|A duration (in seconds) sent via the Expires and Cache-Control:max-age HTTP headers when a fallback image was used.When blank or 0, the value from IMGPROXY_TTL is used.||

### Formats

|Value| Description|Default|
|-----|-----------|------|
|**features.formats.preferred**| list of preferred formats, comma divided.|jpeg,png,gif|
|**features.formats.skipProcessing**|list of formats that imgproxy shouldn't process, comma-divided.||
|`DEPRECATED:`**features.skipProcessing.formats**|list of formats that imgproxy shouldn't process, comma-divided. ||

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

| Value                     |Description|Default|
|---------------------------|-----------|-------|
| **features.gcs.enabled**  |When true, enables image fetching from Google Cloud Storage|`false`|
| **features.gcs.jsonKey**  |Google Cloud JSON key. When set, enables image fetching from Google Cloud Storage buckets||
| **features.gcs.endpoint** |A custom Google Cloud Storage endpoint to being used by imgproxy.||

### MS Azure Blob Storage support

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
|**features.newRelic.labels**|The list of New Relic labels, semicolon divided.||

### Integration to Open Telemetry

|Value|Description|Default|
|-----|-----------|-------|
|**features.openTelemetry.enabled**|when `true`, imgproxy will send metrics over OpenTelemetry Metrics API|`false`|
|**features.openTelemetry.collectorEndpoint**|OpenTelemetry collector endpoint (`host:port`)|``|
|**features.openTelemetry.protocop**|OpenTelemetry collector protocol. Supported protocols are `grpc`, `https`, and `http`|`grpc`|
|**features.openTelemetry.serviceName**|OpenTelemetry service name|`imgproxy`|
|**features.openTelemetry.serverCert**|OpenTelemetry collector TLS certificate, PEM-encoded|``|
|**features.openTelemetry.clientCert**|OpenTelemetry client TLS certificate, PEM-encoded|``|
|**features.openTelemetry.clientKey**|OpenTelemetry client TLS key, PEM-encoded|``|
|**features.openTelemetry.grpcInsecure**|When true, imgproxy will use an insecure GRPC connection unless the collector TLS certificate is not provided.|`true`|
|**features.openTelemetry.propagators**|a list of OpenTelemetry text map propagators, comma divided. Supported propagators are `tracecontext`, `baggage`, `b3`, `b3multi`, `jaeger`, `xray`, and `ottrace`|``|
|**features.openTelemetry.traceIdGenerator**|OpenTelemetry trace ID generator. Supported generators are `xray` and `random`|`xray`|
|**features.openTelemetry.connectionTimeout**|the maximum duration (in seconds) for establishing a connection to the OpenTelemetry collector|`5`|

### Integration to Amazon CloudWatch (v3.12+)

|Value|Description|Default|
|-----|-----------|------|
|**features.amazonCloudWatch.serviceName**|The value of the ServiceName dimension which will be used in the metrics|``|
|**features.amazonCloudWatch.namespace**|The CloudWatch namespace for the metrics|``|
|**features.amazonCloudWatch.region**|The code of the AWS region to which the metrics should be sent|``|

### Integration to Datadog (v3+)

|Value|Description|Default|
|-----|-----------|-------|
|**features.datadog.enabled**|Enables error reporting to Datadog|`false`|
|**features.datadog.agentHost**|Set the address to connect to for sending metrics to the Datadog Agent.|`localhost`|
|**features.datadog.agentHost**|Set the Datadog Agent Trace port.|`8126`|
|**features.datadog.dogStatsdPort**|Set the DogStatsD port.|`8125`|
|**features.datadog.service**|Set desired application name.|`imgproxy`|
|**features.datadog.env**|Set the environment to which all traces will be submitted.||
|**features.datadog.reportHostname**|When true, sets hostname with which to mark outgoing traces.|`false`|
|**features.datadog.sourceHostname**|Allows specifying the hostname with which to mark outgoing traces.||
|**features.datadog.tags**|Set a key/value pair which will be set as a tag on all traces.||
|**features.datadog.analyticsEnabled**|Allows specifying whether Trace Search & Analytics should be enabled for integrations.|`false`|
|**features.datadog.metricsEnabled**|Enables automatic collection of runtime metrics every 10 seconds.|`false`|
|**features.datadog.traceStartupLogs**|Causes various startup info to be written when the tracer starts.|`true`|
|**features.datadog.traceDebug**|Enables detailed logs.|`false`|
|**features.datadog.enableAdditionalMetrics**|Enables additional metrhics. Warning: Since the additional metrics are treated by Datadog as custom, Datadog can additionally bill you for their usage.|`false`|

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
|**features.logging.format**|the log format. The following formats are supported: ['pretty', 'structured', 'json', 'gcp']|`pretty`|
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
|**features.miscellaneous.urlReplacements**|A list of pattern=replacement pairs, semicolon (;) divided.||
|**features.miscellaneous.useLinearColorspace**|when true, imgproxy will process images in linear colorspace. This will slow down processing. Note that images won’t be fully processed in linear colorspace while shrink-on-load is enabled (see below)|`false`|
|**features.miscellaneous.disableShrinkOnLoad**|when true, disables shrink-on-load for JPEG and WebP. Allows to process the whole image in linear colorspace but dramatically slows down resizing and increases memory usage when working with large images|`false`|
|**features.miscellaneous.stripMetadata**|when true, imgproxy will strip all metadata (EXIF, IPTC, etc.) from JPEG and WebP output images.|`true`|
|**features.miscellaneous.stripColorProfile**|when `true`, imgproxy will transform the embedded color profile (ICC) to sRGB and remove it from the image.|`true`|
|**features.miscellaneous.keepCopyright**|when true, imgproxy will not remove copyright info while stripping metadata.|`true`|
|**features.miscellaneous.stripMetadataDPI**|The DPI metadata value that should be set for the image when its metadata is stripped.|`72.0`|
|**features.miscellaneous.autoRotate**|when `true`, imgproxy will auto rotate images based on the EXIF Orientation parameter (if available in the image meta data).|`true`|
|**features.miscellaneous.enforceThumbnail**|When `true` and the source image has an embedded thumbnail, imgproxy will always use the embedded thumbnail instead of the main image.|`false`|
|**features.miscellaneous.returnAttachment**|when true, response header Content-Disposition will include attachment.|`false`|
|**features.miscellaneous.svgFixUnsupported**|when `true`, imgproxy will try to replace SVG features unsupported by librsvg to minimize SVG rendering error. This config only takes effect on SVG rasterization.|`false`|
|**features.miscellaneous.stripMetadata**|whether to strip all metadata (EXIF, IPTC, etc.) from JPEG and WebP output images|`true`|

### k8s deployment

Deployment specific options.

|Value|Description|Default|
|-----|-----------|-------|
|**image.pullSecrets.password**|Password to your private registry|``|
|**image.pullSecrets.registry**|URL of a private registry you want to authorize to|``|
|**image.pullSecrets.username**|Login to your private registry|``|
|**image.addPullSecrets**|List of existing image pull secrets|`[]`|
|**resources.deployment.affinity**|Node and inter-pod affinity configuration||
|**resources.deployment.annotations**|Custom annotations for imgproxy deployment|`{}`|
|**resources.pod.annotations**|Custom annotations for imgproxy pod|`{}`|
|**resources.pod.labels**|Custom labels for imgproxy pods|`{}`|
|**resources.deployment.readinessProbe**|Timeouts and counters for the readiness probe||
|**resources.deployment.livenessProbe**|Timeouts and counters for the liveness probe||
|**resources.deployment.minReadySeconds**|Minimum ready seconds for the statement set||
|**resources.deployment.nodeSelector**|A node selector labels||
|**resources.deployment.priority.name**|The name of the priority class||
|**resources.deployment.priority.level**|The level of the pod priority|`0`|
|**resources.deployment.priority.preempting**|If the pod should be preempting (k8s v1.19+)|`true`|
|**resources.podDisruptionBudget.enabled**|Enable or disable a disruption budget policy|`false`|
|**resources.podDisruptionBudget.maxUnavailable**|maxUnavailable option for the PodDisruptionBudget|`0`|
|**resources.podDisruptionBudget.minAvailable**|minAvailable option for the PodDisruptionBudget|`0`|
|**resources.deployment.replicaCount**|How many pods with imgproxy should be running simultaneously (DEPRECATED, use replicas.default instead!)|`1`|
|**resources.deployment.replicas.default**|How many pods with imgproxy should be running after deployment|`1`|
|**resources.deployment.replicas.minCount**|The minimal number of pods the imgproxy can be scaled to.|`1`|
|**resources.deployment.replicas.maxCount**|The maximum number of pods the imgproxy can be scaled to.|`1`|
|**resources.deployment.replicas.stepCount**|The max number of pods to be added/dropped during autoscaling step.|`1`|
|**resources.deployment.replicas.stepSeconds**|The period in seconds (1-1800) during which up to `stepCount` pods can be added or dropped by autoscaler.|`60`|
|**resources.deployment.replicas.stabilizationInterval**|The number of seconds for which past recommendations should be considered while scaling up or scaling down (0 - 3600) to prevent flapping.|`300`|
|**resources.deployment.replicas.cpuUtilization**|The target percentage for the average CPU utilization by pods after which they should be scaled.|`80`|
|**resources.deployment.resources**|Hash of resource limits for your pods|`{}`|
|**resources.deployment.securityContext**|Hash of security context settings for your pods|`{}`|
|**resources.deployment.terminationGracePeriodSeconds**|A custom amount of time to terminate the app|`30`|
|**resources.deployment.tolerations**|Tolerations for Kubernetes taints||
|**resources.deployment.topologySpreadConstraints**|topologySpreadConstraints for distributing pods across zones|`[]`|
|**resources.serviceAccount.existingName**|The name of an existing service account to be used by deployments|``|
|**resources.serviceAccount.annotations**|Annotations for the Kubernetes service account for imgproxy|``|
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

### Monitoring

Options to configure ServiceMonitor for Prometheus Operator.

|Value|Description|Default|
|-----|-----------|-------|
|**features.prometheus.enabled**|Set IMGPROXY_PROMETHEUS_BIND environment variable to bind metrics to port 8081|`false`|
|**features.prometheus.namespace**|Set IMGPROXY_PROMETHEUS_NAMESPACE environment variable to prepend prefix to the names of metrics|`""`|
| **resources.serviceMonitor.enabled**|Use a ServiceMonitor to collect metrics|`true`|
|**resources.serviceMonitor.honorLabels**|Chooses the metric's labels on collisions with target labels|`true`|
|**resources.serviceMonitor.interval**|Interval at which metrics should be scraped (if it differs from default one)|`0`|
|**resources.serviceMonitor.namespace**|Namespace with PrometheusOperator|`monitoring`|
|**resources.serviceMonitor.selector**|Selector to select Pods|`release: prometheus-operator`|
|**resources.serviceMonitor.targetLabels**|Transfers mentioned labels on the Kubernetes Service onto the target|`["app","release"]`|

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
