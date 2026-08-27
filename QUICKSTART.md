# Quick Start Guide - Azure CLI in OpenShift Dev Spaces

## Two Deployment Options

### Option 1: Runtime Installation (Faster Setup)
**Use `devfile.yaml`** - Azure CLI installs automatically when workspace starts

**Pros:**
- No image building required
- Start immediately
- Easy to update devfile

**Cons:**
- Slower workspace startup (~2-3 minutes for first start)
- Azure CLI installs every time workspace starts

**How to use:**
1. Push `devfile.yaml` to your Git repository
2. Create workspace in Dev Spaces using your repo URL
3. Wait for Azure CLI to install (automatic on startup)
4. Run: `az login --use-device-code`

---

### Option 2: Pre-built Image (Faster Startup)
**Use `devfile-prebuilt.yaml` + `Dockerfile`** - Azure CLI pre-installed in container

**Pros:**
- Faster workspace startup (Azure CLI already installed)
- Consistent environment
- Better for teams

**Cons:**
- Requires building and hosting container image
- Initial setup more complex

**How to use:**

1. **Build the custom image:**
   ```bash
   ./build-image.sh quay.io/your-org/azure-cli-devspaces:latest
   ```

2. **Push to your registry:**
   ```bash
   podman login quay.io
   podman push quay.io/your-org/azure-cli-devspaces:latest
   ```

3. **Update `devfile-prebuilt.yaml`:**
   ```yaml
   components:
     - name: azure-tools
       container:
         image: quay.io/your-org/azure-cli-devspaces:latest
   ```

4. **Create workspace** in Dev Spaces using `devfile-prebuilt.yaml`

---

## Quick Commands Reference

### Authentication
```bash
# Device code login (recommended for containers)
az login --use-device-code

# Interactive browser login
az login
```

### Basic Operations
```bash
# List subscriptions
az account list --output table

# Set active subscription
az account set --subscription "Subscription Name"

# List resource groups
az group list --output table

# List VMs
az vm list --output table

# Interactive mode (with autocomplete)
az interactive
```

### Configuration
```bash
# Check version
az --version

# Update Azure CLI
az upgrade

# Get help
az --help
az vm --help
```

---

## Which Option Should You Choose?

| Scenario | Recommended Option |
|----------|-------------------|
| Just testing/learning | **Option 1** (devfile.yaml) |
| Personal workspace | **Option 1** (devfile.yaml) |
| Team/shared workspace | **Option 2** (devfile-prebuilt.yaml) |
| Need fast startup | **Option 2** (devfile-prebuilt.yaml) |
| Frequent workspace creation | **Option 2** (devfile-prebuilt.yaml) |
| Don't have image registry | **Option 1** (devfile.yaml) |

---

## Troubleshooting

### Azure CLI command not found
```bash
# For Option 1 - run install command manually
curl -sL https://aka.ms/InstallAzureCli | bash

# For Option 2 - verify image has Azure CLI
az --version
```

### Login fails
```bash
# Use device code instead
az login --use-device-code
```

### Workspace won't start
- Check OpenShift Dev Spaces logs
- Verify image registry is accessible
- Ensure resource limits are sufficient (2Gi memory minimum)

---

## Resources

- [Azure CLI Commands Reference](https://learn.microsoft.com/en-us/cli/azure/reference-index)
- [Azure CLI Installation Guide](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux)
- [OpenShift Dev Spaces Docs](https://docs.redhat.com/en/documentation/red_hat_openshift_dev_spaces/)
- [Devfile Schema](https://devfile.io/)
