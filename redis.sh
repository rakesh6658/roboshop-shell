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
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $logfile

validate $? "installing redis repo file"

