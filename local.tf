locals {
  ks = "kube-system"
  cm = "cert-manager"
  ld = "linkerd"
  lb_controller = "aws-load-balancer-controller"
  cm_issuer_name = "identity.linkerd.cluster.local"
  cm_anchor = "linkerd-trust-anchor"
}
