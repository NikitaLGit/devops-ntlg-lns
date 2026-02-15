bucket_name        = "leonov-bucket-15022026"

image_file_path    = "files/york.jpg"
image_url          = "https://storage.yandexcloud.net/leonov-bucket-15022026/york.jpg"

instance_count     = 3

vm_resources = {
  memory = 2
  cores  = 2
  core_fraction = 5
}

mysql_version = "8.0"
mysql_backup_start = "23:59"
