import repro_project_dsl

## Scoop realizations for package interfaces owned elsewhere.
##
## Every contribution pins the fingerprint of the interface it realizes, so
## a change to that interface fails here rather than silently provisioning
## against a shape that moved. The fingerprints below were recomputed
## against the current interfaces; the previous four had gone stale when the
## interface artifact envelope grew `executableAlias` and `prunePaths`.
##
## ## What `preferredVersion` means here, and why it is a floor
##
## Scoop buckets carry one version — whatever the bucket's maintainers last
## merged — and it moves. A contribution that pinned an exact version would
## break on the next bucket update, so these declare the floor the package
## interface needs and let the bucket supply whatever is at or above it.
## That is the trade this realization exists to offer: it is the fast path,
## not the reproducible one. The from-source realizations in
## `reprobuild-packages/packages/source/` are the reproducible ones, and
## they pin exact versions and digests.

provisioningFor "bash":
  interfaceFingerprint "8ee476ea70e3fe6e6ff11cf09fbd7ab9d16290a0c69b74b80620ce952634dc99"
  contributor "github:metacraft-labs/reprobuild-scoop-packages"
  scoopApp bucket = "main", app = "git", preferredVersion = ">=2",
    executablePath = "bin/bash.exe",
    requiresExecutionProfileChecksum = false

provisioningFor "busybox":
  interfaceFingerprint "5c65917bef060839c80d8e276c91287ea64721741eb329b0eae225d30b71a57a"
  contributor "github:metacraft-labs/reprobuild-scoop-packages"
  scoopApp bucket = "main", app = "busybox", preferredVersion = ">=5300",
    executablePath = "busybox.exe",
    requiresExecutionProfileChecksum = false

provisioningFor "cmake":
  interfaceFingerprint "60173785f5b07d1afe3e590f16eb227c8dd3f2c17cea0b5c8ddd71866ca86265"
  contributor "github:metacraft-labs/reprobuild-scoop-packages"
  scoopApp bucket = "main", app = "cmake", preferredVersion = ">=3.20",
    executablePath = "bin/cmake.exe",
    requiresExecutionProfileChecksum = false

provisioningFor "llvm":
  interfaceFingerprint "a2bff9c457ff603d27320da38a1333de0780dda98aa8eafb4c7f6d759076ba2c"
  contributor "github:metacraft-labs/reprobuild-scoop-packages"
  scoopApp bucket = "main", app = "llvm", preferredVersion = ">=21",
    executablePath = "bin/llvm-config.exe",
    requiresExecutionProfileChecksum = false

## Agent Harbor's pinned CLI tool tier.
##
## Five of its eight entries have a `main`-bucket manifest, and all five
## install flat with the command at the app root — `just` and `taplo` and
## `prek` from a zip whose only member is the exe, `jq` and `shfmt` as a
## bare renamed download. So `executablePath` is just the file name in each
## case, with no `bin/` and no extract directory.
##
## The three without a manifest are `cargo-nextest`, `cargo-sort` and
## `addlicense`. Scoop's `main` bucket carries none of them, and the
## `extras` bucket carries none either, so there is no fast path to
## contribute: those three have the from-source realization and the
## upstream release binary, and nothing here. That is a gap in the bucket,
## not in this catalog, and adding a contribution that named a manifest
## which does not exist would turn a missing fast path into a resolution
## failure.

provisioningFor "just":
  interfaceFingerprint "a2db4cc9937ebe19bb7ded52ea01e26dbf9f3d4677438605b3fdb0e2038178b8"
  contributor "github:metacraft-labs/reprobuild-scoop-packages"
  scoopApp bucket = "main", app = "just", preferredVersion = ">=1.51",
    executablePath = "just.exe",
    requiresExecutionProfileChecksum = false

provisioningFor "jq":
  interfaceFingerprint "9abda596b47b8711c570043ac310b69b567158d0be0725671308a16ba9c5b4ff"
  contributor "github:metacraft-labs/reprobuild-scoop-packages"
  scoopApp bucket = "main", app = "jq", preferredVersion = ">=1.7",
    executablePath = "jq.exe",
    requiresExecutionProfileChecksum = false

provisioningFor "shfmt":
  interfaceFingerprint "16436e97ae5f7f56e13d048b2ba106f2fbb262116b2bb2577a690d2841fc0f89"
  contributor "github:metacraft-labs/reprobuild-scoop-packages"
  scoopApp bucket = "main", app = "shfmt", preferredVersion = ">=3.12",
    executablePath = "shfmt.exe",
    requiresExecutionProfileChecksum = false

provisioningFor "taplo":
  interfaceFingerprint "9dd55f5f077b56021f5ca8cfafba34b565334db26ff61c675a129f905af5053b"
  contributor "github:metacraft-labs/reprobuild-scoop-packages"
  scoopApp bucket = "main", app = "taplo", preferredVersion = ">=0.10",
    executablePath = "taplo.exe",
    requiresExecutionProfileChecksum = false

provisioningFor "prek":
  interfaceFingerprint "be999e9ab6c88a33744d83fa42d5caf35341be3b8ff244df4c03397ad096c0cd"
  contributor "github:metacraft-labs/reprobuild-scoop-packages"
  scoopApp bucket = "main", app = "prek", preferredVersion = ">=0.3",
    executablePath = "prek.exe",
    requiresExecutionProfileChecksum = false

package reprobuildScoopPackages:
  devEnv:
    task "test",
      command = "nim c -r --nimcache:build/nimcache-scoop-catalog tests/test_scoop_catalog.nim",
      description = "Validate the Scoop contribution catalog"
