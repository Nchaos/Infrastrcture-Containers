#!/bin/bash

for file in $HOME/docker-entrypoint.d/*; do $file 2>/dev/stdout; done