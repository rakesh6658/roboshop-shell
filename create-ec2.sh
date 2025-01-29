#!/bin/bash

servers=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "cart" "user" "shipping" "payment" "dispatch" "web")
instance_type=""
imageid=ami-0b4f379183e5706b9 
securityid=sg-0dc7448f0fa6926f1


for i in ${servers[@]}
do
if [[ $i=="mongodb" || $i=="mysql" ]]
then
$instance_type="t3.micro"
else
$instance_type="t2.micro"
fi
aws ec2 run-instances --image-id $imageid --instance-type $instance_type --security-group-ids $securityid --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value="$i"}]'  | jq -r ".Instances[0].PrivateIpAddress"


done