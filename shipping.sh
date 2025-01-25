user=$(id -u)
if [ $user -ne 0 ]
then
echo "user is not root user"
exit 1
fi
LOGDIR=/tmp
name=$0
date=$(date +%F-%H-%M-%S)
logfile=$LOGDIR/$name-$date
r="\e[31m"
g="\e[32m"
y="\e[33m"
n="\e[0m"
validate(){
if [ $1 == 0 ]
then
echo -e " $g $2 .... success $n"
else
echo  -e " $r $2 ... failure $n"
fi  
}
dnf install maven -y &>>$logfile

validate $? "installing maven"

useradd roboshop -y &>>$logfile

user=$(id roboshop) &>> $logfile

if [ $? -ne 0 ]
then 
echo " addding user"
useradd roboshop
else
echo " user already exists "
fi
mkdir /app &>>$logfile

curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip &>>$logfile

validate $? "downloading shipping.zip"

cd /app  &>>$logfile

validate $? "changing to app directory"

unzip /tmp/shipping.zip &>>$logfile

validate $? "unzipping shipping"


mvn clean package &>>$logfile

validate $? "packaging application"

mv target/shipping-1.0.jar shipping.jar &>>$logfile

validate $? "changing location shipping.jar"

cp /home/ec2-user/roboshop-shell/shipping.service /etc/systemd/system/shipping.service &>>$logfile

validate $? "copying shipping.service"

systemctl daemon-reload &>>$logfile

validate $? "deamon-reload"

systemctl enable shipping &>>$logfile 

validate $? "enabling shipping"

systemctl start shipping &>>$logfile

validate $? "start shipping"

dnf install mysql -y &>>$logfile

validate $? "install mysql"

mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRoboShop@1 < /app/db/schema.sql &>>$logfile

validate $? "loading data"

mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRoboShop@1 < /app/db/app-user.sql  &>>$logfile

validate $? "creating app-user"

mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$logfile

validate $? "loading cities and countries"

systemctl restart shipping &>>$logfile

validate $? "restarting shipping"
