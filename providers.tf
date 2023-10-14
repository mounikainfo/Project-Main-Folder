# configure aws provider to establish a secure connection between terraform and aws
provider "aws" {
  region  = var.region
  profile = var.profile

  default_tags {
    tags = {
      "Automation"  = "terraform"
      "Project"     = var.project_name
      "Environment" = var.environment
    }
  }
}

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "~> 2.5"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "arn:aws:eks:ap-south-1:140382828045:cluster/sta_cluster"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config" 
    # cluster_ca_certificate = "base64decode(arn:aws:iam::140382828045:oidc-provider/oidc.eks.ap-south-1.amazonaws.com/id/B725096B926A9B918A603F2C95B8EC60)"
  }
}




