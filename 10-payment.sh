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


dnf install python36 gcc python3-devel -y


id roboshop 
if [ $? -ne 0 ]
then
   useradd roboshop
   validate $? "created user succesfully"
else
   echo -e "cart already available $Y SKIPPING $N"
fi

mkdir /app 

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip

cd /app 

unzip /tmp/payment.zip

cd /app 

pip3.6 install -r requirements.txt

cp /home/centos/Roboshop/payment.service /etc/systemd/system/payment.service

systemctl daemon-reload

systemctl enable payment 

systemctl start payment