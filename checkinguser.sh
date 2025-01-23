#!/bin/bash

user=$(id roboshop)
if [ $user -ne 0 ]
then 
echo " addding user"
useradd roboshop
else
echo " user already exists "
fi
