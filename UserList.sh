#!/bin/bash

USERLIST=$(cat /etc/passwd |grep "/bin/sh" |awk -F ":" '{print $1}')
echo "Number of users are : $USERLIST"

