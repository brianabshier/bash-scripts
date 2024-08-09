#!/bin/bash

# Replace the variables with the proper ones for your Rackspace Cloud account.
# Note: The Agent_ID matches your server's UUID. Adjust the THRESHOLD as needed.
# Configure this script to run with a cron.

# Variables
USERNAME="$USERNAME"
API_KEY="$API_KEY"
TENANT_ID="$ACCOUNT_NUMBER"
AGENT_ID="$SERVER_UUID"
THRESHOLD=80
SERVICE="$SERVICENAME"
TOKEN_CACHE_FILE="/tmp/rackspace_token_cache.txt"
TOKEN_EXPIRY_TIME=86400  # Token expiry time in seconds (usually 24 hours)

# Function to retrieve a new API token
get_new_api_token() {
  AUTH_RESPONSE=$(curl -s -X POST -H "Content-Type: application/json" \
  -d '{
        "auth": {
          "RAX-KSKEY:apiKeyCredentials": {
            "username": "'"$USERNAME"'",
            "apiKey": "'"$API_KEY"'"
          }
        }
      }' \
  "https://identity.api.rackspacecloud.com/v2.0/tokens")

  API_TOKEN=$(echo $AUTH_RESPONSE | jq -r '.access.token.id')
  TOKEN_EXPIRES=$(date +%s -d "$(echo $AUTH_RESPONSE | jq -r '.access.token.expires')")
  echo $API_TOKEN > $TOKEN_CACHE_FILE
  echo $TOKEN_EXPIRES >> $TOKEN_CACHE_FILE
}

# Function to check if the cached token is still valid
is_token_valid() {
  if [ -f "$TOKEN_CACHE_FILE" ]; then
    CACHED_TOKEN=$(head -n 1 $TOKEN_CACHE_FILE)
    CACHED_TOKEN_EXPIRY=$(tail -n 1 $TOKEN_CACHE_FILE)
    CURRENT_TIME=$(date +%s)

    if [ "$CURRENT_TIME" -lt "$CACHED_TOKEN_EXPIRY" ]; then
      API_TOKEN=$CACHED_TOKEN
      return 0
    else
      return 1
    fi
  else
    return 1
  fi
}

# Check if a valid token is already cached, if not, retrieve a new one
if ! is_token_valid; then
  get_new_api_token
fi

# Get Memory Information
MEMORY_INFO=$(curl -s -X GET -H "X-Auth-Token: $API_TOKEN" \
-H "Content-Type: application/json" \
"https://monitoring.api.rackspacecloud.com/v1.0/$TENANT_ID/agents/$AGENT_ID/host_info/memory")

# Extract the 'used_percent' value
USED_PERCENT=$(echo $MEMORY_INFO | jq '.info.used_percent')

# Check if 'used_percent' exceeds the threshold
if (( $(echo "$USED_PERCENT > $THRESHOLD" | bc -l) )); then
  echo "Memory usage is at ${USED_PERCENT}% - Restarting ${SERVICE} service"
  # Restart the service
  systemctl restart $SERVICE
else
  echo "Memory usage is at ${USED_PERCENT}% - No action needed"
fi
