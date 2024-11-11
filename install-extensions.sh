#!/bin/bash

# Read from vscode-extensions.txt and install each extension
while read -r extension; do
    code --install-extension "$extension"
done < vscode-extensions-work.txt

echo "All extensions installed successfully."
