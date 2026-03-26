variable "cloudflare_api_token" {
  type        = string
  description = "Cloudflare API Token"
  sensitive   = true
}

variable "cloudflare_zone_id" {
  type        = string
  description = "The Zone ID for your domain in Cloudflare"
}

variable "subdomain" {
  type        = string
  default     = "ts"
  description = "The subdomain to point to the server"
}
