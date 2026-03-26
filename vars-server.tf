variable "ssh_public_key" {
  type        = string
  description = "Your SSH public key for root access"
}

variable "query_admin_password" {
  type        = string
  description = "TeamSpeak ServerAdmin password for Query interfaces"
  sensitive   = true
}

variable "mysql_root_password" {
  type        = string
  description = "MySQL root password"
  sensitive   = true
}

variable "mysql_password" {
  type        = string
  description = "MySQL password for teamspeak user"
  sensitive   = true
}

variable "timezone" {
  type        = string
  default     = "Europe/Helsinki"
  description = "Timezone for the server"
}
