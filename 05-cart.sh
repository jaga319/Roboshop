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
   echo -e "cart already available $Y SKIPPING $N"
fi

mkdir -p /app

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip 

validate $? "downloaded cart application succesfully"

cd /app

unzip -o /tmp/cart.zip 

validate $? "unziped cart application succesfully"

npm install 

validate $? "installed nodejs dependencies succesfully"

cp /home/centos/Roboshop/cart.service /etc/systemd/system/cart.service 

systemctl daemon-reload 

validate $? "daemon-reload succesfully"

systemctl enable cart 

validate $? "enable cart succesfully"

systemctl start cart 

validate $? "started cart succesfully"

