#!/bin/bash

# Initializing formatted date for logging and printing output
date_archiving=$(date "+%d-%m-%Y-%H-%M-%S")
loggingDate=$(date "+%Y-%m-%d::%H:%M:%S")
date=$(date)

# Initializing Log Variable for easier handling of logs and mailing
reportLog="$(hostname) Health Check Report"

# Initialxizing Default variables for CPU/RAM
CPU_Threshold2=90
CPU_Threshold1=75
RAM_Threshold=75
IMP_ServiceList=("atop" "cron" "lightdm" "Xorg" "mintUpdate" "firefox" "chrome" "python3" "code")

# Initializing Default variables for Disk Space
userFileSystem=("/home" "/home/asif/Downloads" )
disk_Threshold=75

# Initializing Default variables for Log Monitoring
userLogPath=/home/asif/scripts
userLogDay=1
userLogSize=1b

# Initializing values for system log files
systemLogPath=/var/log
systemLogSize=1b
archivingPath=/home/asif/oldLogs

# mail list for sending mails
senderMail=asif16907@gmail.com,masif24874@gmail.com
