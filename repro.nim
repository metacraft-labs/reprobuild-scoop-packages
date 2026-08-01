import repro_project_dsl

provisioningFor "bash":
  interfaceFingerprint "1e0e3300812a44a0d91e10ddd03d68f1387a5f5aefddf4422159c7ec6efb8f07"
  contributor "github:metacraft-labs/reprobuild-scoop-packages"
  scoopApp bucket = "main", app = "git", preferredVersion = ">=2",
    executablePath = "bin/bash.exe",
    requiresExecutionProfileChecksum = false

provisioningFor "busybox":
  interfaceFingerprint "ca4580bfa6935255b52c55283d9ef8969d477febf270e7e644e7d3374255c801"
  contributor "github:metacraft-labs/reprobuild-scoop-packages"
  scoopApp bucket = "main", app = "busybox", preferredVersion = ">=5300",
    executablePath = "busybox.exe",
    requiresExecutionProfileChecksum = false

provisioningFor "cmake":
  interfaceFingerprint "88c10dc3cef1e07d8b6a6e4f46f7eeaf757c2f1330c86d8c266a3cdd31c79dbf"
  contributor "github:metacraft-labs/reprobuild-scoop-packages"
  scoopApp bucket = "main", app = "cmake", preferredVersion = ">=3.20",
    executablePath = "bin/cmake.exe",
    requiresExecutionProfileChecksum = false

package reprobuildScoopPackages:
  devEnv:
    task "test",
      command = "nim c -r --nimcache:build/nimcache-scoop-catalog tests/test_scoop_catalog.nim",
      description = "Validate the Scoop contribution catalog"
