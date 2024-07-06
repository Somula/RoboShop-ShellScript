#!/bin/bash

ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script started executing at $TIMESTAMP" &>> $LOGFILE

VALIDATE(){
    if [ $1 -ne 0 ]
        then 
            echo -e "$2 ... $R FAILED $N"
            exit 1
        else
            echo -e "$2 ... $G Success $N"
    fi
}


if[ $ID -ne 0]
    then
        echo -e "$R Please run the script with root access. $N"
        exit 1
    else
        echo -e "$G You are Root User. $N"
fi

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "Copied Mongodb repo"


dnf install mongodb-org -y &>> $LOGFILE

VALIDATE $? "Installing MongoDB"

systemctl enable mongodb &>> $LOGFILE

VALIDATE $? "Enabling MongoDB"

systemctl start mongodb &>> $LOGFILE

VALIDATE $? "Starting MongoDB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOGFILE

VALIDATE $? "Remote access to mongodb"

systemctl restart mongodb &>> $LOGFILE

VALIDATE $? "Restarting MongoDB"





