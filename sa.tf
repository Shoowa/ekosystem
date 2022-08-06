resource "kubernetes_service_account" "lb_controller" {
  metadata {
    name        = local.lb_controller
    namespace   = local.ks
    annotations = { "eks.amazonaws.com/role-arn" = data.aws_iam_role.lb_controller.arn }
    labels      = {
      "app.kubernetes.io/name"      = local.lb_controller
      "app.kubernetes.io/component" = "controller"
    }
  }

    automount_service_account_token = true
}
