resource "cloudflare_pages_project" "blog_pages_project" {
  account_id        = var.cloudflare_account_id
  name              = "augie.com"
  production_branch = "main"

  source {
    type = "github"
    config {
      owner                         = "premkadile"
      repo_name                     = "cdntest"
      production_branch             = "main"
      pr_comments_enabled           = true
      deployments_enabled           = true
      production_deployment_enabled = true
      // preview_deployment_setting    = "all"
      // preview_branch_includes       = ["*"]
      // preview_branch_excludes       = ["main", "prod"]
    }
  }
}
