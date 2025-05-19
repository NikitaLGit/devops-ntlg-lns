# provider "vault" {
#  address = "http://${var.vault.ip}:${var.vault.port}"
#  skip_tls_verify = var.vault.skip_tls_verify
#  token = var.vault.token_vault
# }
# data "vault_generic_secret" "vault_example"{
#  path = "${var.vault.base_path}/example"
# }

# output "vault_example" {
#  value = "${nonsensitive(data.vault_generic_secret.vault_example.data)}"
# } 