#!/usr/bin/env bash

echo 'source /usr/share/bash-completion/bash_completion' >>~/.bashrc
echo 'source <(kubectl completion bash)' >>~/.bashrc
