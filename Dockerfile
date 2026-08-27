# Pre-built container image with Azure CLI
# This Dockerfile creates a custom image with Azure CLI pre-installed
# to speed up workspace startup time in OpenShift Dev Spaces
# Using Red Hat UBI8 from the public registry (no authentication required)

FROM registry.access.redhat.com/ubi8/ubi:latest

USER root

# Install dependencies for Azure CLI and development tools
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
    sudo \
    bash-completion \
    vim \
    && dnf clean all

# Create a non-root user for development
RUN useradd -u 10001 -m -s /bin/bash user && \
    echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install Azure CLI from Microsoft's RPM repository
RUN echo "Adding Microsoft Azure CLI repository..." && \
    rpm --import https://packages.microsoft.com/keys/microsoft.asc && \
    echo -e "[azure-cli]\nname=Azure CLI\nbaseurl=https://packages.microsoft.com/yumrepos/azure-cli\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo && \
    echo "Installing Azure CLI..." && \
    dnf install -y azure-cli && \
    echo "Verifying Azure CLI installation..." && \
    az --version

# Create Azure config directory and projects directory
RUN mkdir -p /projects/.azure && \
    chown -R 10001:10001 /projects && \
    chmod -R 755 /projects

# Set environment variables
ENV AZURE_CONFIG_DIR=/projects/.azure
ENV SHELL=/bin/bash

# Switch to non-root user for development
USER user

# Set working directory
WORKDIR /projects

# Health check (optional)
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD az --version || exit 1

# Default command
CMD ["/bin/bash"]
