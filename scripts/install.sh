#!/usr/bin/env bash

TORCH_VERSION="2.1.2"

echo "Deleting LLaVA Serverless Worker"
rm -rf /workspace/runpod-worker-llava

echo "Deleting venv"
rm -rf /workspace/venv

echo "Cloning LLaVA Serverless Worker repo to /workspace"
cd /workspace
git clone https://github.com/ashleykleynhans/runpod-worker-llava.git
cd runpod-worker-llava

echo "Installing Ubuntu updates"
apt update
apt -y upgrade

echo "Creating and activating venv"
cd /workspace/runpod-worker-llava
python3 -m venv /workspace/venv
source /workspace/venv/bin/activate

echo "Installing Torch"
pip3 install --no-cache-dir torch==${TORCH_VERSION} torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

echo "Installing LLaVA Serverless Worker"
pip3 install -r src/requirements.txt

echo "Downloading models"
cd /workspace/runpod-worker-llava/src
export HUGGINGFACE_HOME="/workspace"
python3 download_models.py

echo "Creating log directory"
mkdir -p /workspace/logs
