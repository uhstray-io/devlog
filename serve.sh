#!/bin/bash

# https://static-web-server.net/configuration/command-line-arguments/

# Detect IP address for Linux and Windows

# Linux
if [[ "$(uname -s)" == "Linux" ]]; then
	IP_ADDRESS=$(hostname -I | awk '{print $1}')

# Windows (Git Bash, Cygwin, MSYS)
elif [[ "$(uname -s)" == "MINGW"* || "$(uname -s)" == "CYGWIN"* || "$(uname -s)" == "MSYS"* ]]; then
	IP_ADDRESS=$(ipconfig | grep -E "IPv4" | grep -v "127.0.0.1" | awk -F: '{print $2}' | awk '{print $1}' | grep '^192.168' | head -n 1)
    # Fallback to localhost if no suitable IP found
	if [ -z "$IP_ADDRESS" ]; then
		IP_ADDRESS="127.0.0.1"
	fi
else
	IP_ADDRESS="127.0.0.1"
fi



if [[ "$(uname -s)" == "Linux" ]]; then
    static-web-server --host "$IP_ADDRESS" --port 8000 -d ./public --log-level info --log-with-ansi true --log-remote-address true
else
    # Assume Windows and use local static-web-server.exe
    ./static-web-server.exe --host "$IP_ADDRESS" --port 8000 -d ./public --log-level info --log-with-ansi true --log-remote-address true
fi
