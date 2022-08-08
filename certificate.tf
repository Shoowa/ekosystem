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

  depends_on = [
    kubernetes_manifest.cm_issuer,
    helm_release.cert_manager,
  ]
}
