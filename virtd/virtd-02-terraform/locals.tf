locals {
    provider_name = "${var.naming["web"].who}-${var.naming["web"].name}"
    database_name = "${var.naming["db"].who}-${var.naming["db"].name}"
}