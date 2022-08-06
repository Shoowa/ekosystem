resource "helm_release" "cert_manager" {
  chart       = local.cm
  version     = "1.9.1"
  repository  = "https://charts.jetstack.io"
  namespace   = local.cm
  name        = local.cm

  set         {
    name      = "installCRDs"
    value     = "true"
  }

  timeout           = 900 # 15 minutes.
  wait              = true
  wait_for_jobs     = true
  create_namespace  = true
  recreate_pods     = true
  cleanup_on_fail   = true
}


resource "helm_release" "lb_controller" {
  chart       = local.lb_controller
  version     = "1.4.3"
  repository  = "https://aws.github.io/eks-charts"
  namespace   = local.ks
  name        = local.lb_controller

  set         {
    name      = "clusterName"
    value     = data.aws_eks_cluster.workhorse.id

  }

  set         {
    name      = "serviceAccount.create"
    value     = "false"
  }

  set         {
    name      = "serviceAccount.name"
    value     = kubernetes_service_account.lb_controller.metadata.0.name
  }

  set         {
    name      = "enableCertManager"
    value     = "true"
  }

  timeout           = 900 # 15 minutes.
  wait              = true
  wait_for_jobs     = true
  recreate_pods     = true
  cleanup_on_fail   = true

  depends_on = [helm_release.cert_manager]
}


resource "helm_release" "linkerd" {
  chart       = local.ld
  version     = "1.9.1"
  repository  = "https://charts.jetstack.io"
  namespace   = local.ld
  name        = local.ld

  set         {
    name      = "installCRDs"
    value     = "true"
  }

  timeout           = 900 # 15 minutes.
  wait              = true
  wait_for_jobs     = true
  create_namespace  = true
  recreate_pods     = true
  cleanup_on_fail   = true

  depends_on = [helm_release.cert_manager]
}
