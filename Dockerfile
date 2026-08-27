# Optional: Pre-built container image with Azure CLI
# This Dockerfile creates a custom image with Azure CLI pre-installed
# to speed up workspace startup time in OpenShift Dev Spaces

FROM registry.redhat.io/devspaces/udi-rhel8:latest

USER root

# Install dependencies for Azure CLI
RUN dnf install -y \
    ca-certificates \
    curl \
    gnupg \
    redhat-lsb-core \
    python3 \
    python3-pip \
    python3-devel \
    gcc \
    libffi-devel \
    openssl-devel \
    git \
    wget \
    unzip \
    && dnf clean all

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCli | bash

# Verify Azure CLI installation
RUN az --version

# Create Azure config directory
RUN mkdir -p /projects/.azure && chmod -R 777 /projects/.azure

# Set environment variables
ENV AZURE_CONFIG_DIR=/projects/.azure
ENV SHELL=/bin/bash

# Switch back to default user (UDI uses user 10001)
USER 10001

# Set working directory
WORKDIR /projects

# Health check (optional)
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD az --version || exit 1

# Default command
CMD ["/bin/bash"]
