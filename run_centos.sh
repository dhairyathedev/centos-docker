#!/bin/bash

# Variables
IMAGE_NAME="persistent_centos"
CONTAINER_NAME="my_centos_container"
VOLUME_NAME="centos_data"

# Check if Docker is installed
if ! command -v docker &>/dev/null; then
    echo "Docker is not installed. Please install Docker first."
    exit 1
fi

# Build the Docker image
echo "Building the Docker image..."
docker build -t $IMAGE_NAME . || { echo "Failed to build the Docker image"; exit 1; }

# Create a Docker volume for persistent data if not already exists
if ! docker volume ls | grep -q $VOLUME_NAME; then
    echo "Creating a Docker volume for persistent data..."
    docker volume create $VOLUME_NAME || { echo "Failed to create the volume"; exit 1; }
fi

# Run the Docker container
echo "Starting the Docker container..."
docker run -dit --name $CONTAINER_NAME -v $VOLUME_NAME:/data $IMAGE_NAME || {
    echo "Failed to start the container";
    exit 1;
}

# Display success message
echo "Container '$CONTAINER_NAME' started successfully with persistent data stored in volume '$VOLUME_NAME'."
echo "To access the container, use: docker exec -it $CONTAINER_NAME /bin/bash"

