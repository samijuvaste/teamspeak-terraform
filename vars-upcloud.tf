variable "upcloud_username" {
  type        = string
  description = "UpCloud API Username"
}

variable "upcloud_password" {
  type        = string
  description = "UpCloud API Password"
  sensitive   = true
}

variable "server_zone" {
  type        = string
  default     = "fi-hel1"
  description = "UpCloud Zone"
}

variable "server_plan" {
  type        = string
  default     = "DEV-1xCPU-1GB-10GB"
  description = "UpCloud pricing plan used for the server"
}

variable "server_size" {
  type        = number
  default     = 10
  description = "UpCloud size of the storage in gigabytes for server drive"
}

variable "teamspeak_data_size" {
  type        = number
  default     = 10
  description = "UpCloud size of the storage in gigabytes for teamspeak data drive"
}

variable "teamspeak_data_tier" {
  type        = string
  default     = "standard"
  description = "UpCloud tier of the storage for teamspeak data drive"
}
