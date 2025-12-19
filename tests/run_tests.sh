#!/bin/bash
set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}Starting FRP Docker Tests...${NC}"

# Ensure we are in the tests directory
cd "$(dirname "$0")"

# 1. Build Images (if running locally and not in CI with pre-built images)
if [ -z "$CI" ]; then
    echo -e "${GREEN}Building images locally...${NC}"
    # Get version to build
    FRP_VERSION=$(curl -sL https://api.github.com/repos/fatedier/frp/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
    
    docker buildx build --build-arg FRP_VERSION=$FRP_VERSION -t local/frps:test ../frps --load
    docker buildx build --build-arg FRP_VERSION=$FRP_VERSION -t local/frpc:test ../frpc --load
fi

# 2. Start Environment
echo -e "${GREEN}Starting Docker Compose environment...${NC}"
docker compose -f docker-compose.yml up -d

# Function to clean up on exit
cleanup() {
    echo -e "${GREEN}Cleaning up...${NC}"
    docker compose -f docker-compose.yml down
}
trap cleanup EXIT

# 3. Wait for services to be ready
echo -e "${GREEN}Waiting for services to initialize...${NC}"
sleep 10

# 4. Run Tests

# Test 1: STCP Visitor (Port 6000) -> Service App (Port 80)
echo -n "Test 1: STCP Connectivity (Visitor -> Provider)... "
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:6000)

if [ "$HTTP_CODE" == "200" ]; then
    echo -e "${GREEN}PASSED${NC}"
else
    echo -e "${RED}FAILED (HTTP $HTTP_CODE)${NC}"
    docker compose -f docker-compose.yml logs
    exit 1
fi

# Test 2: Check Server Logs for successful start
echo -n "Test 2: Server Health Check... "
if docker compose -f docker-compose.yml logs frps | grep -q "frps started successfully"; then
    echo -e "${GREEN}PASSED${NC}"
else
    echo -e "${RED}FAILED${NC}"
    exit 1
fi

echo -e "${GREEN}All tests passed successfully!${NC}"
