provider "null" {

}
# Retrieve the IAM policy JSON using a shell command
resource "null_resource" "json_file" {
    provisioner "local-exec" {
        command = "curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/install/iam_policy.json"
    }
}

# Parse the JSON and create the IAM policy
resource "aws_iam_policy" "lbc_iam_policy" {
    depends_on = [null_resource.json_file]
    name        = "AWSLoadBalancerControllerIAMPolicy"
    description = "AWS Load Balancer Controller IAM policy"
    policy = file("C:/Users/anves/STA-VPC-EKS-PROJECT/Project-Main-Folder/iam_policy.json")
} 

resource "aws_iam_role" "lbc_iam_role" {
  name = "AmazonEKSLoadBalancerControllerRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity",
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::231299874646:oidc-provider/oidc.eks.us-east-2.amazonaws.com/id/FBD497C3C3B543A7B1E387276C02E0AE"
        },
        Condition = {
          StringEquals = {
            "oidc.eks.us-east-2.amazonaws.com/id/FBD497C3C3B543A7B1E387276C02E0AE:aud" = "sts.amazonaws.com",
            "oidc.eks.us-east-2.amazonaws.com/id/FBD497C3C3B543A7B1E387276C02E0AE:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
          }
        }
      }
    ]
  })
  tags = {
    tag-key = "AWSLoadBalancerControllerIAMPolicy"
  }
}
resource "aws_iam_role_policy_attachment" "lbc_iam_role_policy_attach" {
  policy_arn = aws_iam_policy.lbc_iam_policy.arn
  role       = aws_iam_role.lbc_iam_role.name
}

data "aws_eks_cluster_auth" "cluster" {
  name = "arn:aws:iam::231299874646:oidc-provider/oidc.eks.us-east-2.amazonaws.com/id/FBD497C3C3B543A7B1E387276C02E0AE"
}
