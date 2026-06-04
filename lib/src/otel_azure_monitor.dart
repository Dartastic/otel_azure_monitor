// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';

import 'otel_azure_monitor_suppression.dart';

class AzureMonitorResult {
  const AzureMonitorResult({
    this.subscriptionId,
    this.resourceGroup,
    this.workspace,
    this.queryText,
    this.alertName,
    this.alertSeverity,
    this.metricName,
    this.region,
    this.statusCode,
    this.errorCode,
    this.errorMessage,
  });

  final String? subscriptionId;
  final String? resourceGroup;
  final String? workspace;
  final String? queryText;
  final String? alertName;
  final String? alertSeverity;
  final String? metricName;
  final String? region;
  final int? statusCode;
  final String? errorCode;
  final String? errorMessage;
}

class AzureMonitorCallResult<T> {
  const AzureMonitorCallResult({required this.value, this.result});
  final T value;
  final AzureMonitorResult? result;
}

Future<T> tracedAzureMonitor<T>({
  required String operation,
  required Future<AzureMonitorCallResult<T>> Function() invoke,
  Tracer? tracer,
}) async {
  if (azureMonitorInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTel.tracerProvider().getTracer('otel_azure_monitor');
  final span = t.startSpan('azuremonitor $operation', kind: SpanKind.client);
  try {
    span.addAttributes(
        OTel.attributes([OTel.attributeString('azure.service', 'monitor')]));
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.subscriptionId != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('azure.subscription.id', res.subscriptionId!)
        ]));
      }
      if (res.resourceGroup != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('azure.resource_group', res.resourceGroup!)
        ]));
      }
      if (res.workspace != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('azure.monitor.workspace', res.workspace!)]));
      }
      if (res.queryText != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('azure.monitor.query', res.queryText!)]));
      }
      if (res.alertName != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('azure.monitor.alert.name', res.alertName!)
        ]));
      }
      if (res.alertSeverity != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString(
            'azure.monitor.alert.severity',
            res.alertSeverity!,
          )
        ]));
      }
      if (res.metricName != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('metric.name', res.metricName!)]));
      }
      if (res.region != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('cloud.region', res.region!)]));
      }
      if (res.statusCode != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeInt('http.response.status_code', res.statusCode!)]));
      }
      if (res.errorCode != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('azuremonitor.error.code', res.errorCode!)]));
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400);
      if (fail) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString(
            ErrorResource.errorType.key,
            res.errorCode ?? 'monitor.error',
          )
        ]));
        span.setStatus(SpanStatusCode.Error, res.errorMessage);
      }
    }
    return r.value;
  } catch (e, st) {
    span.recordException(e, stackTrace: st);
    span.setStatus(SpanStatusCode.Error, e.toString());
    rethrow;
  } finally {
    span.end();
  }
}
