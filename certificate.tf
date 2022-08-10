resource "kubernetes_manifest" "cm_issuer" {
  manifest        = {
    apiVersion    = "cert-manager.io/v1"
    kind          = "Issuer"

    metadata        = {
      name          = local.cm_anchor
      namespace     = local.ld
    }

    spec            = {
      ca            = {
        secretName  = local.cm_anchor
      }
    }
  }

  timeouts  {
    create  = "5m"
    delete  = "5m"
    update  = "5m"
  }

  depends_on = [
    kubernetes_namespace.linkerd,
    helm_release.cert_manager,
  ]
}

resource "kubernetes_manifest" "cm_cert" {
  manifest        = {
    apiVersion    = "cert-manager.io/v1"
    kind          = "Certificate"

    metadata        = {
      name          = "linkerd-identity-issuer"
      namespace     = local.ld
    }

    spec            = {
      secretName    = "linkerd-identity-issuer"
      isCA          = true
      usages        = ["cert sign", "crl sign", "server auth", "client auth"]
      duration      = "48h0m0s"
      renewBefore   = "25h0m0s"
      commonName    = local.cm_issuer_name
      dnsNames      = [local.cm_issuer_name]
      privateKey    = {algorithm = "ECDSA"}
      issuerRef     = {
        name        = local.cm_anchor
        kind        = "Issuer"
      }
    }
  }

  wait {
    condition {
      status  = "True"
      type    = "Ready"
    }
  }

  timeouts  {
    create  = "5m"
    delete  = "5m"
    update  = "5m"
  }

  depends_on = [kubernetes_manifest.cm_issuer]
}


# LinkerD Webhook certificates
resource "kubernetes_manifest" "linkerd_webhook_issuer" {
  manifest        = {
    apiVersion    = "cert-manager.io/v1"
    kind          = "Issuer"

    metadata        = {
      name          = "webhook-issuer"
      namespace     = local.ld
    }

    spec            = {
      ca            = {
        secretName  = "webhook-issuer-tls"
      }
    }
  }

  timeouts  {
    create  = "5m"
    delete  = "5m"
    update  = "5m"
  }

  depends_on = [
    kubernetes_namespace.linkerd,
    kubernetes_manifest.cm_issuer,
  ]
}


resource "kubernetes_manifest" "linkerd_viz_webhook_issuer" {
  manifest        = {
    apiVersion    = "cert-manager.io/v1"
    kind          = "Issuer"

    metadata        = {
      name          = "webhook-issuer"
      namespace     = "linkerd-viz"
    }

    spec            = {
      ca            = {
        secretName  = "webhook-issuer-tls"
      }
    }
  }

  timeouts  {
    create  = "5m"
    delete  = "5m"
    update  = "5m"
  }

  depends_on = [
    kubernetes_manifest.cm_issuer,
    kubernetes_namespace.linkerd_viz,
  ]
}


resource "kubernetes_manifest" "linkerd_policy_validator" {
  manifest        = {
    apiVersion    = "cert-manager.io/v1"
    kind          = "Certificate"

    metadata        = {
      name          = local.validator
      namespace     = local.ld
    }

    spec            = {
      secretName    = "${local.validator}-k8s-tls"
      isCA          = false
      usages        = ["server auth"]
      duration      = "24h0m0s"
      renewBefore   = "1h0m0s"
      commonName    = "${local.validator}.linkerd.svc"
      dnsNames      = ["${local.validator}.linkerd.svc"]
      privateKey    = {algorithm = "ECDSA", encoding = "PKCS8"}
      issuerRef     = {
        name        = "webhook-issuer"
        kind        = "Issuer"
      }
    }
  }

  wait {
    condition {
      status  = "True"
      type    = "Ready"
    }
  }

  timeouts  {
    create  = "5m"
    delete  = "5m"
    update  = "5m"
  }

  depends_on = [kubernetes_manifest.linkerd_webhook_issuer]
}


resource "kubernetes_manifest" "linkerd_proxy_injector" {
  manifest        = {
    apiVersion    = "cert-manager.io/v1"
    kind          = "Certificate"

    metadata        = {
      name          = local.injector
      namespace     = local.ld
    }

    spec            = {
      secretName    = "${local.injector}-k8s-tls"
      isCA          = false
      usages        = ["server auth"]
      duration      = "24h0m0s"
      renewBefore   = "1h0m0s"
      commonName    = "${local.injector}.linkerd.svc"
      dnsNames      = ["${local.injector}.linkerd.svc"]
      privateKey    = {algorithm = "ECDSA"}
      issuerRef     = {
        name        = "webhook-issuer"
        kind        = "Issuer"
      }
    }
  }

  wait {
    condition {
      status  = "True"
      type    = "Ready"
    }
  }

  timeouts  {
    create  = "5m"
    delete  = "5m"
    update  = "5m"
  }

  depends_on = [kubernetes_manifest.linkerd_webhook_issuer]
}


resource "kubernetes_manifest" "linkerd_sp_validator" {
  manifest        = {
    apiVersion    = "cert-manager.io/v1"
    kind          = "Certificate"

    metadata        = {
      name          = local.sp
      namespace     = local.ld
    }

    spec            = {
      secretName    = "${local.sp}-k8s-tls"
      isCA          = false
      usages        = ["server auth"]
      duration      = "24h0m0s"
      renewBefore   = "1h0m0s"
      commonName    = "${local.sp}.linkerd.svc"
      dnsNames      = ["${local.sp}.linkerd.svc"]
      privateKey    = {algorithm = "ECDSA"}
      issuerRef     = {
        name        = "webhook-issuer"
        kind        = "Issuer"
      }
    }
  }

  wait {
    condition {
      status  = "True"
      type    = "Ready"
    }
  }

  timeouts  {
    create  = "5m"
    delete  = "5m"
    update  = "5m"
  }

  depends_on = [kubernetes_manifest.linkerd_webhook_issuer]
}


resource "kubernetes_manifest" "linkerd_viz_tap" {
  manifest        = {
    apiVersion    = "cert-manager.io/v1"
    kind          = "Certificate"

    metadata        = {
      name          = local.tap
      namespace     = local.lv
    }

    spec            = {
      secretName    = "${local.tap}-k8s-tls"
      isCA          = false
      usages        = ["server auth"]
      duration      = "24h0m0s"
      renewBefore   = "1h0m0s"
      commonName    = "${local.tap}.linkerd-viz.svc"
      dnsNames      = ["${local.tap}.linkerd-viz.svc"]
      privateKey    = {algorithm = "ECDSA"}
      issuerRef     = {
        name        = "webhook-issuer"
        kind        = "Issuer"
      }
    }
  }

  wait {
    condition {
      status  = "True"
      type    = "Ready"
    }
  }

  timeouts  {
    create  = "5m"
    delete  = "5m"
    update  = "5m"
  }

  depends_on = [kubernetes_manifest.linkerd_viz_webhook_issuer]
}


resource "kubernetes_manifest" "linkerd_viz_tap_injector" {
  manifest        = {
    apiVersion    = "cert-manager.io/v1"
    kind          = "Certificate"

    metadata        = {
      name          = local.tap_injector
      namespace     = local.lv
    }

    spec            = {
      secretName    = "${local.tap_injector}-k8s-tls"
      isCA          = false
      usages        = ["server auth"]
      duration      = "24h0m0s"
      renewBefore   = "1h0m0s"
      commonName    = "${local.tap_injector}.linkerd-viz.svc"
      dnsNames      = ["${local.tap_injector}.linkerd-viz.svc"]
      privateKey    = {algorithm = "ECDSA"}
      issuerRef     = {
        name        = "webhook-issuer"
        kind        = "Issuer"
      }
    }
  }

  wait {
    condition {
      status  = "True"
      type    = "Ready"
    }
  }

  timeouts  {
    create  = "5m"
    delete  = "5m"
    update  = "5m"
  }

  depends_on = [kubernetes_manifest.linkerd_viz_webhook_issuer]
}
