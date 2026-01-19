#!/bin/bash

set -e

# Download static-web-server
# Github https://github.com/static-web-server/static-web-server
# https://static-web-server.net/download-and-install/


if ! command -v curl &> /dev/null; then
    echo "curl could not be found. Please install curl first."
    exit 1
fi

curl --proto '=https' --tlsv1.2 -sSfL https://get.static-web-server.net | sh
