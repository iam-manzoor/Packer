#!/bin/bash

echo "Setting up the web server..."
sudo apt update
sudo apt install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx