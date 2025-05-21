## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~>1.9)

- <a name="requirement_template"></a> [template](#requirement\_template) (~> 2.2)

- <a name="requirement_yandex"></a> [yandex](#requirement\_yandex) (~> 0.141.0)

## Providers

The following providers are used by this module:

- <a name="provider_template"></a> [template](#provider\_template) (2.2.0)

## Modules

The following Modules are called:

### <a name="module_vm_create"></a> [vm\_create](#module\_vm\_create)

Source: ./vm_create

Version:

### <a name="module_vpc_dev"></a> [vpc\_dev](#module\_vpc\_dev)

Source: ./vpc_dev

Version:

## Resources

The following resources are used by this module:

- [template_file.cloudinit](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) (data source)

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

### <a name="input_zone"></a> [zone](#input\_zone)

Description: n/a

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_metadata_base"></a> [metadata\_base](#input\_metadata\_base)

Description: n/a

Type:

```hcl
object({
    ssh_name = string
    serial-port-enable = number
    ssh_public_key = string
  })
```

Default:

```json
{
  "serial-port-enable": 1,
  "ssh_name": "default",
  "ssh_public_key": "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKo1PzFWONiyzmkyJFXWIDYAy3zQuyCimmPFTF99eLfY lns@lnsnetol2"
}
```

### <a name="input_vms_resources"></a> [vms\_resources](#input\_vms\_resources)

Description: n/a

Type: `map`

Default:

```json
{
  "image_family": "ubuntu-2004-lts",
  "instance_count": 1,
  "instance_name": "web",
  "public_ip": true
}
```

### <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name)

Description: VPC network & subnet name

Type: `string`

Default: `"finalter"`

## Outputs

No outputs.
