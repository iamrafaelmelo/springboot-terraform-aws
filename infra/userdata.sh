#!/bin/bash

yum update -y
yum install -y docker

systemctl enable docker
systemctl start docker

usermod -a -G docker ec2-user # default user aws ec2

docker run -p 80:8080 <docker-username>/springboot-aws:latest
