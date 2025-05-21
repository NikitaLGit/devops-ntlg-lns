## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~>1.9 |
| <a name="requirement_template"></a> [template](#requirement\_template) | ~> 2.2 |
| <a name="requirement_yandex"></a> [yandex](#requirement\_yandex) | ~> 0.141.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vm_create"></a> [vm\_create](#module\_vm\_create) | ./vm_create | n/a |
| <a name="module_vpc_dev"></a> [vpc\_dev](#module\_vpc\_dev) | ./vpc_dev | n/a |

## Resources

| Name | Type |
|------|------|
| [template_file.cloudinit](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_id"></a> [cloud\_id](#input\_cloud\_id) | n/a | `string` | n/a | yes |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | n/a | `string` | n/a | yes |
| <a name="input_metadata_base"></a> [metadata\_base](#input\_metadata\_base) | n/a | <pre>object({<br/>    ssh_name = string<br/>    serial-port-enable = number<br/>    ssh_public_key = string<br/>  })</pre> | <pre>{<br/>  "serial-port-enable": 1,<br/>  "ssh_name": "default",<br/>  "ssh_public_key": "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKo1PzFWONiyzmkyJFXWIDYAy3zQuyCimmPFTF99eLfY lns@lnsnetol2"<br/>}</pre> | no |
| <a name="input_mysql_user_conf"></a> [mysql\_user\_conf](#input\_mysql\_user\_conf) | n/a | <pre>object({<br/>        name       = string<br/>        password   = string<br/>    })</pre> | n/a | yes |
| <a name="input_vms_resources"></a> [vms\_resources](#input\_vms\_resources) | n/a | `map` | <pre>{<br/>  "image_family": "ubuntu-2004-lts",<br/>  "instance_count": 1,<br/>  "instance_name": "web",<br/>  "public_ip": true<br/>}</pre> | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | VPC network & subnet name | `string` | `"finalter"` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
