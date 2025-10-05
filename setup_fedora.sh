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

# Install kubectl
echo "Installing kubectl..."
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl-cni
EOF
sudo dnf install -y kubectl

# Install Minikube
echo "Installing Minikube..."
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64

# Start Minikube
echo "Starting Minikube cluster..."
minikube start --driver=podman

# Install ArgoCD on Minikube
echo "Installing ArgoCD on Minikube..."
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Install ArgoCD CLI
echo "Installing ArgoCD CLI..."
# Source: https://argo-cd.readthedocs.io/en/stable/cli_installation/
LATEST_VERSION=$(curl -s https://api.github.com/repos/argoproj/argo-cd/releases/latest | grep '"tag_name"' | sed -e 's/.*"v\([^"]*\)".*/\1/')
curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v$LATEST_VERSION/argocd-linux-amd64
chmod +x /usr/local/bin/argocd


echo "Setup complete. All tools are installed."