DOMAIN="$1"
HOSTS_FILE="/etc/hosts"
PUBLIC_IP=$(curl -s ifconfig.me)

if [ -z "$DOMAIN" ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

# Check if the domain exists in /etc/hosts
if grep -q "\s$DOMAIN$" "$HOSTS_FILE"; then
    echo "Updating existing entry for $DOMAIN with IP $PUBLIC_IP"
    sudo sed -i "s/^[0-9.]\+\s\+$DOMAIN\$/$PUBLIC_IP $DOMAIN/" "$HOSTS_FILE"
else
    echo "Adding new entry: $PUBLIC_IP $DOMAIN"
    echo "$PUBLIC_IP $DOMAIN" | sudo tee -a "$HOSTS_FILE"
fi

echo "Done!"
