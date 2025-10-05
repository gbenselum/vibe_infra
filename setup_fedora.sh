#!/bin/bash
# Script to set up a new Fedora server for GitOps

# Exit immediately if a command exits with a non-zero status.
set -e

echo "Starting Fedora setup for GitOps..."

# Update the system
echo "Updating system packages..."
sudo dnf -y update

# Install Git
echo "Installing Git..."
sudo dnf -y install git

# Install Podman
echo "Installing Podman..."
sudo dnf -y install podman

# Install Terraform
echo "Installing Terraform..."
sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
sudo dnf -y install terraform

# Install Ansible
echo "Installing Ansible..."
sudo dnf -y install ansible

# Install ArgoCD CLI
echo "Installing ArgoCD CLI..."
# Source: https://argo-cd.readthedocs.io/en/stable/cli_installation/
LATEST_VERSION=$(curl -s https://api.github.com/repos/argoproj/argo-cd/releases/latest | grep '"tag_name"' | sed -e 's/.*"v\([^"]*\)".*/\1/')
curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v$LATEST_VERSION/argocd-linux-amd64
chmod +x /usr/local/bin/argocd


echo "Setup complete. All tools are installed."