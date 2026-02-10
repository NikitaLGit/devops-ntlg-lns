resource "yandex_storage_bucket" "leonovbucket" {
  access_key    = var.bucket_access_key
  secret_key    = var.bucket_secret_key
  acl           = "public-read"
  bucket        = "leonovbucket"
  force_destroy = "true"
  website {
    index_document = "index.html"
  }
}

resource "yandex_storage_object" "image-object" {
  access_key = var.bucket_access_key
  secret_key = var.bucket_secret_key
  acl        = "public-read"
  bucket     = "leonovbucket"
  key        = "york.jpg"
  source     = "./files/york.jpg"
  depends_on = [
    yandex_storage_bucket.leonovbucket,
  ]
}


