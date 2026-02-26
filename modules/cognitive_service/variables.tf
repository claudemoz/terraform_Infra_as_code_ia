variable "project" {
  type = string
}

variable "env" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "sku" {
  type    = string
  default = "S1" # S1 ou S2
}

variable "tags" {
  type = map(string)
}