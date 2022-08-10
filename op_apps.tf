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
  atomic            = true

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      kubectl delete ns cert-manager
    EOT
  }

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
  atomic            = true

  depends_on = [helm_release.cert_manager]
}


resource "helm_release" "linkerd" {
  chart       = "linkerd2"
  version     = "2.11.4"
  repository  = local.ld
  namespace   = local.ld
  name        = local.ld

  set         {
    name      = "installNamespace"
    value     = "false"
  }

  set         {
    name      = "policyValidator.externalSecret"
    value     = "true"
  }

  set         {
    name      = "policyValidator.caBundle"
    value     = "ca.crt"
  }

  set         {
    name      = "proxyInjector.externalSecret"
    value     = "true"
  }

  set         {
    name      = "proxyInjector.caBundle"
    value     = "ca.crt"
  }

  set         {
    name      = "profileValidator.externalSecret"
    value     = "true"
  }

  set         {
    name      = "profileValidator.caBundle"
    value     = "ca.crt"
  }

  set         {
    name      = "tap.externalSecret"
    value     = "true"
  }

  set         {
    name      = "tap.caBundle"
    value     = "ca.crt"
  }

  set         {
    name      = "tapInjector.externalSecret"
    value     = "true"
  }

  set         {
    name      = "tapInjector.caBundle"
    value     = "ca.crt"
  }


  timeout           = 900 # 15 minutes.
  wait              = true
  wait_for_jobs     = true
  create_namespace  = true
  recreate_pods     = true
  cleanup_on_fail   = true
  atomic            = true

  depends_on = [
    kubernetes_manifest.cm_cert,
    kubernetes_manifest.linkerd_policy_validator,
    kubernetes_manifest.linkerd_proxy_injector,
    kubernetes_manifest.linkerd_sp_validator,
  ]
}


resource "helm_release" "linkerd_viz" {
  chart       = local.lv
  version     = "2.11.4"
  repository  = "linkerd"
  namespace   = local.lv
  name        = local.lv

  set         {
    name      = "identityTrustAnchorsPEM"
    value     = "ca.crt"
  }

  set         {
    name      = "identity.issuer.scheme"
    value     = "kubernetes.io/tls"
  }

  set         {
    name      = "installNamespace"
    value     = "false"
  }

  set         {
    name      = "tap.externalSecret"
    value     = "true"
  }

  set         {
    name      = "tap.caBundle"
    value     = "ca.crt"
  }

  set         {
    name      = "tapInjector.externalSecret"
    value     = "true"
  }

  set         {
    name      = "tapInjector.caBundle"
    value     = "ca.crt"
  }


  timeout           = 900 # 15 minutes.
  wait              = true
  wait_for_jobs     = true
  create_namespace  = true
  recreate_pods     = true
  cleanup_on_fail   = true
  atomic            = true

  depends_on = [
    kubernetes_manifest.cm_cert,
    kubernetes_manifest.linkerd_viz_tap,
    kubernetes_manifest.linkerd_viz_tap_injector,
    helm_release.linkerd,
  ]
}
