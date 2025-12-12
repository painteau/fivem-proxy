#!/bin/sh
set -e

# Validate required environment variables
: "${REMOTE:?Environment variable REMOTE is required}"
: "${LOCAL_ENDPOINT_IP:?Environment variable LOCAL_ENDPOINT_IP is required}"
: "${LOCAL_ENDPOINT_PORT:?Environment variable LOCAL_ENDPOINT_PORT is required}"

echo "Starting FiveM Proxy..."
echo "Remote server: $REMOTE"
echo "Local endpoint: $LOCAL_ENDPOINT_IP:$LOCAL_ENDPOINT_PORT"

# Process configuration templates
for template in /etc/nginx/conf.d/default.conf /etc/nginx/stream.conf; do
	echo "Processing $template.template..."
	if ! envsubst "$(env | awk -F = '{printf " \\$%s", $1}')" < "$template.template" > "$template"; then
		echo "Error: Failed to process template $template.template"
		exit 1
	fi
done

# Validate nginx configuration
echo "Validating nginx configuration..."
if ! nginx -t; then
	echo "Error: Invalid nginx configuration"
	exit 1
fi

echo "Starting nginx..."
exec nginx -g 'daemon off;'
