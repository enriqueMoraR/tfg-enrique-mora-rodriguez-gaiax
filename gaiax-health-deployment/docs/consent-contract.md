# Consent and Sovereignty Contract

## Purpose
Define the minimum consent and sovereignty fields shared across provider, trust, consumer and dashboard.

## Required Fields
### Consent context
- `datasetId`
- `consumerId`
- `consumerDid`
- `receiverDid`
- `purpose`
- `requestedScopes`
- `validFrom`
- `validTo`

### Sovereignty metadata
- `owner`
- `jurisdiction`
- `policyUri`
- `receiverDid`
- `retentionDays`
- `validFrom`
- `validTo`
- `tags`

## Validation rules
1. `validFrom` and `validTo` must be ISO-8601 instants.
2. `validTo` must be after `validFrom`.
3. The consent window must be active at decision time.
4. The `purpose` must match the declared use case.
5. The `receiverDid` must match the authorized receiver for the dataset.

## Version
- Contract version: `1.0.0`
- Change policy: semver compatible additions only unless the feature explicitly revokes a field.

