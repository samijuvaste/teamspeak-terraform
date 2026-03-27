resource "upcloud_server" "teamspeak" {
  hostname = "teamspeak-server"
  zone     = var.server_zone
  plan     = var.server_plan
  metadata = true
  firewall = true
  timezone = var.timezone

  template {
    storage = "Ubuntu Server 24.04 LTS (Noble Numbat)"
    size    = var.server_size
    encrypt = true
  }

  network_interface {
    type = "public"
  }

  network_interface {
    type = "utility"
  }

  login {
    password_delivery = "none"
  }

  # Render the cloud-init file, passing in the rendered docker-compose file
  user_data = templatefile("${path.module}/cloud-init.yaml", {
    SSH_PUBLIC_KEY = var.ssh_public_key,
    docker_compose_content = templatefile("${path.module}/docker-compose.yaml", {
      QUERY_ADMIN_PASSWORD = var.query_admin_password
      MYSQL_ROOT_PASSWORD  = var.mysql_root_password
      MYSQL_PASSWORD       = var.mysql_password
      TIMEZONE             = var.timezone
    })
  })

  storage_devices {
    address          = "virtio"
    address_position = 1
    storage          = upcloud_storage.teamspeak_data.id
  }

  simple_backup {
    plan = "daily"
    time = "0200"
  }
}

resource "upcloud_storage" "teamspeak_data" {
  size    = var.teamspeak_data_size
  tier    = var.teamspeak_data_tier
  title   = "teamspeak-data"
  zone    = var.server_zone
  encrypt = true
}

# --- Firewall Rules ---
resource "upcloud_firewall_rules" "ts_fw" {
  server_id = upcloud_server.teamspeak.id

 # --- Inbound Rules ---

  firewall_rule {
    action                 = "accept"
    direction              = "in"
    family                 = "IPv4"
    protocol               = "tcp"
    destination_port_start = "22"
    destination_port_end   = "22"
  }

  firewall_rule {
    action                 = "accept"
    direction              = "in"
    family                 = "IPv4"
    protocol               = "udp"
    destination_port_start = "9987"
    destination_port_end   = "9987"
  }

  firewall_rule {
    action                 = "accept"
    direction              = "in"
    family                 = "IPv4"
    protocol               = "tcp"
    destination_port_start = "30033"
    destination_port_end   = "30033"
  }

  firewall_rule {
    action                 = "accept"
    direction              = "in"
    family                 = "IPv4"
    protocol               = "tcp"
    destination_port_start = "10022"
    destination_port_end   = "10022"
  }

  firewall_rule {
    action    = "drop"
    direction = "in"
  }

  # --- Outbound Rules ---

  # DNS
  firewall_rule {
    action                 = "accept"
    direction              = "out"
    family                 = "IPv4"
    protocol               = "udp"
    destination_port_start = "53"
    destination_port_end   = "53"
  }

  firewall_rule {
    action                 = "accept"
    direction              = "out"
    family                 = "IPv4"
    protocol               = "tcp"
    destination_port_start = "53"
    destination_port_end   = "53"
  }

  # HTTP (OS Updates/APT/keys)
  firewall_rule {
    action                 = "accept"
    direction              = "out"
    family                 = "IPv4"
    protocol               = "tcp"
    destination_port_start = "80"
    destination_port_end   = "80"
  }

  # HTTPS
  firewall_rule {
    action                 = "accept"
    direction              = "out"
    family                 = "IPv4"
    protocol               = "tcp"
    destination_port_start = "443"
    destination_port_end   = "443"
  }

  # NTP
  firewall_rule {
    action                 = "accept"
    direction              = "out"
    family                 = "IPv4"
    protocol               = "udp"
    destination_port_start = "123"
    destination_port_end   = "123"
  }

  # TeamSpeak Accounting
  firewall_rule {
    action                 = "accept"
    direction              = "out"
    family                 = "IPv4"
    protocol               = "tcp"
    destination_port_start = "2008"
    destination_port_end   = "2008"
  }

  # ICMP
  firewall_rule {
    action    = "accept"
    direction = "out"
    family    = "IPv4"
    protocol  = "icmp"
  }

  # Drop all other outbound traffic
  firewall_rule {
    action    = "drop"
    direction = "out"
  }
}

# --- Cloudflare DNS ---
resource "cloudflare_dns_record" "ts_dns" {
  zone_id = var.cloudflare_zone_id
  name    = var.subdomain
  # The first network interface [0] is the public interface
  content = upcloud_server.teamspeak.network_interface[0].ip_address
  type    = "A"
  ttl     = 1

  # CRITICAL: Proxy MUST be false because Cloudflare's free tier proxy doesn't support UDP. 
  # If this is true, nobody will be able to connect to the server.
  proxied = false
}
