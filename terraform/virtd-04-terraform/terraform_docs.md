## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~>1.9)

## Providers

The following providers are used by this module:

- <a name="provider_template"></a> [template](#provider\_template) (2.2.0)

- <a name="provider_yandex"></a> [yandex](#provider\_yandex) (0.141.0)

## Modules

The following Modules are called:

### <a name="module_example-vm"></a> [example-vm](#module\_example-vm)

Source: git::https://github.com/udjin10/yandex_compute_instance.git

Version: main

### <a name="module_test-vm"></a> [test-vm](#module\_test-vm)

Source: git::https://github.com/udjin10/yandex_compute_instance.git

Version: main

### <a name="module_vpc_create"></a> [vpc\_create](#module\_vpc\_create)

Source: ./.terraform/modules/vpc

Version:

## Resources

The following resources are used by this module:

- [yandex_vpc_subnet.develop_b](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet) (resource)
- [template_file.cloudinit](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_cloud_id"></a> [cloud\_id](#input\_cloud\_id)

Description: n/a

Type: `string`

### <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id)

Description: n/a

Type: `string`

### <a name="input_token"></a> [token](#input\_token)

Description: n/a

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_default_sub_b"></a> [default\_sub\_b](#input\_default\_sub\_b)

Description: n/a

Type: `map`

Default:

```json
{
  "cidr": "10.0.2.0/24",
  "name": "develop-ru-central1-b",
  "zone": "ru-central1-b"
}
```

### <a name="input_metadata_base"></a> [metadata\_base](#input\_metadata\_base)

Description: n/a

Type: `map`

Default:

```json
{
  "serial-port-enable": 1,
  "ssh_public_key": "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKo1PzFWONiyzmkyJFXWIDYAy3zQuyCimmPFTF99eLfY lns@lnsnetol2"
}
```

### <a name="input_task_naming_a"></a> [task\_naming\_a](#input\_task\_naming\_a)

Description: n/a

Type: `string`

Default: `"develop"`

### <a name="input_task_naming_b"></a> [task\_naming\_b](#input\_task\_naming\_b)

Description: n/a

Type: `string`

Default: `"analytics"`

### <a name="input_vms_resources"></a> [vms\_resources](#input\_vms\_resources)

Description: n/a

Type: `map`

Default:

```json
{
  "example": {
    "image_family": "ubuntu-2004-lts",
    "instance_count": 1,
    "instance_name": "web-stage",
    "public_ip": true
  },
  "test": {
    "image_family": "ubuntu-2004-lts",
    "instance_count": 2,
    "instance_name": "web",
    "public_ip": true
  }
}
```

### <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name)

Description: VPC network&subnet name

Type: `string`

Default: `"develop"`

## Outputs

The following outputs are exported:

### <a name="output_out"></a> [out](#output\_out)

Description: n/a
