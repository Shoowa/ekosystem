data "aws_eks_cluster" "workhorse" {
  name = var.cluster_name
}


data "aws_iam_role" "lb_controller" {
  name = "irsa-lb-controller"
}
