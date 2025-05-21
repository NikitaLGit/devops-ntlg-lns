## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~>1.9)

- <a name="requirement_yandex"></a> [yandex](#requirement\_yandex) (~> 0.141.0)

## Providers

The following providers are used by this module:

- <a name="provider_yandex"></a> [yandex](#provider\_yandex) (~> 0.141.0)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [yandex_mdb_mysql_cluster.lns-mysql-clstr](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/mdb_mysql_cluster) (resource)
- [yandex_mdb_mysql_database.lns-mysql-db](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/mdb_mysql_database) (resource)
- [yandex_mdb_mysql_user.lns-mysql-user](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/mdb_mysql_user) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_cloud_id"></a> [cloud\_id](#input\_cloud\_id)

Description: n/a

Type: `string`

### <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id)

Description: n/a

Type: `string`

### <a name="input_mysql_user_conf"></a> [mysql\_user\_conf](#input\_mysql\_user\_conf)

Description: n/a

Type:

```hcl
object({
        name       = string
        password   = string
    })
```

### <a name="input_network_id"></a> [network\_id](#input\_network\_id)

Description: n/a

Type: `string`

### <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids)

Description: n/a

Type: `list(string)`

### <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id)

Description: n/a

Type: `string`

### <a name="input_zone"></a> [zone](#input\_zone)

Description: n/a

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_mysql_clstr_conf"></a> [mysql\_clstr\_conf](#input\_mysql\_clstr\_conf)

Description: n/a

Type: `map(any)`

Default:

```json
{
  "assign_public_ip": true,
  "backup_priority": 100,
  "deletion_protection": false,
  "disk_size": 10,
  "disk_type_id": "network-hdd",
  "environment": "PRESTABLE",
  "name": "mysql-clstr-lns",
  "priority": 100,
  "resource_preset_id": "b1.medium",
  "version": "8.0"
}
```

### <a name="input_mysql_db_conf"></a> [mysql\_db\_conf](#input\_mysql\_db\_conf)

Description: n/a

Type: `map(any)`

Default:

```json
{
  "name": "mysql-db-lns"
}
```

## Outputs

No outputs.
