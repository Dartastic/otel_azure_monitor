// Licensed under the Apache License, Version 2.0
// Copyright 2025, Mindful Software LLC, All rights reserved.

import 'package:otel_azure_monitor/otel_azure_monitor.dart';
import 'package:test/test.dart';

void main() {
  group('otel_azure_monitor', () {
    test('suppression toggles in zone', () async {
      expect(azureMonitorInstrumentationSuppressed(), isFalse);
      await runWithoutAzureMonitorInstrumentationAsync(() async {
        expect(azureMonitorInstrumentationSuppressed(), isTrue);
      });
      expect(azureMonitorInstrumentationSuppressed(), isFalse);
    });

    test('AzureMonitorResult fields default null', () {
      const r = AzureMonitorResult();
      expect(r.statusCode, isNull);
    });
  });
}
