output "cert_manager_namespace" {
  value = helm_release.cert_manager.namespace
}


output "cert_manager_version" {
  value = helm_release.cert_manager.version
}


output "cert_manager_chart" {
  value = helm_release.cert_manager.chart
}


output "cert_manager_status" {
  value = helm_release.cert_manager.status
}


output "cert_manager_values" {
  value = helm_release.cert_manager.values
}


output "cert_manager_manifest" {
  value = helm_release.cert_manager.manifest
}


output "lb_controller_namespace" {
  value = helm_release.lb_controller.namespace
}


output "lb_controller_version" {
  value = helm_release.lb_controller.version
}


output "lb_controller_chart" {
  value = helm_release.lb_controller.chart
}


output "lb_controller_status" {
  value = helm_release.lb_controller.status
}


output "lb_controller_values" {
  value = helm_release.lb_controller.values
}


output "lb_controller_manifest" {
  value = helm_release.lb_controller.manifest
}
