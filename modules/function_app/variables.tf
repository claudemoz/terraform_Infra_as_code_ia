variable "project" { type = string }
variable "env" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "tags" { type = map(string) }
variable "vision_endpoint" {}
variable "vision_key" {}
variable "storage_account_access_key" {}
variable "storage_account_name" {}