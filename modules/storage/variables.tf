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

variable "container_name" {
  type    = string
  default = "data"
}

variable "tags" {
  type = map(string)
}