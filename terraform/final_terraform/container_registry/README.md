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
| [yandex_container_registry.cr-registry](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/container_registry) | resource |
| [yandex_container_registry_iam_binding.editor](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/container_registry_iam_binding) | resource |
| [yandex_iam_service_account.cr-user](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/iam_service_account) | resource |
| [yandex_resourcemanager_folder_iam_member.cr-role](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/resourcemanager_folder_iam_member) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_id"></a> [cloud\_id](#input\_cloud\_id) | n/a | `string` | n/a | yes |
| <a name="input_cr_conf"></a> [cr\_conf](#input\_cr\_conf) | n/a | `map(any)` | <pre>{<br/>  "registry_name": "cr-lns-main",<br/>  "role": "container-registry.editor"<br/>}</pre> | no |
| <a name="input_cr_user_conf"></a> [cr\_user\_conf](#input\_cr\_user\_conf) | n/a | `map(any)` | <pre>{<br/>  "name": "cr-editor-lns",<br/>  "role": "editor"<br/>}</pre> | no |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | n/a | `string` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
