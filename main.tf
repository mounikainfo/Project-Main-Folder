locals {
  region       = var.region
  project_name = var.project_name
  environment  = var.environment
}

# create vpc module
module "vpc" {
  source                       = "git@github.com:mounikainfo/Project-Module.git//vpc"
  region                       = local.region
  project_name                 = local.project_name
  environment                  = local.environment
  vpc_cidr                     = var.vpc_cidr
  public_subnet_az1_cidr       = var.public_subnet_az1_cidr
  public_subnet_az2_cidr       = var.public_subnet_az2_cidr
  private_app_subnet_az1_cidr  = var.private_app_subnet_az1_cidr
  private_app_subnet_az2_cidr  = var.private_app_subnet_az2_cidr
  private_data_subnet_az1_cidr = var.private_data_subnet_az1_cidr
  private_data_subnet_az2_cidr = var.private_data_subnet_az2_cidr
}

# create nat gateways
module "nat_gateway" {
  source                     = "git@github.com:mounikainfo/Project-Module.git//nat-gateway"
  project_name               = local.project_name
  environment                = local.environment
  public_subnet_az1_id       = module.vpc.public_subnet_az1_id
  internet_gateway           = module.vpc.internet_gateway
  public_subnet_az2_id       = module.vpc.public_subnet_az2_id
  vpc_id                     = module.vpc.vpc_id
  private_app_subnet_az1_id  = module.vpc.private_app_subnet_az1_id
  private_data_subnet_az1_id = module.vpc.private_data_subnet_az1_id
  private_app_subnet_az2_id  = module.vpc.private_app_subnet_az2_id
  private_data_subnet_az2_id = module.vpc.private_data_subnet_az2_id
}

# create security groups
module "security_group" {
  source       = "git@github.com:mounikainfo/Project-Module.git//secutity-groups"
  project_name = local.project_name
  environment  = local.environment
  vpc_id       = module.vpc.vpc_id
  ssh_ip       = var.ssh_ip
}

# create s3 bucket
module "s3_bucket" {
  source               = "git@github.com:mounikainfo/Project-Module.git//s3"
  project_name         = local.project_name
  env_file_bucket_name = var.env_file_bucket_name
  env_file_name        = var.env_file_name
}


# create eks
module "myeks" {
  source                    = "git@github.com:mounikainfo/Project-Module.git//eks"
  cluster_name = var.cluster_name
  role_arn = aws_iam_role.eks_master_role.arn
  cluster_version = var.cluster_version
  private_app_subnet_az1_id = module.vpc.private_app_subnet_az1_id
  private_app_subnet_az2_id = module.vpc.private_app_subnet_az2_id
  # sec = [module.security_group.app_server_security_group_id]
  sec = var.sec

  # oidc variables

  thumbprint_list = var.thumbprint_list

  # nodegroup variables
  node_group_name = var.node_group_name
  node_role_arn =  aws_iam_role.eks_nodegroup_role.arn
  capacity_type = var.capacity_type
  ami_type = var.ami_type
  instance_types = var.instance_types
  desired_size = var.desired_size
  max_size = var.max_size
  min_size = var.min_size
  max_unavailable = var.max_unavailable
  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
  ]
}

# request ssl certificate
module "ssl_certificate" {
  source            = "git@github.com:mounikainfo/Project-Module.git//acm"
  domain_name       = var.domain_name
  alternative_names = var.alternative_names
}

# create application load balancer
module "application_load_balancer" {
  source                = "git@github.com:mounikainfo/Project-Module.git//alb"
  project_name          = local.project_name
  environment           = local.environment
  alb_security_group_id = module.security_group.alb_security_group_id
  public_subnet_az1_id  = module.vpc.public_subnet_az1_id
  public_subnet_az2_id  = module.vpc.public_subnet_az2_id
  target_type           = var.target_type
  vpc_id                = module.vpc.vpc_id
  certificate_arn       = module.ssl_certificate.certificate_arn
}


