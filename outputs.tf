# eks iam output variables

output "cluster_iam_role_name" {
  description = "IAM role name of the EKS cluster"
  value       = aws_iam_role.eks_master_role.name
}

output "cluster_iam_role_arn" {
    value = aws_iam_role.eks_master_role.arn
}

