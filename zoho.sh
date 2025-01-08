#!/bin/bash

# Array of URLs to download
urls=(
    "https://www.zoho.com/salesiq/desktop/linux/SalesIQ_2.0.9_amd64.deb"
    "https://downloads.zohocdn.com/notebooklinux-desktop/Notebook-3.2.0.deb"
    "https://d1ctjwn89mb7yf.cloudfront.net/agent/4.1.0/ZohoMeeting-x64.AppImage"
)

# Directory to save the downloaded files
download_dir="./zoho"

# Create the directory if it doesn't exist
mkdir -p "$download_dir"

# Loop through the URLs and download each file
for url in "${urls[@]}"; do
    wget -P "$download_dir" "$url"
done
