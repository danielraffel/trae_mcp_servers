#!/bin/bash

# Create a temporary file to store URLs
urls_file=$(mktemp)

# Extract all download URLs and save to the temp file
grep -o 'https://api.trae.ai/extensions/api/-/agent/direct-download?[^"]*' trae.txt | sort | uniq > $urls_file

# Download each URL with proper filename
while read url; do
  # Extract agentServerID for the filename
  server_id=$(echo $url | grep -o 'agentServerID=[^&]*' | cut -d= -f2)
  
  # Skip if server_id is empty
  if [ -z "$server_id" ]; then
    echo "Skipping URL with no server ID: $url"
    continue
  fi
  
  echo "Downloading $server_id..."
  curl -L -o "${server_id}.zip" "$url"
  
  # Add a small delay to be nice to the server
  sleep 1
done < $urls_file

# Remove the temporary file
rm $urls_file

echo "All downloads complete!"