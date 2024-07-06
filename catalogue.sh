#!/bin/bash

#!/bin/bash

ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MONGDB_HOST=mongodb.daws76s.online

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"


echo "script started executing at $TIMESTAMP" &>> $LOGFILE

VALIDATE(){
    if[ $1 -ne 0 ]
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

dnf module disable nodejs -y &>> $LOGFILE

VALIDATE $? "Disabling nodejs"

dnf module enable nodejs:18 -y &>> $LOGFILE

VALIDATE $? "Enabling nodejs 18"

dnf install nodejs -y &>> $LOGFILE

VALIDATE $? "Installing nodejs"

id roboshop   &>> $LOGFILE
if[ $? -ne 0 ]
then 
    useradd roboshop
    VALIDATE $? "roboshop user creation"
else
    echo -e "roboshop user is already exist $Y Skipping $N"
fi

mkdir -p /app  &>> $LOGFILE

VALIDATE $? "Creating the app directory"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip  &>> $LOGFILE

VALIDATE $? "Downloading the catalogue application"

cd /app  &>> $LOGFILE

VALIDATE $? "open into directory"

unzip -o /tmp/catalogue.zip  &>> $LOGFILE

VALIDATE $? "unzipping the application"

cp C:\Users\ganes\Devops\Repo\RoboShop-ShellScript/catalogue.service /etc/systemd/system/catalogue.service &>> $LOGFILE

VALIDATE $? "Copying the catalogue service file"

systemctl daemon-reload  &>> $LOGFILE

VALIDATE $? "catalogue daemon reload"

systemctl enable catalogue  &>> $LOGFILE

VALIDATE $? "enabling catalogue service"

systemctl start catalogue  &>> $LOGFILE

VALIDATE $? "starting catalogue service"

cp C:\Users\ganes\Devops\Repo\RoboShop-ShellScript/mongo.repo /etc/yum.repos.d/mongo.repo  &>> $LOGFILE

VALIDATE $? "copying mongobd repo"

dnf install mongodb-org-shell  &>> $LOGFILE

VALIDATE $? "Installing mongodb client"

mongo --host $MONGO_HOST </app/schema/catalogue.js  &>> $LOGFILE

VALIDATE $? "Loading catalouge data into MongoDB"


