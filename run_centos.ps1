# Variables
$imageName = "persistent_centos"
$containerName = "my_centos_container"
$volumeName = "centos_data"

# Check if Docker is installed
if (-not (Get-Command "docker" -ErrorAction SilentlyContinue)) {
    Write-Host "Docker is not installed. Please install Docker first." -ForegroundColor Red
    exit 1
}

# Build the Docker image
Write-Host "Building the Docker image..."
docker build -t $imageName . | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to build the Docker image." -ForegroundColor Red
    exit 1
}

# Create a Docker volume for persistent data if it doesn't already exist
if (-not (docker volume ls | Select-String $volumeName)) {
    Write-Host "Creating a Docker volume for persistent data..."
    docker volume create $volumeName | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to create the volume." -ForegroundColor Red
        exit 1
    }
}

# Run the Docker container
Write-Host "Starting the Docker container..."
docker run -dit --name $containerName -v ${volumeName}:/data $imageName | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to start the container." -ForegroundColor Red
    exit 1
}

# Success message
Write-Host "Container '$containerName' started successfully with persistent data stored in volume '$volumeName'." -ForegroundColor Green
Write-Host "To access the container, use: docker exec -it $containerName /bin/bash"
