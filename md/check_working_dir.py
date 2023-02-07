#!/usr/bin/env python3
import os

required_directories = ['templates', 'templates_plumed', 'templates_colvar']

for i, directory in enumerate(required_directories):
    if not os.path.exists(directory):
        print(f"Error: The directory {directory} does not exist.")
        exit(1)
    else:
        print(f"{i}: {directory} exists")

