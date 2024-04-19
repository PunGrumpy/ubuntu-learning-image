#!/bin/bash

if command -v eza &> /dev/null
then
    alias ls='eza'
    alias ll='eza -l'
    alias la='eza -a'
    alias lla='eza -la'
    alias lt='eza --tree'
    alias llt='eza -lt'
fi