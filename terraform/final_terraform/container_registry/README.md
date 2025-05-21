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

- [yandex_container_registry.cr-registry](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/container_registry) (resource)
- [yandex_container_registry_iam_binding.editor](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/container_registry_iam_binding) (resource)
- [yandex_iam_service_account.cr-user](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/iam_service_account) (resource)
- [yandex_resourcemanager_folder_iam_member.cr-role](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/resourcemanager_folder_iam_member) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_cloud_id"></a> [cloud\_id](#input\_cloud\_id)

Description: n/a

Type: `string`

### <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id)

Description: n/a

Type: `string`

### <a name="input_zone"></a> [zone](#input\_zone)

Description: n/a

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_cr_conf"></a> [cr\_conf](#input\_cr\_conf)

Description: n/a

Type: `map(any)`

Default:

```json
{
  "registry_name": "cr-lns-main",
  "role": "container-registry.editor"
}
```

### <a name="input_cr_user_conf"></a> [cr\_user\_conf](#input\_cr\_user\_conf)

Description: n/a

Type: `map(any)`

Default:

```json
{
  "name": "cr-editor-lns",
  "role": "editor"
}
```

## Outputs

No outputs.
