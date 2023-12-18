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
   user add roboshop
   validate $? "created user succesfully"
else
   echo -e "cart already available $Y SKIPPING $N"
fi

mkdir -p /app

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>>$LOG_File

validate $? "downloaded cart application succesfully"

cd /app

unzip -o /tmp/cart.zip &>> $LOG_File

validate $? "unziped cart application succesfully"

npm install &>> $LOG_File

validate $? "installed nodejs dependencies succesfully"

cp /home/centos/Roboshop/cart.service /etc/systemd/system/cart.service &>> $LOG_File

systemctl daemon-reload &>> $LOG_File

validate $? "daemon-reload succesfully"

systemctl enable cart &>> $LOG_File

validate $? "enable cart succesfully"

systemctl start cart &>> $LOG_File

validate $? "started cart succesfully"

cp /home/centos/Roboshop/mongo.repo /etc/yum.repos.d/mongo.repo 

dnf install mongodb-org-shell -y &>> $LOG_File

validate $? "installed mongodb-org-shell succesfully"

mongo --host mongo.infome.website </app/schema/cart.js &>> $LOG_File

validate $? "Database schema loaded succesfully"

echo "cart Application downloaded successfully "


