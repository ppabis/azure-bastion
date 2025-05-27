resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 3072
}

variable "ssh_save_to_file" {
  description = "Whether to save the SSH private key to a file"
  type    = bool
  default = true
}

resource "local_sensitive_file" "ssh_key_file" {
  count    = var.ssh_save_to_file ? 1 : 0
  filename = "${path.module}/ssh_key.pem"
  content  = tls_private_key.ssh_key.private_key_openssh
}