#!/bin/bash
set -euo pipefail

# convert args from vim-style '+22 /path/to/file' to vscode-style
# '/path/to/file:22'
line="$1"
file="$2"

if [[ $file == external/* ]]; then
    file="$(bazel info output_base)/${file}"
fi

code --goto "${file}:${line:1}"