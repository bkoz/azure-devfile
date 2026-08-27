#!/bin/bash

# Build and push custom Azure CLI container image for OpenShift Dev Spaces
# Usage: ./build-image.sh [REGISTRY/IMAGE:TAG]

set -e

# Default image name
DEFAULT_IMAGE="quay.io/your-org/azure-cli-devspaces:latest"
IMAGE_NAME="${1:-$DEFAULT_IMAGE}"

echo "=========================================="
echo "Building Azure CLI Dev Spaces Image"
echo "=========================================="
echo "Image: $IMAGE_NAME"
echo ""

# Check if podman or docker is available
if command -v podman &> /dev/null; then
    BUILD_CMD="podman"
    echo "Using Podman for build"
elif command -v docker &> /dev/null; then
    BUILD_CMD="docker"
    echo "Using Docker for build"
else
    echo "Error: Neither podman nor docker found. Please install one of them."
    exit 1
fi

# Build the image
echo ""
echo "Building image..."
$BUILD_CMD build -t "$IMAGE_NAME" -f Dockerfile .

# Check build status
if [ $? -eq 0 ]; then
    echo ""
    echo "✓ Image built successfully: $IMAGE_NAME"
    echo ""

    # Verify Azure CLI in the image
    echo "Verifying Azure CLI installation..."
    $BUILD_CMD run --rm "$IMAGE_NAME" az --version

    echo ""
    echo "=========================================="
    echo "Build Complete!"
    echo "=========================================="
    echo ""
    echo "Next steps:"
    echo "1. Push the image to your registry:"
    echo "   $BUILD_CMD push $IMAGE_NAME"
    echo ""
    echo "2. Update devfile-prebuilt.yaml to use your image:"
    echo "   image: $IMAGE_NAME"
    echo ""
    echo "3. Create workspace in OpenShift Dev Spaces using devfile-prebuilt.yaml"
    echo ""
else
    echo "Error: Build failed"
    exit 1
fi
