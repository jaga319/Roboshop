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

dnf module disable nodejs -y

validate $? "disable succesfully"

dnf module enable nodejs:18 -y

validate $? "enable succesfully"

dnf install nodejs -y

validate $? "installed succesfully"

useradd roboshop

validate $? "created user succesfully"

mkdir /app

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip

validate $? "downloading catalog succesfully"

cd /app

unzip /tmp/catalogue.zip

npm install 

validate $? "installing dependencies succesfully"

cp /home/centos/roboshop/catalog.service /etc/systemd/system/catalogue.service

systemctl daemon-reload


systemctl enable catalogue


systemctl start catalogue

cp /home/centos/Roboshop/mongo.repo /etc/yum.repos.d/mongo.repo

dnf install mongodb-org-shell -y

mongo --host mongo.infome.website </app/schema/catalogue.js




