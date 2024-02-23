#/bin/bash 

# This script is related to UserManagement and Backup 

# Validated that user should be root user 

if [[ "${UID}" -ne 0 ]]
then
        echo "Please run with sudo or root "
        exit 1
fi


# Select an option 
usage(){ 
echo "Below are the options : "
echo 
echo "A: Add the user "
echo "B: Delete the user "
echo "C: List of all user "
echo "D: Add the group "
echo "E: archieve the directory "
echo "F :Reset  password"
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

# Backup function 

backup(){
  
  base_path=/home/ubuntu	
  read -p "Please enter the directory you want to take backup " backup_dir 
  tar czf $base_path/$(date +%y-%m-%d-%H%M%S)$backup_dir.tar.gz $backup_dir  
  mv $base_path/*.tar.gz $base_path/backup

}

# Calling the usage function 
usage 

read -p "Please choose an option :" choice 

case $choice in 
	a) adduser ;;
	b) deleteuser ;;
	c) listofuser ;;
	d) addthegroup ;;
	e) backup ;;
	*) echo " Usage : ${0} WRONG OPTION "
		 usage
	         exit ;;	
		
esac


