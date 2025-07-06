variable "resource_group" {
  type    = string
  default = "billing-archive-rg"
}

variable "location" {
  type    = string
  default = "East US"
}

variable "cosmos_account_name" {
  type    = string
  default = "billingcosmos"
}

variable "storage_account_name" {
  type    = string
  default = "billingarchivestorage"
}

variable "function_app_name" {
  type    = string
  default = "billing-archiver-fn"
}
