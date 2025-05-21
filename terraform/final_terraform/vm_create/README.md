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
| [yandex_compute_instance.vm](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance) | resource |
| [yandex_vpc_security_group.lns](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group) | resource |
| [yandex_compute_image.my_image](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/data-sources/compute_image) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_boot_disk_size"></a> [boot\_disk\_size](#input\_boot\_disk\_size) | n/a | `number` | `10` | no |
| <a name="input_boot_disk_type"></a> [boot\_disk\_type](#input\_boot\_disk\_type) | n/a | `string` | `"network-hdd"` | no |
| <a name="input_cloud_id"></a> [cloud\_id](#input\_cloud\_id) | n/a | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | n/a | `string` | `"TODO: description;"` | no |
| <a name="input_env_name"></a> [env\_name](#input\_env\_name) | n/a | `string` | `null` | no |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | n/a | `string` | n/a | yes |
| <a name="input_image_family"></a> [image\_family](#input\_image\_family) | n/a | `string` | `"ubuntu-2004-lts"` | no |
| <a name="input_instance_core_fraction"></a> [instance\_core\_fraction](#input\_instance\_core\_fraction) | n/a | `number` | `5` | no |
| <a name="input_instance_cores"></a> [instance\_cores](#input\_instance\_cores) | n/a | `number` | `2` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | n/a | `number` | `1` | no |
| <a name="input_instance_memory"></a> [instance\_memory](#input\_instance\_memory) | n/a | `number` | `1` | no |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | n/a | `string` | `"vm"` | no |
| <a name="input_known_internal_ip"></a> [known\_internal\_ip](#input\_known\_internal\_ip) | n/a | `string` | `""` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | for dynamic block 'labels' | `map(string)` | `{}` | no |
| <a name="input_metadata"></a> [metadata](#input\_metadata) | for dynamic block 'metadata' | `map(string)` | n/a | yes |
| <a name="input_network_id"></a> [network\_id](#input\_network\_id) | n/a | `string` | n/a | yes |
| <a name="input_platform"></a> [platform](#input\_platform) | Example to validate VM platform. | `string` | `"standard-v1"` | no |
| <a name="input_preemptible"></a> [preemptible](#input\_preemptible) | n/a | `bool` | `true` | no |
| <a name="input_public_ip"></a> [public\_ip](#input\_public\_ip) | n/a | `bool` | `false` | no |
| <a name="input_security_group_egress"></a> [security\_group\_egress](#input\_security\_group\_egress) | secrules egress | <pre>list(object(<br/>    {<br/>      protocol       = string<br/>      description    = string<br/>      v4_cidr_blocks = list(string)<br/>      port           = optional(number)<br/>      from_port      = optional(number)<br/>      to_port        = optional(number)<br/>  }))</pre> | <pre>[<br/>  {<br/>    "description": "разрешить весь исходящий трафик",<br/>    "from_port": 0,<br/>    "protocol": "TCP",<br/>    "to_port": 65365,<br/>    "v4_cidr_blocks": [<br/>      "0.0.0.0/0"<br/>    ]<br/>  }<br/>]</pre> | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | n/a | `list(string)` | `[]` | no |
| <a name="input_security_group_ingress"></a> [security\_group\_ingress](#input\_security\_group\_ingress) | secrules ingress | <pre>list(object(<br/>    {<br/>      protocol       = string<br/>      description    = string<br/>      v4_cidr_blocks = list(string)<br/>      port           = optional(number)<br/>      from_port      = optional(number)<br/>      to_port        = optional(number)<br/>  }))</pre> | <pre>[<br/>  {<br/>    "description": "разрешить входящий ssh",<br/>    "port": 22,<br/>    "protocol": "TCP",<br/>    "v4_cidr_blocks": [<br/>      "0.0.0.0/0"<br/>    ]<br/>  },<br/>  {<br/>    "description": "разрешить входящий  http",<br/>    "port": 80,<br/>    "protocol": "TCP",<br/>    "v4_cidr_blocks": [<br/>      "0.0.0.0/0"<br/>    ]<br/>  },<br/>  {<br/>    "description": "разрешить входящий https",<br/>    "port": 443,<br/>    "protocol": "TCP",<br/>    "v4_cidr_blocks": [<br/>      "0.0.0.0/0"<br/>    ]<br/>  }<br/>]</pre> | no |
| <a name="input_service_account_id"></a> [service\_account\_id](#input\_service\_account\_id) | n/a | `string` | `null` | no |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | n/a | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | n/a | `list(string)` | n/a | yes |
| <a name="input_subnet_zones"></a> [subnet\_zones](#input\_subnet\_zones) | n/a | `list(string)` | n/a | yes |
| <a name="input_yandex_vpc_network_finalter_id"></a> [yandex\_vpc\_network\_finalter\_id](#input\_yandex\_vpc\_network\_finalter\_id) | n/a | `string` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_external_ip_address"></a> [external\_ip\_address](#output\_external\_ip\_address) | n/a |
| <a name="output_fqdn"></a> [fqdn](#output\_fqdn) | n/a |
| <a name="output_internal_ip_address"></a> [internal\_ip\_address](#output\_internal\_ip\_address) | n/a |
| <a name="output_labels"></a> [labels](#output\_labels) | n/a |
| <a name="output_network_interface"></a> [network\_interface](#output\_network\_interface) | n/a |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | n/a |
