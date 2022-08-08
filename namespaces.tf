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

  # Avoid saving this secret in the TF State File.
  # Requires the Step executable locally to create a signing key pair.
  # View warning: https://registry.terraform.io/providers/hashicorp/tls/latest/docs#secrets-and-terraform-state
  provisioner "local-exec" {
    working_dir = "/tmp/"
    command     = <<-EOT
      cp ../../${path.module}/generate_signing_key_pair.sh /tmp/
      chmod u+x /tmp/generate_signing_key_pair.sh
      bash /tmp/generate_signing_key_pair.sh
    EOT
  }
}
