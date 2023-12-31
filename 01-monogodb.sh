#!/bin/bash
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

Date=$(date +%F-%H-%M-%S)
LOG_File="/tmp/$0-$Date.log"


validate(){
    if [ $1 -ne 0 ]
    then
       echo -e "$R Error: not $2 $N"
    else
       echo -e "$G $2  $N"
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

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOG_File

validate $? "Copied mongodb successfully"

dnf install mongodb-org -y 

validate $? "install mongodb successfully"

systemctl enable mongod

validate $? "enable mongodb successfully"

systemctl start mongod

validate $? "started mongodb successfully"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf 

validate $? "Remote access to mongodb successfully changed"

systemctl restart mongod

validate $? "restarted mongodb successfully" &>> $LOG_File




