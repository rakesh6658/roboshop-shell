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
dnf module disable redis -y &>> $logfile

validate $? "disabling redis"

dnf module enable redis:7 -y &>> $logfile

validate $? "enable redis"

yum install redis -y &>> $logfile

validate $? "installing redis"

sed -i "s/127.0.0.1/0.0.0.0/g"  /etc/redis/redis.conf /etc/redis.conf  &>>$logfile

validate $? "updating listen address"

systemctl enable redis &>>$logfile

validate $? "enabling redis"

systemctl start redis &>>$logfile

validate $? "start redis"


