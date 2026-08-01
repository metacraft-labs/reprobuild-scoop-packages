# reprobuild-scoop-packages

Scoop provisioning contributions for canonical reprobuild package interfaces.

The catalog uses `provisioningFor` and pins every contribution to the public
interface fingerprint published by `reprobuild-packages`. Contributions remain
independent of import order and fail when their target interface is stale.

