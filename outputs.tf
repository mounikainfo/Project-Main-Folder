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

output "lbc_role" {
  value = aws_iam_role.lbc_iam_role.name
}

output "lbc_role_arn" {
  value = aws_iam_role.lbc_iam_role.arn
}

output "lbc_iam_policy" {
  value = aws_iam_policy.lbc_iam_policy.arn
}

output "lbc_helm_metadata" {
  value       = helm_release.loadbalancer_controller.metadata
}

output "identity"  { 
  value = module.myeks.identity
}


