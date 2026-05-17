# Changelog

## [0.1.0-beta.1-wip]

### Added

- Initial release.
- `tracedAzureMonitor<T>(...)` — wraps a otel_azure_monitor call in a CLIENT-kind span
  with vendor-specific attributes.
- Zone-scoped suppression via `runWithoutAzureMonitorInstrumentation()` / `Async()`.
