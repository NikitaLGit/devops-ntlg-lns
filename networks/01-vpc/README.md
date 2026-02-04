## Задание 1

Создаю сеть vpchome1

```terraform
resource "yandex_vpc_network" "vpcnetwork" {
  name = var.vpc_name
}

variable "vpc_name" {
  type        = string
  default     = "vpchome1"
  description = "env_name_parameter"
}
```

Создаю в VPC публичную подсеть с названием public, сетью 192.168.10.0/24:

```terraform
resource "yandex_vpc_subnet" "public" {
  name           = var.default_public.name
  zone           = var.default_public.zone
  network_id     = yandex_vpc_network.vpcnetwork.id
  v4_cidr_blocks = [var.default_public.cidr]
}

variable "default_public" {
  type = map
  default = {
    name = "public-ru-central1-b"
    zone = "ru-central1-b"
    cidr = "192.168.10.0/24"
  }
}
```

Nat instance:
```terraform
resource "yandex_compute_instance" "nat" {
  name        = "nat-instance"
  platform_id = "standard-v1"
  zone        = var.default_public.zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    ip_address = "192.168.10.254"
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
```

Создаю в публичной подсети виртуальную машину с публичным IP:

```terraform
resource "yandex_compute_instance" "public_vm" {
  name        = "public-vm"
  platform_id = "standard-v1"
  zone        = var.default_public.zone
  hostname    = "public"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8pbf0hl06ks8s3scqk"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
```

Подключимся к вм и проверим:
<img width="800" height="263" alt="image" src="https://github.com/user-attachments/assets/942bf383-c7df-4df4-ad66-76548dc9c3e2" />

Создаю в VPC приватную подсеть с названием private, сетью 192.168.20.0/24:

```terraform
resource "yandex_vpc_subnet" "private" {
  name           = var.default_private.name
  zone           = var.default_private.zone
  network_id     = yandex_vpc_network.vpcnetwork.id
  v4_cidr_blocks = [var.default_private.cidr]

  route_table_id = yandex_vpc_route_table.private_rt.id
}
```

и правило роутинга

```terraform
resource "yandex_vpc_route_table" "private_rt" {
  network_id = yandex_vpc_network.vpcnetwork.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "192.168.10.254"
  }
}
```

По итогу получим:

<img width="1657" height="521" alt="image" src="https://github.com/user-attachments/assets/38f64817-879b-44d3-92d1-afdab4a1448a" />

<img width="1792" height="147" alt="image" src="https://github.com/user-attachments/assets/5bd811f8-ca3b-4d03-9014-b408572ef0d2" />

зайдем через proxyssh на private vm

```bash
ssh -J ubuntu@178.154.196.197 ubuntu@192.168.20.9
```

Проверим доступность сети с этой вм

<img width="580" height="179" alt="image" src="https://github.com/user-attachments/assets/d4160e1a-7002-4447-b090-47fd16a60abc" />
