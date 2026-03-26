# TeamSpeak Terraform Deployment

A robust, fully automated Infrastructure-as-Code (IaC) solution for deploying a hardened TeamSpeak 6 server on UpCloud, utilizing Cloudflare for DNS management.

## Architecture & Features

- **UpCloud Infrastructure**: Automatically provisions an Ubuntu 24.04 server and an attached block storage volume for persistent, safe data storage.
- **Dockerized Environment**: Runs the official `teamspeak6-server`, `mariadb` (for robust backend data handling), and `watchtower` using Docker Compose.
- **Hardware & Network Security**:
  - Restricts access via an UpCloud firewall (allowing only SSH, default TS UDP, file transfer, and Server Query).
  - Deploys as a dedicated non-root `teamspeak` user initialized securely using `cloud-init`.
- **Automated Maintenance**: Integrates Watchtower to automatically check and update Docker images on a weekly schedule.
- **Automated DNS**: Dynamically registers your server's public IP to an un-proxied Cloudflare A-record for easy access.
- **CI/CD Pipeline**: Provides a complete GitHub Actions workflow (`deploy.yaml`) to continuously apply configuration changes to production on merge.

## Prerequisites

Before deploying, ensure you have:

- Terraform `>= 1.5.0` installed.
- An [UpCloud](https://upcloud.com/) account and API credentials.
- A [Cloudflare](https://www.cloudflare.com/) account, a domain zone, and API token.
- Designed SSH keys for secure access.

## Configuration Variables

You must supply several variables for the deployment to succeed. Creating a `terraform.tfvars` file or passing environment variables (`TF_VAR_...`) is recommended.

### UpCloud

- `upcloud_username` & `upcloud_password`: API credentials.
- `server_zone`: UpCloud location (default: `fi-hel1`).
- `server_plan`: Instance plan (default: `DEV-1xCPU-1GB-10GB`).
- `ssh_public_key`: Your SSH public key for secure access.

### Cloudflare

- `cloudflare_api_token`: API token with DNS edit permissions.
- `cloudflare_zone_id`: The ID of your Cloudflare zone (domain).
- `subdomain`: Target subdomain (default: `ts`).

### TeamSpeak & Database

- `query_admin_password`: TeamSpeak Server Admin password for query interfaces.
- `mysql_root_password`: Root password for MariaDB.
- `mysql_password`: Password for the dedicated `teamspeak` database user.
- `timezone`: Server timezone for correct logging and update schedules (default: `Europe/Helsinki`).

## Usage

1. **Clone the repository:**

   ```bash
   git clone <repository_url>
   cd teamspeak-terraform
   ```

2. **Initialize Terraform:**

   ```bash
   terraform init
   ```

3. **Deploy the infrastructure:**

   ```bash
   terraform apply
   ```

   > You will be prompted for required sensitive variables if not supplied via `.tfvars` or environment variables.

4. **Connect to TeamSpeak:**
   Open the TeamSpeak client and connect to `ts.yourdomain.com` (or the subdomain you defined).

## Automated Deployment (GitHub Actions)

A GitHub Actions pipeline is included and will run `terraform apply` automatically when pushing to `main`. To use it, configure the following **Secrets** in your GitHub repository:

- `UPCLOUD_USERNAME`
- `UPCLOUD_PASSWORD`
- `CLOUDFLARE_API_TOKEN`
- `CLOUDFLARE_ZONE_ID`
- `SSH_PUBLIC_KEY`
- `QUERY_ADMIN_PASSWORD`
- `MYSQL_ROOT_PASSWORD`
- `MYSQL_PASSWORD`
