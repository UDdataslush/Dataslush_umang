#!/bin/bash

# Print the script name and arguments
echo "Script name: $0"
echo "First argument: $1"
echo "Second argument: $2"

# Print all arguments and their count
echo "All arguments: $@"
echo "Number of arguments: $#"

# Loop through all arguments
for arg in $@
do
  echo "Argument: $arg"
done
