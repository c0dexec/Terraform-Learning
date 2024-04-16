terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "5.42.0"
    }
  }
}

provider "github" {
  token = var.github_token
}

resource "github_repository" "repo" {
  name       = "groovy-test"
  visibility = "private"
}
