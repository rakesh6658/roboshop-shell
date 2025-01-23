#!/bin/bash

user=$(id roboshop)

if [ $? -ne 0 ]
then 
echo " addding user"
useradd roboshop
else
echo " user already exists "
fi
yum  module enable redis:remi-6.2 -y &>>$logfile

validate $? "enabling redis 6.2"

sed -i "s/127.0.0.1/0.0.0.0/g" /etc/redis.conf /etc/redis/redis.conf  &>>$logfile

validate $? "updating listen address"

systemctl enable redis &>>$logfile

validate $? "enabling redis"

systemctl start redis &>>$logfile

validate $? "start redis"

