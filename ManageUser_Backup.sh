#/bin/bash 

# This script is related to UserManagement and Backup 

# Validated that user should be root user 

if [[ "${UID}" -ne 0 ]]
then
        echo "Please run with sudo or root "
        exit 1
fi


# Select an option 
function display_usage {
	echo "Usage: $0 [OPTIONS]"
	echo "options:"
	echo "  -c, --create  Create a new user account."
	echo "  -d, --delete  Delete an exisiting user account."
	echo "  -r, --reset   Reset password for an existing user account."
	echo "  -l, --list    List all user accounts on the system."
	echo "  -h, --help    Display this help and exit."
    echo "  -g, --group   Add to group."
    echo "  -b, --backup  create backup."
}

#adduser function 

adduser(){
  # Store Ist argument as Username 

  read -p "Please enter the user name you want to add :" USER_NAME

  #Create  a USERNAME
   useradd -m $USER_NAME

  #Check user is created successfully 
   if [[ $? -ne 0 ]]
    then
        echo "User already exist "
        exit 1
    else 
     read -p "Please enter the password you want to set " PASSWORD
      #Set the Password 
     echo "$USER_NAME:$PASSWORD" | chpasswd
   fi
   
  # Display the USERNAME/Password 
   echo
   echo "USERNAME created : $USER_NAME"
   echo
   echo "Password set : $PASSWORD"
}

#Delete the user 
deleteuser(){
      clear 
      USERLIST=$(cat /etc/passwd |grep "/bin/sh" |awk -F ":" '{print $1}')
      echo "These are the  users  : $USERLIST"
     read -p "Please enter the username you want to remove :" USER_NAME_DEL
      userdel $USER_NAME_DEL 
   
      clear
      USERLIST=$(cat /etc/passwd |grep "/bin/sh" |awk -F ":" '{print $1}')
      echo "Now users after deleteion : $USERLIST"
}

#See List of user 
listofuser(){

      USERLIST=$(cat /etc/passwd |grep "/bin/sh" |awk -F ":" '{print $1}')
      echo "These are the  users  : $USERLIST"
}

#Add the Group

addthegroup(){
	read -p "Please enter the group you want to add " GROUP_NAME
	groupadd $GROUP_NAME
        echo "Group added successfully "
	GROUPADDED=$(cat /etc/group |grep "$GROUP_NAME")
        echo $GROUPADDED
}

#function to reset the password for an existing user account
resetpassword() {
	read -p "Enter the username to reset password: " username
	#check if the username exists
	if id "$username" &>/dev/null; then
		#prompt for password (Note: you might want to use 'read -s' to hide the password input)
		read -p "Enter the new password for $username: " password
		#set the new password
		echo "$username:$password" | chpasswd
		echo "password for user '$username' reset Successfully."
	else
		echo "Error: The username '$username' does not exists. please enter a valid username."
	fi
}

# Backup function 

backup(){
  base_path=/home/ubuntu	
  read -p "Please enter the directory you want to take backup " backup_dir 
  tar czf $base_path/$(date +%y-%m-%d-%H%M%S)$backup_dir.tar.gz $backup_dir  
  mv $base_path/*.tar.gz $base_path/backup
}

# Calling the usage function 
usage 
#command-line argument parsing
while [ $# -gt 0 ]; do
	case "$1" in
		-c| --create)
		    adduser
			;;
		-d| --delete)
			deleteuser
			;;
		-r| --reset)
			resetpassword
			;;
		-l| --list)
			listofusers
			;;
  		-g| --group)
			addtogroup
			;;
		-b| --backup)
			backup
			;;
		*)
			echo "Error: Invalid option "$1". Use "--help" to see available options."
			exit 1
			;;
		esac
		shift
done
