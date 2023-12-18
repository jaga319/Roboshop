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
  echo " You are a Root user "
fi

dnf module disable nodejs -y &>> $LOG_File

validate $? "nodejs disable succesfully"

dnf module enable nodejs:18 -y &>> $LOG_File

validate $? "nodejs enable succesfully"

dnf install nodejs -y &>> $LOG_File

validate $? "nodejs installed succesfully"

id roboshop 
if [ $? -ne 0 ]
then
   useradd roboshop
   validate $? "created user succesfully"
else
   echo -e "User already available $Y SKIPPING $N"
fi

mkdir -p /app

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>>$LOG_File

validate $? "downloaded user application succesfully"

cd /app

unzip -o /tmp/user.zip &>> $LOG_File

validate $? "unziped user application succesfully"

npm install &>> $LOG_File

validate $? "installed nodejs dependencies succesfully"

cp /home/centos/Roboshop/user.service /etc/systemd/system/user.service &>> $LOG_File

systemctl daemon-reload &>> $LOG_File

validate $? "daemon-reload succesfully"

systemctl enable user &>> $LOG_File

validate $? "enable user succesfully"

systemctl start user &>> $LOG_File

validate $? "started user succesfully"

cp /home/centos/Roboshop/mongo.repo /etc/yum.repos.d/mongo.repo 

dnf install mongodb-org-shell -y &>> $LOG_File

validate $? "installed mongodb-org-shell succesfully"

mongo --host mongo.infome.website </app/schema/user.js &>> $LOG_File

validate $? "Database schema loaded succesfully"

echo "user Application downloaded successfully "


