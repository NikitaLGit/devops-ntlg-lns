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

- [yandex_vpc_network.finalter](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_network) (resource)
- [yandex_vpc_subnet.sub_finalter](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id)

Description: n/a

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_env_name"></a> [env\_name](#input\_env\_name)

Description: env\_name

Type: `string`

Default: `"default_net"`

### <a name="input_subnets"></a> [subnets](#input\_subnets)

Description: n/a

Type:

```hcl
list(object({
    zone=string,
    cidr=string
    }))
```

Default:

```json
[
  {
    "cidr": "10.0.100.0/24",
    "zone": "ru-central1-a"
  }
]
```

## Outputs

The following outputs are exported:

### <a name="output_cidr"></a> [cidr](#output\_cidr)

Description: n/a

### <a name="output_name"></a> [name](#output\_name)

Description: n/a

### <a name="output_net_id"></a> [net\_id](#output\_net\_id)

Description: n/a

### <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id)

Description: n/a

### <a name="output_zone"></a> [zone](#output\_zone)

Description: n/a
