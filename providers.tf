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
    http = {
      source = "hashicorp/http"
      #version = "2.1.0"
      version = "~> 2.1"
    }
    # ingress-nginx = {
    #   source  = "ingress-nginx/ingress"
    #   version = "~> 1.2"  # Replace with the desired version
    # }
  }
}

provider "kubernetes" {
  # Configuration options
  config_path    = "~/.kube/config"
  config_context = "arn:aws:eks:ap-south-1:140382828045:cluster/sta_cluster"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config" 
    # cluster_ca_certificate = "base64decode(arn:aws:iam::301167228985:oidc-provider/oidc.eks.ap-south-1.amazonaws.com/id/04BDBBF84E9028F8613F98CEF91B89CC)"
  }
}

# provider "ingress" {
#   kubernetes {
#     config_path = "~/.kube/config"  # Path to your Kubernetes config file
#   }
# }
