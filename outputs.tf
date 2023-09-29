# eks iam output variables

output "cluster_iam_role_name" {
  description = "IAM role name of the EKS cluster"
  value       = aws_iam_role.eks_master_role.name
}

output "cluster_iam_role_arn" {
    value = aws_iam_role.eks_master_role.arn
}

output "my-sec" {
  value = module.security_group.app_server_security_group_id
}

output "node-role" {
    value = aws_iam_role.eks_nodegroup_role.arn
}