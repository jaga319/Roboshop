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

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

validate $? "redis downloaded succesfully"

dnf module enable redis:remi-6.2 -y

dnf install redis -y

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf

systemctl enable redis

systemctl start redis

echo "redis application successfully installed"
