#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
#  update_terminal_fullscreen.py
#
#  Description: This script modifies the "Exec=gnome-terminal" line in the 
#  [Desktop Entry] section of the GNOME Terminal .desktop file to ensure that 
#  it includes the --full-screen option if not already present.
#
#  Author: Alan MARCHAND
#  Created: 2024-09-25
#  Version: 1.0
#

import os
import tempfile
import shutil

# Path to the .desktop file to modify
desktop_file = os.path.expanduser(
    "~/.local/share/applications/org.gnome.Terminal.desktop"
)

# Check if the file exists
if not os.path.isfile(desktop_file):
    print(f"File {desktop_file} not found.")
    exit(1)

# Create a temporary file in the same directory as the target file
desktop_dir = os.path.dirname(desktop_file)
with tempfile.NamedTemporaryFile('w', delete=False, dir=desktop_dir) as temp_file:
    # Variable to track if we are in the [Desktop Entry] section
    in_desktop_entry = False

    # Read the original file and write to the temporary file
    with open(desktop_file, 'r') as file:
        for line in file:
            # Detect the start of the [Desktop Entry] section
            if line.strip() == "[Desktop Entry]":
                in_desktop_entry = True
            elif line.strip().startswith('[') and not line.strip() == "[Desktop Entry]":
                # If we enter a new section, exit the [Desktop Entry] section
                in_desktop_entry = False

            # If we are in [Desktop Entry] and find the Exec=gnome-terminal line
            if in_desktop_entry and line.startswith("Exec=gnome-terminal"):
                # Add --full-screen if it's not already present
                if "--full-screen" not in line:
                    line = line.strip() + " --full-screen\n"

            # Write each line (modified or not) to the temporary file
            temp_file.write(line)

# Replace the original file with the modified temporary file
shutil.move(temp_file.name, desktop_file)

print("Modification completed.")
