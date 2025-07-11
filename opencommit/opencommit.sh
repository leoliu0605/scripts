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

if ! command -v infisical >/dev/null 2>&1; then
    npm install -g @infisical/cli
fi

infisical login
infisical init

oco config set OCO_AI_PROVIDER=azure
oco config set OCO_API_KEY=$(infisical secrets get AureOpenAI --plain --silent)
oco config set OCO_API_URL=$(infisical secrets get AureOpenAI-Endpoint --plain --silent)
oco config set OCO_MODEL=gpt-4o
oco config set OCO_ONE_LINE_COMMIT=true
oco config set OCO_WHY=false
oco config set OCO_GITPUSH=false

# TODO: https://github.com/di-sukharev/opencommit?tab=readme-ov-file#switch-to-commitlint
