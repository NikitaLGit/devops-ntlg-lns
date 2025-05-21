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

- [yandex_compute_instance.vm](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance) (resource)
- [yandex_vpc_security_group.lns](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group) (resource)
- [yandex_compute_image.my_image](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/data-sources/compute_image) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_cloud_id"></a> [cloud\_id](#input\_cloud\_id)

Description: n/a

Type: `string`

### <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id)

Description: n/a

Type: `string`

### <a name="input_metadata"></a> [metadata](#input\_metadata)

Description: for dynamic block 'metadata'

Type: `map(string)`

### <a name="input_network_id"></a> [network\_id](#input\_network\_id)

Description: n/a

Type: `string`

### <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key)

Description: n/a

Type: `string`

### <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids)

Description: n/a

Type: `list(string)`

### <a name="input_subnet_zones"></a> [subnet\_zones](#input\_subnet\_zones)

Description: n/a

Type: `list(string)`

### <a name="input_yandex_vpc_network_finalter_id"></a> [yandex\_vpc\_network\_finalter\_id](#input\_yandex\_vpc\_network\_finalter\_id)

Description: n/a

Type: `string`

### <a name="input_zone"></a> [zone](#input\_zone)

Description: n/a

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_boot_disk_size"></a> [boot\_disk\_size](#input\_boot\_disk\_size)

Description: n/a

Type: `number`

Default: `10`

### <a name="input_boot_disk_type"></a> [boot\_disk\_type](#input\_boot\_disk\_type)

Description: n/a

Type: `string`

Default: `"network-hdd"`

### <a name="input_description"></a> [description](#input\_description)

Description: n/a

Type: `string`

Default: `"TODO: description;"`

### <a name="input_env_name"></a> [env\_name](#input\_env\_name)

Description: n/a

Type: `string`

Default: `null`

### <a name="input_image_family"></a> [image\_family](#input\_image\_family)

Description: n/a

Type: `string`

Default: `"ubuntu-2004-lts"`

### <a name="input_instance_core_fraction"></a> [instance\_core\_fraction](#input\_instance\_core\_fraction)

Description: n/a

Type: `number`

Default: `5`

### <a name="input_instance_cores"></a> [instance\_cores](#input\_instance\_cores)

Description: n/a

Type: `number`

Default: `2`

### <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count)

Description: n/a

Type: `number`

Default: `1`

### <a name="input_instance_memory"></a> [instance\_memory](#input\_instance\_memory)

Description: n/a

Type: `number`

Default: `1`

### <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name)

Description: n/a

Type: `string`

Default: `"vm"`

### <a name="input_known_internal_ip"></a> [known\_internal\_ip](#input\_known\_internal\_ip)

Description: n/a

Type: `string`

Default: `""`

### <a name="input_labels"></a> [labels](#input\_labels)

Description: for dynamic block 'labels'

Type: `map(string)`

Default: `{}`

### <a name="input_platform"></a> [platform](#input\_platform)

Description: Example to validate VM platform.

Type: `string`

Default: `"standard-v1"`

### <a name="input_preemptible"></a> [preemptible](#input\_preemptible)

Description: n/a

Type: `bool`

Default: `true`

### <a name="input_public_ip"></a> [public\_ip](#input\_public\_ip)

Description: n/a

Type: `bool`

Default: `false`

### <a name="input_security_group_egress"></a> [security\_group\_egress](#input\_security\_group\_egress)

Description: secrules egress

Type:

```hcl
list(object(
    {
      protocol       = string
      description    = string
      v4_cidr_blocks = list(string)
      port           = optional(number)
      from_port      = optional(number)
      to_port        = optional(number)
  }))
```

Default:

```json
[
  {
    "description": "разрешить весь исходящий трафик",
    "from_port": 0,
    "protocol": "TCP",
    "to_port": 65365,
    "v4_cidr_blocks": [
      "0.0.0.0/0"
    ]
  }
]
```

### <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids)

Description: n/a

Type: `list(string)`

Default: `[]`

### <a name="input_security_group_ingress"></a> [security\_group\_ingress](#input\_security\_group\_ingress)

Description: secrules ingress

Type:

```hcl
list(object(
    {
      protocol       = string
      description    = string
      v4_cidr_blocks = list(string)
      port           = optional(number)
      from_port      = optional(number)
      to_port        = optional(number)
  }))
```

Default:

```json
[
  {
    "description": "разрешить входящий ssh",
    "port": 22,
    "protocol": "TCP",
    "v4_cidr_blocks": [
      "0.0.0.0/0"
    ]
  },
  {
    "description": "разрешить входящий  http",
    "port": 80,
    "protocol": "TCP",
    "v4_cidr_blocks": [
      "0.0.0.0/0"
    ]
  },
  {
    "description": "разрешить входящий https",
    "port": 443,
    "protocol": "TCP",
    "v4_cidr_blocks": [
      "0.0.0.0/0"
    ]
  }
]
```

### <a name="input_service_account_id"></a> [service\_account\_id](#input\_service\_account\_id)

Description: n/a

Type: `string`

Default: `null`

## Outputs

The following outputs are exported:

### <a name="output_external_ip_address"></a> [external\_ip\_address](#output\_external\_ip\_address)

Description: n/a

### <a name="output_fqdn"></a> [fqdn](#output\_fqdn)

Description: n/a

### <a name="output_internal_ip_address"></a> [internal\_ip\_address](#output\_internal\_ip\_address)

Description: n/a

### <a name="output_labels"></a> [labels](#output\_labels)

Description: n/a

### <a name="output_network_interface"></a> [network\_interface](#output\_network\_interface)

Description: n/a

### <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id)

Description: n/a
