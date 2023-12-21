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

# dnf module disable nodejs -y &>> $LOG_File

# validate $? "nodejs disable succesfully"

# dnf module enable nodejs:18 -y &>> $LOG_File

# validate $? "nodejs enable succesfully"

# dnf install nodejs -y &>> $LOG_File

# validate $? "nodejs installed succesfully"

# id roboshop 
# if [ $? -ne 0 ]
# then
#    useradd roboshop
#    validate $? "created user succesfully"
# else
#    echo -e "cart already available $Y SKIPPING $N"
# fi

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash


curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash


dnf install rabbitmq-server -y 

systemctl enable rabbitmq-server 


systemctl start rabbitmq-server 

id roboshop roboshop123

rabbitmqctl add_user roboshop roboshop123

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"