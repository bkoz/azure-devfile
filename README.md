# Azure CLI Workspace for OpenShift Dev Spaces

This devfile creates an OpenShift Dev Spaces workspace with Azure CLI tools pre-installed.

Debugging

## Features

- **Base Image**: Red Hat Universal Developer Image (UDI) RHEL 8
- **Azure CLI**: Installed automatically on workspace startup
- **Memory**: 2Gi limit, 1Gi request
- **CPU**: 1000m limit, 500m request
- **Persistent Config**: Azure configuration stored in `/projects/.azure`

## Installation Dependencies

The workspace automatically installs these dependencies based on [Microsoft's Azure CLI Linux installation guide](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux):

- `ca-certificates`
- `curl`
- `gnupg`
- `lsb-release` / `redhat-lsb-core`
- `apt-transport-https` (for Debian/Ubuntu-based images)

## Usage

### 1. Create Workspace in OpenShift Dev Spaces

**Option A: From URL**
```bash
https://<your-devspaces-url>#https://github.com/<your-repo>/devfile.yaml
```

**Option B: From Dashboard**
1. Open OpenShift Dev Spaces dashboard
2. Click "Create Workspace"
3. Import from Git and point to this repository
4. The devfile will be automatically detected

### 2. Available Commands

Once the workspace starts, you can run these commands from the command palette:

| Command | Description |
|---------|-------------|
| **Install Azure CLI** | Manually install/reinstall Azure CLI |
| **Verify Azure CLI** | Check Azure CLI version |
| **Azure Login (Interactive)** | Login with browser authentication |
| **Azure Login (Device Code)** | Login with device code (recommended for containers) |
| **List Azure Subscriptions** | Show available subscriptions |
| **Azure CLI Help** | Display Azure CLI help |

### 3. Login to Azure

The workspace supports two authentication methods:

**Device Code Login (Recommended for Dev Spaces):**
```bash
az login --use-device-code
```

**Interactive Browser Login:**
```bash
az login
```

### 4. Common Azure CLI Commands

```bash
# List subscriptions
az account list --output table

# Set active subscription
az account set --subscription "<subscription-id>"

# List resource groups
az group list --output table

# List VMs
az vm list --output table

# Get Azure CLI help
az --help
```

## Configuration

### Azure Configuration Location
Azure CLI configuration is stored in `/projects/.azure` to ensure it persists across workspace restarts.

### Memory and CPU Adjustments
Edit the devfile to adjust resource limits:

```yaml
components:
  - name: azure-tools
    container:
      memoryLimit: 4Gi     # Increase if needed
      memoryRequest: 2Gi
      cpuLimit: 2000m
      cpuRequest: 1000m
```

## Customization

### Add Additional Tools
Add more commands to install tools like Terraform, Ansible, or PowerShell:

```yaml
commands:
  - id: install-terraform
    exec:
      component: azure-tools
      commandLine: |
        wget https://releases.hashicorp.com/terraform/1.5.0/terraform_1.5.0_linux_amd64.zip
        unzip terraform_1.5.0_linux_amd64.zip
        sudo mv terraform /usr/local/bin/
      label: Install Terraform
```

### Use a Custom Container Image
Replace the base image with your own pre-built image:

```yaml
components:
  - name: azure-tools
    container:
      image: quay.io/your-org/azure-devspaces:latest
```

## Troubleshooting

### Azure CLI Not Found
Run the install command manually:
```bash
curl -sL https://aka.ms/InstallAzureCli | bash
```

### Permission Issues
Some operations may require sudo. The UDI image includes sudo access by default.

### Authentication Fails
Use device code authentication for better compatibility with container environments:
```bash
az login --use-device-code
```

## Resources

- [Azure CLI Documentation](https://learn.microsoft.com/en-us/cli/azure/)
- [Azure CLI Linux Installation](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux)
- [OpenShift Dev Spaces Documentation](https://docs.redhat.com/en/documentation/red_hat_openshift_dev_spaces/)
- [Devfile Schema Reference](https://devfile.io/)
- [GitHub Azure CLI Prerequisites](https://github.com/Azure/azure-cli/blob/dev/doc/install_linux_prerequisites.md)

## License

This devfile configuration is provided as-is for use with OpenShift Dev Spaces.
