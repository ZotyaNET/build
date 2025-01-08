#!/bin/bash

# Array of URLs to download
urls=(
    "https://www.zoho.com/salesiq/desktop/linux/SalesIQ_2.0.9_amd64.deb"
    "https://downloads.zohocdn.com/notebooklinux-desktop/Notebook-3.2.0.deb"
    "https://d1ctjwn89mb7yf.cloudfront.net/agent/4.1.0/ZohoMeeting-x64.AppImage"
    "https://downloads.zohocdn.com/chat-desktop/linux/cliq_1.7.4_amd64.deb"
    "https://downloads.zohocdn.com/assist-desktop/zoho-assist-desktop-x64.AppImage"
    "https://files-accl.zohopublic.com/public/zohowriter/download/linux"
)

# Directory to save the downloaded files
download_dir="./zoho"

# Create the directory if it doesn't exist
mkdir -p "$download_dir"

# Loop through the URLs and download each file
for url in "${urls[@]}"; do
    wget -P "$download_dir" "$url"
done

mv "$download_dir/linux" ZohoWriter.deb

sudo dpkg -i ./zoho/*.deb
chmod +x /zoho/ZohoMeeting-x64.AppImage
chmod +x /zoho/zoho-assist-desktop-x64.AppImage
