// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:otel_azure_monitor/otel_azure_monitor.dart';

/// Traces Azure Monitor calls with OpenTelemetry.
///
/// `otel_azure_monitor` depends on the OpenTelemetry API only, so the application
/// initializes an SDK once at startup. Wrap each Azure Monitor call in
/// [tracedAzureMonitor]; the `invoke` callback makes the real call and reports what
/// came back, which is recorded on the span.
Future<void> main() async {
  await OTel.initialize(serviceName: 'azure-monitor-example');

  // Traces a Azure Monitor call.
  final azureMonitorId = await tracedAzureMonitor<String>(
    operation: 'create',
    invoke: () async {
      // Make the Azure Monitor call here, then report what it returned.
      const id = 'azure_monitor_8f3a2c';
      return const AzureMonitorCallResult(
          value: id,
          result: AzureMonitorResult(
              subscriptionId: 'subscription_8f3a2c',
              resourceGroup: 'Order',
              workspace: 'example',
              queryText: 'example',
              alertName: 'example',
              alertSeverity: 'example',
              metricName: 'example',
              region: 'us-east-1',
              statusCode: 201,
              errorCode: 'example',
              errorMessage: 'example'));
    },
  );
  OTelLog.info('tracedAzureMonitor create returned $azureMonitorId');

  // Calls that should not be traced, such as health checks, run inside
  // runWithoutAzureMonitorInstrumentationAsync.
  await runWithoutAzureMonitorInstrumentationAsync(
    () => tracedAzureMonitor<String>(
      operation: 'create',
      invoke: () async {
        const id = 'azure_monitor_8f3a2c';
        return const AzureMonitorCallResult(
            value: id,
            result: AzureMonitorResult(
                subscriptionId: 'subscription_8f3a2c',
                resourceGroup: 'Order',
                workspace: 'example',
                queryText: 'example',
                alertName: 'example',
                alertSeverity: 'example',
                metricName: 'example',
                region: 'us-east-1',
                statusCode: 201,
                errorCode: 'example',
                errorMessage: 'example'));
      },
    ),
  );

  await OTel.shutdown();
}
