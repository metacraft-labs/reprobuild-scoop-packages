test:
  nim c -r --hints:off --warnings:off --out:build/test-nimcache-locality tests/test_nimcache_is_worktree_local.nim
  nim c -r --hints:off --warnings:off --nimcache:build/nimcache-scoop-catalog --out:build/test-scoop-catalog tests/test_scoop_catalog.nim
