/* provider "null" {

}
# Retrieve the IAM policy JSON using a shell command
resource "null_resource" "json_file" {
  provisioner "local-exec" {
    # command = "curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/install/iam_policy.json"
    command = "curl -o iam_policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/install/iam_policy.json"  
  }
}
 */
# Parse the JSON and create the IAM policy
resource "aws_iam_policy" "lbc_iam_policy" {
  # depends_on = [null_resource.json_file]
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
          Federated = "arn:aws:iam::140382828045:oidc-provider/oidc.eks.ap-south-1.amazonaws.com/id/B725096B926A9B918A603F2C95B8EC60"
        },
        Condition = {
          StringEquals = {
            "oidc.eks.ap-south-1.amazonaws.com/id/B725096B926A9B918A603F2C95B8EC60:aud" = "sts.amazonaws.com",
            "oidc.eks.ap-south-1.amazonaws.com/id/B725096B926A9B918A603F2C95B8EC60:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
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
  name = "arn:aws:iam::140382828045:oidc-provider/oidc.eks.ap-south-1.amazonaws.com/id/B725096B926A9B918A603F2C95B8EC60"
}

# Install AWS Load Balancer Controller using HELM

# Resource: Helm Release 
resource "helm_release" "loadbalancer_controller" {
  depends_on = [aws_iam_role.lbc_iam_role]
  # name       = "aws-load-balancer-controller"
  name = var.lb_name

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  # namespace = "kube-system"
  namespace = var.namespace
  set {
    name  = "image.repository"
    value = "602401143452.dkr.ecr.ap-south-1.amazonaws.com/amazon/aws-load-balancer-controller" # Changes based on Region - This is for us-east-1 Additional Reference: https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html
  }
   set {
    name  = "serviceAccount.create"
    value = "true"
  }
  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }
   set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.lbc_iam_role.arn
  }
  set {
    name  = "vpcId"
    value = var.vpc_cidr
  }

  set {
    name  = "region"
    value = var.region

  }
  set {
    name  = "clusterName"
    value = var.cluster_name
  }  
  set {
    name = "tggroup"
    value = "lbc-target-group"
  }
  # set {
  #   name = "type"
  #   value = "application"
  # }
    set {
    name  = "controller.service.annotations.service.beta.kubernetes.io/aws-load-balancer-type"
    value = "application"
  }
}


/* 
# create target group
resource "aws_lb_target_group" "alb_target_group" {
  name        = "lbc-target-group"
  target_type = var.target_type
  port        = 80
  protocol    = "HTTP"
  # vpc_id      = var.vpc_id
  vpc_id = "vpc-0e126f5086cbb4f90"
  

  

  health_check {
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200,301,302"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
}
 */
# # create a listener on port 80 with redirect action
# resource "aws_lb_listener" "alb_http_listener" {
#   # load_balancer_arn = helm_release.loadbalancer_controller.name
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type = "redirect"

#     redirect {
#       port        = 443
#       protocol    = "HTTPS"
#       status_code = "HTTP_301"
#     }
#   }
# }

# # create a listener on port 443 with forward action
# resource "aws_lb_listener" "alb_https_listener" {
#   load_balancer_arn = helm_release.loadbalancer_controller.name
#   port              = 443
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = var.certificate_arn

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.alb_target_group.arn
#   }
# }
