#!/usr/bin/env bash

# Uses: https://github.com/jesperhh/qmlfmt
# Can be installed from AUR "qmlfmt-git"
# Requires qt6-5compat

find . -name "*.qml" -exec qmlfmt -t 2 -i 2 -w {} \;