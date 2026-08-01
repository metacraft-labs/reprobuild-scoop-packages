import repro_project_dsl

provisioningFor "bash":
  interfaceFingerprint "7ef765a035113059ea950797122a2a7f45661047282acb03d5202c7e0a57b2d3"
  contributor "github:metacraft-labs/reprobuild-scoop-packages"
  scoopApp bucket = "main", app = "git", preferredVersion = ">=2",
    executablePath = "bin/bash.exe",
    requiresExecutionProfileChecksum = false

provisioningFor "busybox":
  interfaceFingerprint "7b568cf3df01f7342e469a3bbed3b00e814f2d066f3549a3cacc3c2502c27cf9"
  contributor "github:metacraft-labs/reprobuild-scoop-packages"
  scoopApp bucket = "main", app = "busybox", preferredVersion = ">=5300",
    executablePath = "busybox.exe",
    requiresExecutionProfileChecksum = false

provisioningFor "cmake":
  interfaceFingerprint "69d729adc652bb64b7b05da580971b9a363702629affb51548d5174c2cacd36b"
  contributor "github:metacraft-labs/reprobuild-scoop-packages"
  scoopApp bucket = "main", app = "cmake", preferredVersion = ">=3.20",
    executablePath = "bin/cmake.exe",
    requiresExecutionProfileChecksum = false

provisioningFor "llvm":
  interfaceFingerprint "dd6e7be1a7e5636cd6cba71c030bc146d0122f1b923cf5de6a07905f01600aca"
  contributor "github:metacraft-labs/reprobuild-scoop-packages"
  scoopApp bucket = "main", app = "llvm", preferredVersion = ">=21",
    executablePath = "bin/llvm-config.exe",
    requiresExecutionProfileChecksum = false

package reprobuildScoopPackages:
  devEnv:
    task "test",
      command = "nim c -r --nimcache:build/nimcache-scoop-catalog tests/test_scoop_catalog.nim",
      description = "Validate the Scoop contribution catalog"
