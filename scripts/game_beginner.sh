#!/bin/bash

#########################################################################################

# Set color variables
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
RESET=$(tput sgr0)

# Global variable
current_dir=$(pwd)

#########################################################################################

# Display a welcome message
welcome_message() {
	clear
	echo "${BLUE}Welcome to the Linux Adventure Game!"
	echo "Your mission is to find the hidden treasure."
	echo "Good luck!"
	echo "${RESET}"
}

# Display the current directory
display_directory() {
	echo "${YELLOW}Current directory: $current_dir${RESET}"
}

# List files and directories
list_files() {
	echo "${MAGENTA}Listing files and directories:"
	ls -l --group-directories-first "$current_dir"
	echo "${RESET}"
}

# Validate input for directory or file names
validate_name() {
	if [[ -z "$1" ]]; then
		echo "${RED}Name cannot be empty!${RESET}"
		return 1
	fi
	return 0
}

# Change to a new directory
change_directory() {
	read -p "${CYAN}Enter a directory name (or leave blank to list available directories): " directory

	if [ -z "$directory" ]; then
		echo "${CYAN}Available directories in $current_dir:"
		find "$current_dir" -mindepth 1 -maxdepth 1 -type d -exec basename {} \;
	else
		if ! validate_name "$directory"; then
			return
		fi

		new_dir="$current_dir/$directory"

		if [ -d "$new_dir" ]; then
			current_dir="$new_dir"
			echo "Changed directory to: $current_dir"
		else
			echo "${RED}Directory not found!${RESET}"
		fi
	fi
}

# Create a new file
create_file() {
	read -p "${CYAN}Enter a file name: " file

	if ! validate_name "$file"; then
		return
	fi

	if [ -e "$current_dir/$file" ]; then
		echo "${YELLOW}File already exists!${RESET}"
	else
		touch "$current_dir/$file"
		echo "Created file: $current_dir/$file"
	fi
}

# Read the contents of a file
read_file() {
	read -p "${CYAN}Enter a file name (or leave blank to show all files in the current directory): " file

	if [ -z "$file" ]; then
		list_files
	elif [ -f "$current_dir/$file" ]; then
		echo "${MAGENTA}Contents of $file:"
		cat "$current_dir/$file"
	else
		echo "${RED}File not found!${RESET}"
	fi
}

# Create a new directory
create_directory() {
	read -p "${CYAN}Enter a directory name: " directory

	if ! validate_name "$directory"; then
		return
	fi

	mkdir -p "$current_dir/$directory"
	echo "Created directory: $current_dir/$directory"
}

# Remove a file or directory
remove_item() {
	read -p "${CYAN}Enter a file/directory name: " name

	if ! validate_name "$name"; then
		return
	fi

	if [ -e "$current_dir/$name" ]; then
		rm -r "$current_dir/$name"
		echo "Removed: $current_dir/$name"
	else
		echo "${RED}File/directory not found!${RESET}"
	fi
}

# Display a custom message
display_message() {
	read -p "${CYAN}Enter a message: " message

	echo "${GREEN}$message${RESET}"
}

# Check the permissions of a file
check_permissions() {
	read -p "${CYAN}Enter a file name: " file

	if ! validate_name "$file"; then
		return
	fi

	if [ -f "$current_dir/$file" ]; then
		echo "${MAGENTA}Permissions of $file:"
		ls -l "$current_dir/$file"
	else
		echo "${RED}File not found!${RESET}"
	fi
}

# Read a system file
read_system_file() {
	read -p "${CYAN}Enter a system file name (e.g., /etc/hosts): " file

	if ! validate_name "$file"; then
		return
	fi

	if [ -f "$file" ]; then
		echo "${MAGENTA}Contents of $file:"
		cat "$file"
	else
		echo "${RED}File not found!${RESET}"
	fi
}

# Create a symbolic link to a file or directory
create_symlink() {
	read -p "${CYAN}Enter a file/directory name to symlink: " name
	read -p "Enter a symlink name: " symlink_name

	if ! validate_name "$name"; then
		return
	fi

	if [ -e "$current_dir/$name" ]; then
		ln -s "$current_dir/$name" "$current_dir/$symlink_name"
		echo "Created symlink: $current_dir/$symlink_name"
	else
		echo "${RED}File/directory not found!${RESET}"
	fi
}

# Search for a file or directory
search_item() {
	read -p "${CYAN}Enter a keyword to search: " keyword

	if ! validate_name "$keyword"; then
		return
	fi

	echo "${MAGENTA}Search results for \"$keyword\":"
	find "$current_dir" -iname "*$keyword*" -exec ls -ld {} \;
	echo "${RESET}"
}

# Display the help menu
show_help() {
	echo "${GREEN}Available commands:"
	echo "- ls: List files and directories"
	echo "- cd: Change directory"
	echo "- cat: Read a file"
	echo "- mkdir: Create a directory"
	echo "- rm: Remove a file or directory"
	echo "- echo: Display a custom message"
	echo "- permissions: Check file permissions"
	echo "- readfile: Read a system file"
	echo "- symlink: Create a symbolic link"
	echo "- search: Search for a file or directory"
	echo "- exit: Exit the game"
	echo "${RESET}"
}

# Exit the game
exit_game() {
	echo "${GREEN}Thanks for playing!${RESET}"
	exit 0
}

# Game loop
game_loop() {
	while true; do
		display_directory

		read -p "${CYAN}Enter a command (type 'help' for available commands): " command

		case $command in
		ls)
			list_files
			;;
		cd)
			change_directory
			;;
		cat)
			read_file
			;;
		mkdir)
			create_directory
			;;
		rm)
			remove_item
			;;
		echo)
			display_message
			;;
		permissions)
			check_permissions
			;;
		readfile)
			read_system_file
			;;
		symlink)
			create_symlink
			;;
		search)
			search_item
			;;
		exit)
			exit_game
			;;
		help)
			show_help
			;;
		*)
			echo "${RED}Invalid command!${RESET}"
			;;
		esac

		# Check if the hidden treasure has been found
		if [ -f "$current_dir/treasure.txt" ]; then
			echo "${GREEN}Congratulations! You found the hidden treasure!${RESET}"
			exit_game
		fi
	done
}

#########################################################################################

# Main function
welcome_message
game_loop
