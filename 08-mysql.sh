#!/bin/bash
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"
set -e
Date=$(date +%F-%H-%M-%S)
LOG_File="/tmp/$0-$Date.log"
exec &> $LOG_File
# validate(){
#     if [ $1 -ne 0 ]
#     then
#        echo -e "$R Error: not $2 $N"
#        exit 1
#     else
#        echo -e "$G $2  $N"
#     fi
# }
ID=$(id -u)
if [ $ID -ne 0 ]
then 
   echo -e "$R Error : Login to root user $N "
   exit 1
else
  echo " You are a Root user "
fi

dnf module disable mysql -y

cp /home/centos/Roboshop/mysql.repo /etc/yum.repos.d/mysql.repo

dnf install mysql-community-server -y 

systemctl enable mysqld

systemctl start mysqld

mysql_secure_installation --set-root-pass RoboShop@1