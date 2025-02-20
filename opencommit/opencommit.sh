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

oco config set OCO_AI_PROVIDER=openai # or deepseek ... wait for the next release
oco config set OCO_API_KEY=sk-tswNquAPTcW9odiy319FLQ
oco config set OCO_API_URL=https://chatapi.akash.network/api/v1
oco config set OCO_MODEL=nvidia-Llama-3-1-Nemotron-70B-Instruct-HF # or DeepSeek-R1-Distill-Qwen-14B ... wait for the next release
oco config set OCO_ONE_LINE_COMMIT=true
oco config set OCO_WHY=true
oco config set OCO_GITPUSH=false

# TODO: https://github.com/di-sukharev/opencommit?tab=readme-ov-file#switch-to-commitlint
