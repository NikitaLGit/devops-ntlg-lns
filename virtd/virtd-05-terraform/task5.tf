variable "lowercase_string" {
  type = string
  default = "default string"

  validation {
    condition = lower(var.lowercase_string) == var.lowercase_string
    error_message = "String must be only lowercase!"
  }
}

variable "onlyonebool" {
  type = object({
    bool_a = bool
    bool_b = bool 
  })
  default = {
    bool_a = false
    bool_b = false
  }

  validation {
    condition = (
        (var.onlyonebool.bool_a && !var.onlyonebool.bool_b) ||
        (!var.onlyonebool.bool_a && var.onlyonebool.bool_b)
    )
    error_message = "must be only one true and one false"
  }
}