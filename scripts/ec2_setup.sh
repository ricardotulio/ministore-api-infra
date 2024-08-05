#!/bin/bash
# Update the package index
sudo yum update -y

# Install Amazon Corretto 17
sudo yum install -y java-17-amazon-corretto

# Install Ruby (CodeDeploy dependency)
sudo yum install -y ruby

# Install wget 
sudo yum install -y wget

# Download latest CodeDeploy version
wget https://aws-codedeploy-us-east-2.s3.us-east-2.amazonaws.com/latest/install

# Add permission to execute into installation file
chmod +x ./install

# Install the CodeDeploy agent
sudo ./install auto

# Check if the CodeDeploy agent is running
if systemctl is-active --quiet codedeploy-agent; then
    sudo echo "CodeDeploy agent is already running."
else
    echo "CodeDeploy agent is not running. Starting the CodeDeploy agent..."
    sudo systemctl start codedeploy-agent
    sudo systemctl enable codedeploy-agent
fi