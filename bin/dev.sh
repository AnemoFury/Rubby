#!/usr/bin/env bash
# bin/dev - Start development server with all services

if ! command -v overmind &> /dev/null; then
  echo "Installing overmind..."
  brew install overmind
fi

overmind start -f Procfile.dev
