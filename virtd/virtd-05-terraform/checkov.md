2025-05-19 20:22:07,074 [MainThread  ] [WARNI]  Failed to get the checkov mappings and guidelines from https://api0.prismacloud.io/bridgecrew/api/v2/guidelines. Skips using BC_* IDs will not work.
Traceback (most recent call last):
  File "/usr/local/lib/python3.11/site-packages/urllib3/connection.py", line 196, in _new_conn
    sock = connection.create_connection(
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/local/lib/python3.11/site-packages/urllib3/util/connection.py", line 85, in create_connection
    raise err
  File "/usr/local/lib/python3.11/site-packages/urllib3/util/connection.py", line 73, in create_connection
    sock.connect(sa)
TimeoutError: timed out

The above exception was the direct cause of the following exception:

Traceback (most recent call last):
  File "/usr/local/lib/python3.11/site-packages/urllib3/connectionpool.py", line 789, in urlopen
    response = self._make_request(
               ^^^^^^^^^^^^^^^^^^^
  File "/usr/local/lib/python3.11/site-packages/urllib3/connectionpool.py", line 490, in _make_request
    raise new_e
  File "/usr/local/lib/python3.11/site-packages/urllib3/connectionpool.py", line 466, in _make_request
    self._validate_conn(conn)
  File "/usr/local/lib/python3.11/site-packages/urllib3/connectionpool.py", line 1095, in _validate_conn
    conn.connect()
  File "/usr/local/lib/python3.11/site-packages/urllib3/connection.py", line 615, in connect
    self.sock = sock = self._new_conn()
                       ^^^^^^^^^^^^^^^^
  File "/usr/local/lib/python3.11/site-packages/urllib3/connection.py", line 205, in _new_conn
    raise ConnectTimeoutError(
urllib3.exceptions.ConnectTimeoutError: (<urllib3.connection.HTTPSConnection object at 0x7fbae4cd8f10>, 'Connection to api0.prismacloud.io timed out. (connect timeout=3.1)')

The above exception was the direct cause of the following exception:

Traceback (most recent call last):
  File "/usr/local/lib/python3.11/site-packages/checkov/common/bridgecrew/platform_integration.py", line 1273, in get_public_run_config
    request = self.http.request("GET", self.guidelines_api_url, headers=headers)  # type:ignore[no-untyped-call]
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/local/lib/python3.11/site-packages/urllib3/_request_methods.py", line 136, in request
    return self.request_encode_url(
           ^^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/local/lib/python3.11/site-packages/urllib3/_request_methods.py", line 183, in request_encode_url
    return self.urlopen(method, url, **extra_kw)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/local/lib/python3.11/site-packages/urllib3/poolmanager.py", line 443, in urlopen
    response = conn.urlopen(method, u.request_uri, **kw)
               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/local/lib/python3.11/site-packages/urllib3/connectionpool.py", line 873, in urlopen
    return self.urlopen(
           ^^^^^^^^^^^^^
  File "/usr/local/lib/python3.11/site-packages/urllib3/connectionpool.py", line 873, in urlopen
    return self.urlopen(
           ^^^^^^^^^^^^^
  File "/usr/local/lib/python3.11/site-packages/urllib3/connectionpool.py", line 873, in urlopen
    return self.urlopen(
           ^^^^^^^^^^^^^
  File "/usr/local/lib/python3.11/site-packages/urllib3/connectionpool.py", line 843, in urlopen
    retries = retries.increment(
              ^^^^^^^^^^^^^^^^^^
  File "/usr/local/lib/python3.11/site-packages/urllib3/util/retry.py", line 519, in increment
    raise MaxRetryError(_pool, url, reason) from reason  # type: ignore[arg-type]
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
urllib3.exceptions.MaxRetryError: HTTPSConnectionPool(host='api0.prismacloud.io', port=443): Max retries exceeded with url: /bridgecrew/api/v2/guidelines (Caused by ConnectTimeoutError(<urllib3.connection.HTTPSConnection object at 0x7fbae4cd8f10>, 'Connection to api0.prismacloud.io timed out. (connect timeout=3.1)'))
2025-05-19 20:22:07,117 [MainThread  ] [WARNI]  Failed to download module git::https://github.com/udjin10/yandex_compute_instance.git?ref=main:None (for external modules, the --download-external-modules flag is required)
   ${toset(${data.terraform_remote_state.vms.outputs.out})}
SyntaxError: invalid syntax (<unknown>, line 1)
   toset(${data.terraform_remote_state.vms.outputs.out})
SyntaxError: invalid syntax (<unknown>, line 1)
   "["['10.0.1.0/24']"]"
SyntaxError: invalid syntax (<unknown>, line 1)
   ""["['10.0.1.0/24']"]""
SyntaxError: invalid syntax (<unknown>, line 1)
   ${yandex_vpc_network.develop.id}
SyntaxError: invalid syntax (<unknown>, line 1)
   ${toset(${data.terraform_remote_state.vms.outputs.out})}
SyntaxError: invalid syntax (<unknown>, line 1)
   ${data.terraform_remote_state.vms.outputs.out}
SyntaxError: invalid syntax (<unknown>, line 1)
   ${{for k , v in random_password.input_vms : k => nonsensitive(v.result)}}
SyntaxError: invalid syntax (<unknown>, line 1)
   {for k , v in random_password.input_vms : k :> nonsensitive(v.result)}
SyntaxError: invalid syntax (<unknown>, line 1)
   ${string}
SyntaxError: invalid syntax (<unknown>, line 1)
   ${string}
SyntaxError: invalid syntax (<unknown>, line 1)
   ${string}
SyntaxError: invalid syntax (<unknown>, line 1)
   ${string}
SyntaxError: invalid syntax (<unknown>, line 1)
   10.0.1.0/24
SyntaxError: invalid syntax (<unknown>, line 1)
   10.0.1.0/24
SyntaxError: invalid syntax (<unknown>, line 1)
   ${list(string)}
SyntaxError: invalid syntax (<unknown>, line 1)
   ${string}
SyntaxError: invalid syntax (<unknown>, line 1)
   ${yandex_vpc_network.develop.id}
SyntaxError: invalid syntax (<unknown>, line 1)
   git::https://github.com/udjin10/yandex_compute_instance.git?ref=main
SyntaxError: invalid syntax (<unknown>, line 1)
   git::https://github.com/udjin10/yandex_compute_instance.git?ref=main
SyntaxError: invalid syntax (<unknown>, line 1)
   ${yandex_vpc_subnet.develop_a.id}
SyntaxError: invalid syntax (<unknown>, line 1)
   ${yandex_vpc_subnet.develop_b.id}
SyntaxError: invalid syntax (<unknown>, line 1)
   ${data.template_file.cloudinit.rendered}
SyntaxError: invalid syntax (<unknown>, line 1)
   ${yandex_vpc_network.develop.id}
SyntaxError: invalid syntax (<unknown>, line 1)
   git::https://github.com/udjin10/yandex_compute_instance.git?ref=main
SyntaxError: invalid syntax (<unknown>, line 1)
   git::https://github.com/udjin10/yandex_compute_instance.git?ref=main
SyntaxError: invalid syntax (<unknown>, line 1)
   ${yandex_vpc_subnet.develop_a.id}
SyntaxError: invalid syntax (<unknown>, line 1)
   ${data.template_file.cloudinit.rendered}
SyntaxError: invalid syntax (<unknown>, line 1)
   ${yandex_vpc_network.develop.id}
SyntaxError: invalid syntax (<unknown>, line 1)
   10.0.1.0/24
SyntaxError: invalid syntax (<unknown>, line 1)
   10.0.1.0/24
SyntaxError: invalid syntax (<unknown>, line 1)
   ${yandex_vpc_network.develop.id}
SyntaxError: invalid syntax (<unknown>, line 1)
   10.0.2.0/24
SyntaxError: invalid syntax (<unknown>, line 1)
   10.0.2.0/24
SyntaxError: invalid syntax (<unknown>, line 1)
   ${file("~/.authorized_key.json")}
SyntaxError: invalid syntax (<unknown>, line 1)
   "${file("~/.authorized_key.json")}"
SyntaxError: invalid syntax (<unknown>, line 1)
   "file("~/.authorized_key.json")"
SyntaxError: invalid syntax (<unknown>, line 1)
   ${concat(module.test-vm.fqdn,module.example-vm.fqdn)}
SyntaxError: invalid syntax (<unknown>, line 1)
   ${string}
SyntaxError: invalid syntax (<unknown>, line 1)

       _               _
   ___| |__   ___  ___| | _______   __
  / __| '_ \ / _ \/ __| |/ / _ \ \ / /
 | (__| | | |  __/ (__|   < (_) \ V /
  \___|_| |_|\___|\___|_|\_\___/ \_/

By Prisma Cloud | version: 3.2.426 

terraform scan results:

Passed checks: 0, Failed checks: 4, Skipped checks: 0

Check: CKV_TF_1: "Ensure Terraform module sources use a commit hash"
	FAILED for resource: test-vm
	File: /vms/main.tf:22-43

		22 | module "test-vm" {
		23 |   source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
		24 |   env_name       = "develop" 
		25 |   network_id     = yandex_vpc_network.develop.id
		26 |   subnet_zones   = ["ru-central1-a","ru-central1-b"]
		27 |   subnet_ids     = [yandex_vpc_subnet.develop_a.id,yandex_vpc_subnet.develop_b.id]
		28 |   instance_name  = "webs"
		29 |   instance_count = 2
		30 |   image_family   = "ubuntu-2004-lts"
		31 |   public_ip      = true
		32 | 
		33 |   labels = { 
		34 |     owner= "i.ivanov",
		35 |     project = "accounting"
		36 |      }
		37 | 
		38 |   metadata = {
		39 |     user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
		40 |     serial-port-enable = 1
		41 |   }
		42 | 
		43 | }

Check: CKV_TF_2: "Ensure Terraform module sources use a tag with a version number"
	FAILED for resource: test-vm
	File: /vms/main.tf:22-43

		22 | module "test-vm" {
		23 |   source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
		24 |   env_name       = "develop" 
		25 |   network_id     = yandex_vpc_network.develop.id
		26 |   subnet_zones   = ["ru-central1-a","ru-central1-b"]
		27 |   subnet_ids     = [yandex_vpc_subnet.develop_a.id,yandex_vpc_subnet.develop_b.id]
		28 |   instance_name  = "webs"
		29 |   instance_count = 2
		30 |   image_family   = "ubuntu-2004-lts"
		31 |   public_ip      = true
		32 | 
		33 |   labels = { 
		34 |     owner= "i.ivanov",
		35 |     project = "accounting"
		36 |      }
		37 | 
		38 |   metadata = {
		39 |     user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
		40 |     serial-port-enable = 1
		41 |   }
		42 | 
		43 | }

Check: CKV_TF_1: "Ensure Terraform module sources use a commit hash"
	FAILED for resource: example-vm
	File: /vms/main.tf:45-61

		45 | module "example-vm" {
		46 |   source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
		47 |   env_name       = "stage"
		48 |   network_id     = yandex_vpc_network.develop.id
		49 |   subnet_zones   = ["ru-central1-a"]
		50 |   subnet_ids     = [yandex_vpc_subnet.develop_a.id]
		51 |   instance_name  = "web-stage"
		52 |   instance_count = 1
		53 |   image_family   = "ubuntu-2004-lts"
		54 |   public_ip      = true
		55 | 
		56 |   metadata = {
		57 |     user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
		58 |     serial-port-enable = 1
		59 |   }
		60 | 
		61 | }

Check: CKV_TF_2: "Ensure Terraform module sources use a tag with a version number"
	FAILED for resource: example-vm
	File: /vms/main.tf:45-61

		45 | module "example-vm" {
		46 |   source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
		47 |   env_name       = "stage"
		48 |   network_id     = yandex_vpc_network.develop.id
		49 |   subnet_zones   = ["ru-central1-a"]
		50 |   subnet_ids     = [yandex_vpc_subnet.develop_a.id]
		51 |   instance_name  = "web-stage"
		52 |   instance_count = 1
		53 |   image_family   = "ubuntu-2004-lts"
		54 |   public_ip      = true
		55 | 
		56 |   metadata = {
		57 |     user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
		58 |     serial-port-enable = 1
		59 |   }
		60 | 
		61 | }


