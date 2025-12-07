#!/bin/bash
# Gabriel Contreras A00328314
# Semester Long Activity 4
# FolderCreation.sh
# Creates /EmployeeData and department folders, assigns group ownership and permissions.

set -e # exits any error

BASE_DIR="/EmployeeData"

# Department - group names
declare -A DEPTS=(
["HR"]="HR"
["IT"]="IT"
["Finance"]="Finance"
["Executive"]="Executive"
["Administrative"]="Administrative"
["CallCentre"]="CallCentre"
)

# Sensitive folders have more restricted permissions
SENSITIVE=("HR" "Executive")

# Permissions
NON_SENSITIVE_PERMS=764
SESNSITIVE_PERMS=760

created_count=0
created_list=()

# Functions
create_if_missing() {
local folder=$1
	if [ ! -d "$folder" ]; then
	 mkdir -p "$folder"
	 created_count=$((created_count+1))
	 created_list+=("$folder")
	 echo "Created: $folder"
	else
	 echo "Exists: $folder"
	fi
}

is_sensitive() {
	local name="$1"
	for s in "${SENSITIVE[@]}"; do
	  [[ "$name" == "$s" ]] && return 0
	done
	return 1
}

# Main function
echo "==== Starting Folder Creation.sh ===="
create_if_missing "$BASE_DIR"

echo
echo "Creating department folders..."
	for dept in "${!DEPTS[@]}"; do
	 path="$BASE_DIR/$dept"
	 group="${DEPTS[$dept]}"

	create_if_missing "$path"

	chown -R root:"$group" "$path"

	if is_sensitive "$dept"; then
	  chmod -R $SENSITIVE_PERMS "$path"
	else
	  chmod -R $NON_SENSITIVE_PERMS "$path"
	fi
	done
echo
echo "Folders created this run: $created_count"
for f in "${created_list[@]}"; do
	echo " - $f"
done

echo
echo "Final folder permissions:"
ls -ld $BASE/*
