#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOG_File="/tmp/$0-$TIMESTAMP.log"
exec &>$LOG_File
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

useradd roboshop

dnf install nginx -y

systemctl enable nginx

systemctl start nginx

rm -rf /usr/share/nginx/html/*

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip

cd /usr/share/nginx/html

unzip /tmp/web.zip

cp /home/centos/Roboshop/roboshop.conf /etc/nginx/default.d/roboshop.conf 

systemctl restart nginx 

echo "Application installed succesfully"