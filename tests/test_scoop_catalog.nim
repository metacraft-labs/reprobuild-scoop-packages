import std/[os, sequtils, strutils, unittest]

import repro_interface_artifacts
import repro_project_dsl
import repro_dsl_stdlib/packages/bash as bashInterface
import repro_dsl_stdlib/packages/cmake as cmakeInterface
import repro_dsl_stdlib/packages/just as justInterface
import repro_dsl_stdlib/packages/jq as jqInterface
import repro_dsl_stdlib/packages/shfmt as shfmtInterface
import repro_dsl_stdlib/packages/taplo as taploInterface
import repro_dsl_stdlib/packages/prek as prekInterface
import packages/interfaces/busybox/repro as busyboxInterface
import packages/interfaces/llvm/repro as llvmInterface

import ../repro as catalog

const ExpectedContributions = 9

suite "Scoop provisioning contribution catalog":
  test "publishes pinned contributions without redefining packages":
    let contributions = registeredProvisioningContributions()
    check contributions.len == ExpectedContributions
    check contributions[0].targetPackage == "bash"
    check contributions[0].targetInterfaceFingerprint.len == 64
    check contributions[0].contributor ==
      "github:metacraft-labs/reprobuild-scoop-packages"
    check contributions[0].scoopProvisioning[0].app == "git"
    let packages = registeredPackages()
    # One package per contribution, plus this repo's own dev-env package.
    check packages.len == ExpectedContributions + 1
    for contribution in contributions:
      let targets = packages.filterIt(
        it.packageName == contribution.targetPackage)
      check targets.len == 1
      check canonicalPackageInterfaceFingerprint(targets[0], packages) ==
        contribution.targetInterfaceFingerprint

    let artifact = artifactFromRegisteredDsl(getCurrentDir() / "repro.nim")
    check artifact.projectInterface.provisioningContributions.len ==
      ExpectedContributions
    let roundTrip = decodeProjectInterfaceArtifact(
      encodeProjectInterfaceArtifact(artifact))
    check roundTrip.projectInterface.provisioningContributions.len ==
      ExpectedContributions

  test "covers the five tool-tier interfaces Scoop's main bucket carries":
    # The other three entries in Agent Harbor's pinned tier —
    # `cargo-nextest`, `cargo-sort` and `addlicense` — have no manifest in
    # either the `main` or the `extras` bucket, so there is no fast path to
    # contribute. A contribution naming a manifest that does not exist
    # would turn a missing fast path into a resolution failure, which is
    # why this catalog stops at five.
    let contributed = registeredProvisioningContributions()
      .mapIt(it.targetPackage)
    for present in ["just", "jq", "shfmt", "taplo", "prek"]:
      check present in contributed
    for absent in ["cargo-nextest", "cargo-sort", "addlicense"]:
      check absent notin contributed

  test "every tool-tier command sits at its app root":
    # All five install flat: `just`, `taplo` and `prek` from a zip whose
    # only member is the exe, `jq` and `shfmt` as a bare renamed download.
    # A `bin/` prefix on any of them would be a path that does not exist
    # after `scoop install`.
    for contribution in registeredProvisioningContributions():
      if contribution.targetPackage notin
          ["just", "jq", "shfmt", "taplo", "prek"]:
        continue
      check contribution.scoopProvisioning.len == 1
      let scoop = contribution.scoopProvisioning[0]
      check scoop.bucket == "main"
      check scoop.app == contribution.targetPackage
      check scoop.executablePath == contribution.targetPackage & ".exe"
      check not scoop.executablePath.contains("/")

  test "every contribution declares a version floor, never an exact pin":
    # A Scoop bucket carries one version and it moves, so an exact pin
    # breaks on the next bucket update. The floor is what this realization
    # can honestly promise; exact versions and digests live in the
    # from-source realizations.
    for contribution in registeredProvisioningContributions():
      for scoop in contribution.scoopProvisioning:
        check scoop.version.len == 0
        check scoop.preferredVersion.startsWith(">=")
