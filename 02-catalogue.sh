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
       exit 1
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

dnf module disable nodejs -y &>> $LOG_File

validate $? "disable succesfully"

dnf module enable nodejs:18 -y &>> $LOG_File

validate $? "enable succesfully"

dnf install nodejs -y &>> $LOG_File

validate $? "installed succesfully"

id roboshop 
if [ $? -ne 0 ]
then
   useradd roboshop
   validate $? "created user succesfully"
else
   echo -e "User already available $Y SKIPPING $N"
fi

mkdir -p /app

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOG_File

validate $? "downloading catalog succesfully"

cd /app

unzip -o /tmp/catalogue.zip &>> $LOG_File

npm install &>> $LOG_File

validate $? "installing dependencies succesfully"

cp /home/centos/roboshop/catalogue.service /etc/systemd/system/catalogue.service &>> $LOG_File

systemctl daemon-reload &>> $LOG_File


systemctl enable catalogue &>> $LOG_File


systemctl start catalogue &>> $LOG_File

cp /home/centos/Roboshop/mongo.repo /etc/yum.repos.d/mongo.repo 

dnf install mongodb-org-shell -y &>> $LOG_File

mongo --host mongo.infome.website </app/schema/catalogue.js &>> $LOG_File




