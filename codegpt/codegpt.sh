#!/bin/bash

if ! command -v codegpt >/dev/null 2>&1; then
    echo "CodeGPT not found, installing..."
    bash < <(curl -sSL https://raw.githubusercontent.com/appleboy/CodeGPT/main/install.sh)
    if [[ "$(uname)" == "Darwin" ]]; then
        source $HOME/.zshrc
    elif [[ "$(uname)" == "Linux" ]]; then
        source $HOME/.bashrc
    else
        echo "Unsupported OS for CodeGPT installation."
        exit 1
    fi
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

codegpt config set openai.api_key $(hcp vault-secrets secrets open OpenAI | awk -F ': ' '/Value/ {print $2}' | xargs)
codegpt config set openai.model gpt-4.1
codegpt prompt --load
git config --global alias.gpt '!codegpt commit --preview --template_string "{{ .summarize_prefix }}: {{ .summarize_title }}"'
