# otel_azure_monitor

Dartastic OpenTelemetry bridge for Azure Monitor (logs + metrics + alerts).

Wraps each call in a CLIENT-kind span with vendor-specific attributes following OpenTelemetry semantic conventions where applicable.

```dart
import 'package:otel_azure_monitor/otel_azure_monitor.dart';

await tracedAzureMonitor<void>(
  operation: 'someOp',
  invoke: () async {
    final r = await client.someOp();
    return AzureMonitorCallResult(value: r, result: AzureMonitorResult(statusCode: 200));
  },
);
```

Suppress instrumentation within a block:

```dart
await runWithoutAzureMonitorInstrumentationAsync(() async {
  await client.someInternalSync();
});
```
