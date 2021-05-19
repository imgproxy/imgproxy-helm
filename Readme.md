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

### imgproxy

These are the values used to configure imgproxy itself:

|Value|Description|Default|
|-----|-----------|-------|
|**key**|hex-encoded key for URL encoding|**CHANGE IT!!!**|
|**salt**|hex-encoded salt for URL encoding|**CHANGE IT!!!**|
|**signatureSize**|number of bytes to use for signature before encoding to Base64|`32`|
|**readTimeout**|the maximum duration (in seconds) for reading the entire image request, including the body|`10`|
|**writeTimeout**|the maximum duration (in seconds) for writing the response|`10`|
|**keepAliveTimeout**|the maximum duration (in seconds) to wait for the next request before closing the connection. When set to 0, keep-alive is disabled|`10`|
|**downloadTimeout**|the maximum duration (in seconds) for downloading the source image|`5`|
|**concurrency**|the maximum number of image requests to be processed simultaneously|`double number of CPU cores`|
|**maxClients**|the maximum number of simultaneous active connections|`concurrency * 10`|
|**ttl**|duration in seconds sent in Expires and Cache-Control: max-age headers|`3600`|
|**cacheControlPassthrough**|when true and source image response contains Expires or Cache-Control headers, reuse those header|`false`|
|**soReuseport**|when true, enables SO_REUSEPORT socket option (currently on linux and darwin only)|`false`|
|**userAgent**|User-Agent header that will be sent with source image request|`imgproxy/%current_version`|
|**useEtag**|when true, enables using ETag header for the cache control|`false`|
|**customRequestHeaders**|`PRO:` list of custom headers that imgproxy will send while requesting the source image, divided by `\;` (can be redefined by IMGPROXY_CUSTOM_HEADERS_SEPARATOR)||
|**customResponseHeaders**|`PRO:` list of custom response headers, divided by \; (can be redefined by IMGPROXY_CUSTOM_HEADERS_SEPARATOR)||
|**customHeadersSeparator**|`PRO:` string that will be used as a custom headers separator|`\;`|
|**localFileSystemRoot**|root of the local filesystem. See [Serving local files](https://github.com/darthsim/imgproxy#serving-local-files). Keep empty to disable serving of local files.||
|**maxSrcResolution**|the maximum resolution of the source image, in megapixels. Images with larger real size will be rejected|`16.8`|
|**maxSrcFileSize**|the maximum size of the source image, in bytes. Images with larger file size will be rejected. When 0, file size check is disabled|`0`|
|**maxAnimationFrames**|the maximum of animated image frames to being processed|`1`|
|**secret**|the authorization token. If specified, request should contain the `Authorization: Bearer %secret%` header||
|**allowOrigin**|when set, enables CORS headers with provided origin. CORS headers are disabled by default.||
|**allowedSources**|whitelist of source image URLs prefixes divided by comma. When blank, imgproxy allows all source image URLs. Example: s3://,https://example.com/,local:// ||
|**ignoreSslVerification**|When true, disables SSL verification|`false`|
|**developmentErrorsMode**|when true, imgproxy will respond with detailed error messages. Not recommended for production because some errors may contain stack trace|`false`|
|**quality**|quality of the resulting image, percentage|`80`|
|**gzipCompression**|GZip compression level|`5`|
|**jpegProgressive**|when true, enables progressive compression of JPEG|`false`|
|**jpegNoSubsample**|`PRO:` when true, chrominance subsampling is disabled. This will improve quality at the cost of larger file size|`false`|
|**jpegTrellisQuant**|`PRO:` when true, enables trellis quantisation for each 8x8 block. Reduces file size but increases compression time|`false`|
|**jpegOptimizeScans**|`PRO:` when true, split the spectrum of DCT coefficients into separate scans. Reduces file size but increases compression time. Requires IMGPROXY_JPEG_PROGRESSIVE to be true|`false`|
|**jpegQuantTable**|quantization table to use. Supported values are: 0-8|`0`|
|**pngInterlaced**|when true, enables interlaced compression of PNG|`false`|
|**pngQuantize**|when true, enables PNG quantization. libvips should be built with libimagequant support|`false`|
|**pngQuantizationColors**|maximum number of quantization palette entries. Should be between 2 and 256|`256`|
|**gifOptimizeFrames**|`PRO:` when true, enables GIF frames optimization; this may produce a smaller result, but may increase compression time|`false`|
|**gifOptimizeTransparency**|`PRO:` when true, enables GIF transparency optimization; this may produce a smaller result, but may increase compression time|`false`|
|**enableWebpDetection**|Enables WebP support detection. When the file extension is omitted in the imgproxy URL and browser supports WebP, imgproxy will use it as the resulting format|`false`|
|**enforceWebp**|Enables WebP support detection and enforces WebP usage. If the browser supports WebP, it will be used as resulting format even if another extension is specified in the imgproxy URL|`false`|
|**enableClientHints**|Enables Client Hints support when the width is ommited for automatic responsive images|`false`|
|**watermarkData**|Base64-encoded image data||
|**watermarkPath**|Path to the locally stored image||
|**watermarkUrl**|Watermark image URL||
|**watermarkOpacity**|Watermark base opacity||
|**watermarkCacheSize**|`PRO:` size of custom watermarks cache. When set to 0, watermarks cache is disabled. By default 256 watermarks are cached|`256`|
|**presets**|Set of preset definitions, comma-divided||
|**onlyPresets**|disable all URL formats and enable presets-only mode|`false`|
|**useS3**|When true, enables image fetching from Amazon S3 buckets|`false`|
|**awsKey**|AWS Access Key ID||
|**awsSecret**|AWS Secret Access Key||
|**awsRegion**|AWS Region||
|**s3Endpoint**|Custom S3 endpoint to being used by imgproxy||
|**useGcs**|When true, enables image fetching from Google Cloud Storage|`false`|
|**gcsKey**|Google Cloud JSON key. When set, enables image fetching from Google Cloud Storage buckets||
|**newRelicKey**|New Relic license key||
|**newRelicAppName**|New Relic application name||
|**bugsnagKey**|Bugsnag API key. When provided, enables errors reporting to Bugsnag||
|**bugsnagStage**|Bugsnag stage to report to||
|**honeybadgerKey**|Honeybadger API key. When provided, enables errors reporting to Honeybadger||
|**honeybadgerEnv**|Honeybadger env to report to|`production`|
|**sentryDsn**|Sentry project DSN. When provided, enables error reporting to Sentry||
|**sentryEnvironment**|Sentry environment to report to|`production`|
|**sentryRelease**|Sentry release to report to|`imgproxy/{imgproxy version}`|
|**reportDownloadingErrors**|when true, imgproxy will report downloading errors|`true`|
|**logFormat**|the log format. The following formats are supported: ['pretty', 'structured', 'json']|`pretty`|
|**logLevel**|the log level. The following levels are supported error, warn, info and debug|`info`|
|**syslogEnable**|when true, enables sending logs to syslog|`false`|
|**syslogLevel**|maximum log level to send to syslog. Known levels are: crit, error, warning and info|`info`|
|**syslogNetwork**|network that will be used to connect to syslog. When blank, the local syslog server will be used. Known networks are tcp, tcp4, tcp6, udp, udp4, udp6, ip, ip4, ip6, unix, unixgram and unixpacket||
|**syslogAddress**|address of the syslog service. Not used if IMGPROXY_SYSLOG_NETWORK is blank.||
|**syslogTag**|specific syslog tag|`imgproxy`|
|**downloadBufferSize**|the initial size (in bytes) of a single download buffer. When zero, initializes empty download buffers|`0`|
|**gzipBufferSize**|the initial size (in bytes) of a single GZip buffer. When zero, initializes empty GZip buffers. Makes sense only when GZip compression is enabled|`0`|
|**freeMemoryInterval**|the interval (in seconds) at which unused memory will be returned to the OS.|`10`|
|**bufferPoolCalibrationThreshold**|the number of buffers that should be returned to a pool before calibration|`1024`|
|**baseUrl**|base URL part which will be added to every requestsd image URL. For example, if base URL is `http://example.com/images` and `/path/to/image.png` is requested, imgproxy will download the image from `http://example.com/images/path/to/image.png`||
|**useLinearColorspace**|when true, imgproxy will process images in linear colorspace. This will slow down processing. Note that images won’t be fully processed in linear colorspace while shrink-on-load is enabled (see below)|`false`|
|**disableShrinkOnLoad**|when true, disables shrink-on-load for JPEG and WebP. Allows to process the whole image in linear colorspace but dramatically slows down resizing and increases memory usage when working with large images|`false`|
|**applyUnsharpenMasking**|`PRO:` when true, imgproxy will apply unsharpen masking to the resulting image if one is smaller than the source|`true`|
|**stripMetadata**|whether to strip all metadata (EXIF, IPTC, etc.) from JPEG and WebP output images|`true`|


### k8s deployment

Deployment specific options.

|Value|Description|Default|
|-----|-----------|-------|
|**affinity**|Node and inter-pod affinity configuration||
|**annotations**|Custom annotations for imgproxy pods|`{}`|
|**image.pullSecrets.password**|Password to your private registry|``|
|**image.pullSecrets.registry**|URL of a private registry you want to authorize to|``|
|**image.pullSecrets.username**|Login to your private registry|``|
|**livenessProbe**|Timeouts and counters for the liveness probe||
|**nodeSelector**|A node selector labels||
|**podDisruptionBudget.enabled**|Enable or disable a disruprion budget policy|`false`|
|**podDisruptionBudget.maxUnavailable**|maxUnavailable option for the PodDisruptionBudget|`0`|
|**podDisruptionBudget.minAvailable**|minAvailable option for the PodDisruptionBudget|`0`|
|**readinessProbe**|Timeouts and counters for the readiness probe||
|**replicaCount**|How many pods with imgproxy should be running simultaneously|`1`|
|**resources**|Hash of resource limits for your pods|`{}`|
|**serviceType**|Kubernetes service type for imgproxy|`ClusterIP`|
|**tolerations**|Tolerations for Kubernetes taints||


### Ingress configuration

|Value|Description|Default|
|-----|-----------|-------|
|**ingress.acme**|Enables the ingress resource annotation which tells cert-manager to issue a Let's Encrypt certificate|`false`|
|**ingress.annotations**|Additional annotations for the ingress resource||
|**ingress.enabled**|When true, enables ingress resource for imgproxy|`false`|
|**ingress.health.whitelist**|Comma separated string of CIDR addresses that are allowed to access `/health` url of imgproxy||
|**ingress.host**|Hostname for the ingress resource to use|`example.com`|
|**ingress.tls.crt**|Certificate file for the ingress tls secret||
|**ingress.tls.enabled**|When true, enables tls support in the ingress resource|`false`|
|**ingress.tls.key**|Key file for the ingress tls secret||
|**ingress.tls.secretName**|Name of the k8s Secret resource which stores crt & key for the ingress resource||


### Monitoring

Options to configure ServiceMonitor for Prometheus Operator.


|Value|Description|Default|
|-----|-----------|-------|
|**enablePrometheus**|Set IMGPROXY_PROMETHEUS_BIND environment variable to bind metrics to port 8081|`false`|
|**prometheusNamespace**|Set IMGPROXY_PROMETHEUS_NAMESPACE environment variable to prepend prefix to the names of metrics|`""`|
|**serviceMonitor.enabled**|Enables ServiceMonitor manifest|`false`|
|**serviceMonitor.honorLabels**|Chooses the metric's labels on collisions with target labels|`true`|
|**serviceMonitor.interval**|Interval at which metrics should be scraped (if it differs from default one)|`0`|
|**serviceMonitor.namespace**|Namespace with PrometheusOperator|`monitoring`|
|**serviceMonitor.selector**|Selector to select Pods|`release: prometheus-operator`|
|**serviceMonitor.targetLabels**|Transfers mentioned labels on the Kubernetes Service onto the target|`["app","release"]`|

See `values.yaml` for some more Kubernetes-specific configuration options.

### Other

|Value|Description|Default|
|-----|-----------|-------|
|**nameOverride**|String to partially override imgproxy.fullname template with a string (will be appended to the release name)|`nil`|
|**fullnameOverride**|String to fully override imgproxy.fullname template with a string (will be used as pod name prefix instead of release name)|`nil`|
