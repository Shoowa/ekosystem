locals {
  ks = "kube-system"
  cm = "cert-manager"
  lb_controller = "aws-load-balancer-controller"

  # LinkerD Control Plane
  ld = "linkerd"
  lv = "linkerd-viz"
  cm_issuer_name = "identity.linkerd.cluster.local"
  cm_anchor = "linkerd-trust-anchor"

  # LinkerD Data Plane, Webhook Certificates
  validator = "linkerd-policy-validator"
  injector = "linkerd-proxy-injector"
  sp = "linkerd-sp-validator"
  tap = "tap"
  tap_injector = "tap-injector"
}
