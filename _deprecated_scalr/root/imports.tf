# Import Day 0 Scalr Infrastructure
# This module is created such that only the very first:
# - Environment
# - Workspace
# - Service account, role and policy assignment
# - Scalr provider configuration
# need to be manually created.
# Import root-level environment "scalr"
import { # "account-environment-scalr"
  to = scalr_environment.scalr
  id = "env-v0o1dsqd77umjedt0"
}


# Import scalr_root workspace into the scalr environment
import { # "scalr-workspace-root"
  to = module.scalr-workspace-root.scalr_workspace.workspace
  # The import block doesn't seem to fully support
  # for_each resources such as scalr_workspace.scalr["root"]
  id = "ws-v0o3assdm30ch2v1k"
}


# Import root-level service account, role, and access policy
import { # "account-service_account-scalr_root"
  to = module.provider-scalr_root.scalr_service_account.account-service_account-scalr_env
  id = "sa-v0o3asuc36rcda1vu"
}
import { # "account-role-root"
  to = scalr_role.root
  id = "role-v0o3at5k0qfl5op44"
}
import {
  to = module.provider-scalr_root.scalr_access_policy.roles
  id = "ap-v0o3at6f9mnfbc864"
}


# Import root-level Scalr provider
import { # "account-provider-scalr_root"
  to = module.provider-scalr_root.scalr_provider_configuration.scalr_env
  id = "pcfg-v0o2b85fk7js9v0nh"
}