## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~>1.9 |
| <a name="requirement_yandex"></a> [yandex](#requirement\_yandex) | ~> 0.141.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | ~> 0.141.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [yandex_mdb_mysql_cluster.lns-mysql-clstr](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/mdb_mysql_cluster) | resource |
| [yandex_mdb_mysql_database.lns-mysql-db](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/mdb_mysql_database) | resource |
| [yandex_mdb_mysql_user.lns-mysql-user](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/mdb_mysql_user) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_id"></a> [cloud\_id](#input\_cloud\_id) | n/a | `string` | n/a | yes |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | n/a | `string` | n/a | yes |
| <a name="input_mysql_clstr_conf"></a> [mysql\_clstr\_conf](#input\_mysql\_clstr\_conf) | n/a | `map(any)` | <pre>{<br/>  "assign_public_ip": true,<br/>  "backup_priority": 100,<br/>  "deletion_protection": false,<br/>  "disk_size": 10,<br/>  "disk_type_id": "network-hdd",<br/>  "environment": "PRESTABLE",<br/>  "name": "mysql-clstr-lns",<br/>  "priority": 100,<br/>  "resource_preset_id": "b1.medium",<br/>  "version": "8.0"<br/>}</pre> | no |
| <a name="input_mysql_db_conf"></a> [mysql\_db\_conf](#input\_mysql\_db\_conf) | n/a | `map(any)` | <pre>{<br/>  "name": "mysql-db-lns"<br/>}</pre> | no |
| <a name="input_mysql_user_conf"></a> [mysql\_user\_conf](#input\_mysql\_user\_conf) | n/a | <pre>object({<br/>        name       = string<br/>        password   = string<br/>    })</pre> | n/a | yes |
| <a name="input_network_id"></a> [network\_id](#input\_network\_id) | n/a | `string` | n/a | yes |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | n/a | `list(string)` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | n/a | `string` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
