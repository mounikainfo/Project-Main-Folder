# environment vatiables
variable "region" {}
variable "project_name" {}
variable "environment" {}

#provider variables

variable "profile" {}
variable "config_context" {}

# vpc variables
variable "vpc_cidr" {}
variable "public_subnet_az1_cidr" {}
variable "public_subnet_az2_cidr" {}
variable "private_app_subnet_az1_cidr" {}
variable "private_app_subnet_az2_cidr" {}
variable "private_data_subnet_az1_cidr" {}
variable "private_data_subnet_az2_cidr" {}


# security groups variables
variable "ssh_ip" {}

# s3 variables
variable "env_file_bucket_name" {}
variable "env_file_name" {}


# eks variables

variable "cluster_name" {}
variable "cluster_version" {}
variable "sec" {}

# node group variables

variable "node_group_name" {}
variable "capacity_type" {}
variable "ami_type" {}
variable "instance_types" {}
variable "desired_size" {}
variable "max_size" {}
variable "min_size" {}
variable "max_unavailable" {}

# oidc variables

variable "thumbprint_list" {}

#acm variables
variable "domain_name" {}
variable "alternative_names" {
}


# alb variables
variable "target_type" {}