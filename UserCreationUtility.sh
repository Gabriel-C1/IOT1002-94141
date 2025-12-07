#!/bin/bash
# UserCreationUtility.sh
# Gabriel Sebastian Contreras Rodriguez
# A00328314
# Read the employee name and display username

input_file="EmployeeNames.csv"
user_count=0
group_count=0
#print beginning of the program

echo "starting username creation..."
echo "--------------------------------"

#skip header line and read each entry

   while IFS=',' read -r firstname lastname department
    do 

     #create username= first letter of firstname + first 7 of lastname

     username="$(echo "${firstname:0:1}${lastname:0:7}" | tr '[:upper:]' '[:lower:]')"

     firstname="$(echo "$firstname")"
     lastname="$(echo "$lastname")"
     department="$(echo "$department")"

echo "Processing: $firstname $lastname ($department) -> username: $username"

# Check if group exists
   if getent group "$department" > /dev/null; then 
       echo "Error: Group '$department' already exists."

    else 
         sudo groupadd "$department"

       if [ $? -eq 0 ]; then
          ((group_count++))
          echo "Group '$department' created."

          else 
            echo "Error: creating group '$department'."
        fi
    fi

# Check if user already exists
   if id "$username" &>/dev/null; then 
      echo "Error: User '$username' already exists."

    else 
         sudo useradd -m -g "$department" "$username"
 
      if [ $? -eq 0 ]; then 
         ((user_count++)) 
        echo "User '$username' created."

      else 
           echo "Error creating user '$username'."
       fi
    fi

# Check if user already in group 
   if id -nG "$username" | grep -qw "department"; then 
      echo "Error: User '$username' is already in group '$department'."

    else 
         sudo usermod -aG "$deparment" "$username" 
         echo "User '$username' added to group '$department'."
    fi
 
done < <(tail -n +2 "$input_file" | tr -d '\r')

echo "---------------------------------"
echo "Summary:"
echo "New users added: $user_count"
echo "New groups created: $group_count"
echo "---------------------------------"

