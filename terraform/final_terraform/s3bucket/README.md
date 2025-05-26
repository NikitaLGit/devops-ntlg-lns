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
| [yandex_iam_service_account.s3-sa](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/iam_service_account) | resource |
| [yandex_iam_service_account_static_access_key.s3-static-key](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/iam_service_account_static_access_key) | resource |
| [yandex_resourcemanager_folder_iam_member.s3-admin](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/resourcemanager_folder_iam_member) | resource |
| [yandex_storage_bucket.s3-bucket-lns](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/storage_bucket) | resource |
| [yandex_storage_object.s3-object-lns](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/storage_object) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_id"></a> [cloud\_id](#input\_cloud\_id) | n/a | `string` | n/a | yes |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | n/a | `string` | n/a | yes |
| <a name="input_s3_conf"></a> [s3\_conf](#input\_s3\_conf) | n/a | <pre>object({<br/>    service_name = string<br/>    sa_role      = string<br/>    name      = string<br/>    key          = string<br/>    size         = number<br/>    storage_class = string<br/>    flags_read        = bool<br/>    flags_list        = bool<br/>    flags_config_read = bool<br/>    force_destroy    = bool<br/>  })</pre> | <pre>{<br/>  "flags_config_read": false,<br/>  "flags_list": false,<br/>  "flags_read": false,<br/>  "force_destroy": false,<br/>  "key": "",<br/>  "name": "lns-bucket-final",<br/>  "sa_role": "storage.admin",<br/>  "service_name": "s3admin",<br/>  "size": 1073741824,<br/>  "storage_class": "standard"<br/>}</pre> | no |
| <a name="input_source_file"></a> [source\_file](#input\_source\_file) | n/a | `string` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | n/a | `string` | `"ru-central1-b"` | no |

## Outputs

No outputs.
