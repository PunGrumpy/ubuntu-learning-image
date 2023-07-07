#!/bin/bash

if command -v lsd &> /dev/null
then
    alias ls='lsd'
    alias ll='lsd -l'
    alias la='lsd -a'
    alias lla='lsd -la'
    alias lt='lsd --tree'
    alias llt='lsd -lt'
fi