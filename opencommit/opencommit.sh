#!/bin/bash

if ! command -v node >/dev/null 2>&1; then
    echo "node is not installed. Please install node."
    exit 1
fi

if ! command -v npm >/dev/null 2>&1; then
    echo "npm is not installed. Please install npm."
    exit 1
fi

if ! command -v oco >/dev/null 2>&1; then
    echo "OpenCommit not found, installing..."
    npm install -g opencommit
fi

if ! command -v hcp >/dev/null 2>&1; then
    if [[ "$(uname)" == "Darwin" ]]; then
        echo "HCP not found, installing on macOS..."
        if ! command -v brew >/dev/null 2>&1; then
            echo "Homebrew is not installed. Please install Homebrew."
            exit 1
        fi
        brew tap hashicorp/tap
        brew install hashicorp/tap/hcp
    elif [[ "$(uname)" == "Linux" ]]; then
        echo "HCP not found, installing on Ubuntu..."
        sudo apt-get update &&
            sudo apt-get install wget gpg coreutils -y
        wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
        echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
        sudo apt-get update && sudo apt-get install hcp -y
    else
        echo "Unsupported OS for HCP installation."
        exit 1
    fi
fi

hcp auth login
hcp profile init --vault-secrets

oco config set OCO_AI_PROVIDER=gemini
oco config set OCO_API_KEY=$(hcp vault-secrets secrets open Gemini | awk -F ': ' '/Value/ {print $2}' | xargs)
oco config set OCO_API_URL=
oco config set OCO_MODEL=gemini-2.0-flash
oco config set OCO_ONE_LINE_COMMIT=true
oco config set OCO_WHY=false
oco config set OCO_GITPUSH=false

# TODO: https://github.com/di-sukharev/opencommit?tab=readme-ov-file#switch-to-commitlint
