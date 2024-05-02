#!/bin/bash

function check_command() {
	if command -v $1 &>/dev/null; then
		return 0
	else
		return 1
	fi
}

if check_command eza; then
	alias ls='eza'
	alias ll='eza -l'
	alias la='eza -a'
	alias lla='eza -la'
	alias lt='eza --tree'
	alias llt='eza -lt'
fi

if check_command nvim; then
	alias vim='nvim'
fi
