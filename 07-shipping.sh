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


dnf install maven -y

validate $? "Successfully install Maven"


id roboshop

if [ $? -eq 0 ]
then 
   echo "User is already available SKIPPING"
else 
    useradd roboshop
    echo "user added succesfully"
fi



mkdir /app


curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip


cd /app

unzip /tmp/shipping.zip

mvn clean package

mv target/shipping-1.0.jar shipping.jar

cp /home/centos/Roboshop/shipping.service /etc/systemd/system/shipping.service


systemctl daemon-reload

systemctl enable shipping 

systemctl start shipping

dnf install mysql -y

mysql -h mysql.infome.website -uroot -pRoboShop@1 < /app/schema/shipping.sql 

systemctl restart shipping