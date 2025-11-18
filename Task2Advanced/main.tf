resource "null_resource" "example" {
  provisioner "local-exec" {
    command = "echo Hello from CI"
  }
}
