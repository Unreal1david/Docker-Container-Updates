#!/bin/bash

# Check for updates for all containers
echo "Checking for updates for all containers..."
docker-compose pull

# Get a list of all containers
containers=$(docker-compose ps -q)

# Loop through the list of containers and update them if necessary
for container in $containers
do
  # Check if the container has an update available
  update_available=$(docker-compose ps -q | xargs docker inspect --format '{{ .Id }}: {{ .UpdateStatus.State }}' | grep $container | grep 'update_available')

  if [ ! -z "$update_available" ]; then
    # Update the container
    echo "Updating container $container..."
    docker-compose up -d $container
  fi
done
