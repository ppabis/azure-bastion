
resource "random_string" "keyvault_name" {
  length  = 8
  special = false
  upper   = false
}

resource "azurerm_key_vault" "bastion_keyvault" {
  name                       = "bastion-kv-${random_string.keyvault_name.result}"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  sku_name                   = "standard"
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 7
  purge_protection_enabled   = false
}

resource "azurerm_key_vault_access_policy" "bastion_keyvault_access_policy" {
  key_vault_id       = azurerm_key_vault.bastion_keyvault.id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = data.azurerm_client_config.current.object_id
  secret_permissions = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"]
}