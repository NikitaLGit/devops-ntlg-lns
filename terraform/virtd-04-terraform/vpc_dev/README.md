## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~>1.9)

## Providers

The following providers are used by this module:

- <a name="provider_yandex"></a> [yandex](#provider\_yandex) (0.141.0)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [yandex_vpc_network.develop](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_network) (resource)
- [yandex_vpc_subnet.sub_develop](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet) (resource)

## Required Inputs

No required inputs.

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_env_name"></a> [env\_name](#input\_env\_name)

Description: env\_name\_parametr

Type: `string`

Default: `"def_develop"`

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
    "zone": "def_ru-central1-a"
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
