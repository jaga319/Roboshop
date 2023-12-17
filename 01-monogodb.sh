#!/bin/bash
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"


validate(){
    if [ $1 -ne 0 ]
    then
       echo -e "$R Error:$2 is not installed successfully $N"
    else
       echo -e "$G $2 is installed successfully installed $N"
    fi
}
ID=$(id -u)
if [ $ID -ne 0 ]
then 
   echo -e "$R Error : Login to root user $N "
   exit 1
else
  echo " You are in Root user "
fi

cp mongo.repo /etc/yum.repos.d/