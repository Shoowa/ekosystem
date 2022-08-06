resource "kubernetes_namespace" "app_home" {
  metadata {
    name = "primary"

    annotations = {
      team = "app",
    }
  }
}


resource "kubernetes_namespace" "linkerd" {
  metadata {
    name = "linkerd"

    annotations = {
      team = "ops",
    }
  }
}
