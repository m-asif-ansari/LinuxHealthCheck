#!/bin/bash

# Initializing formatted date for logging and printing output
date_archiving=$(date "+%d-%m-%Y-%H-%M-%S")
loggingDate=$(date "+%Y-%m-%d::%H:%M:%S")
date=$(date)

# Initializing Log Variable for easier handling of logs and mailing
reportLog="$(hostname) Health Check Report"

# Initializing Default variables for CPU/RAM
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
userLogSize=10b

# Default values for system log files
systemLogPath=/var/log
systemLogSize=10M
archivingPath=/home/asif/oldLogs

# Default mail list for sending mails
senderMail=asif16907@gmail.com,masif24874@gmail.com


# Sourcing the Config file to take input from admin
source HealthCheckScriptConfig.sh

echo "---------------------------------------------------------------------------------------------------------------"
echo "Server Details:"
echo "---------------------------------------------------------------------------------------------------------------"

# Fetching basic specs from the server(user,ip,os)
user=$(whoami)
echo -e "User: $user"
hostname=$(hostname)
echo -e "Hostname: $hostname"
ip=$(hostname -I)
echo -e "IP Address: $ip"
os=$(cat /etc/os-release | grep 'NAME\|VERSION' | grep -v 'VERSION_ID' | grep -v 'PRETTY_NAME' | grep -v 'CODENAME' ) 
echo -e "OS: $os"
echo -e "KERNEL: $(uname -r)"
echo
# Fetching uptime and avg. load
uptime=$(uptime -p)
loadavg=$(cat /proc/loadavg | awk '{print $1 " " $2 " " $3}')
echo "System Uptime: $uptime"
echo "System Load Average: $loadavg"

# Printing CPU Details
echo " "
echo "---------------------------------------------------------------------------------------------------------------"
echo 'CPU Usage:'
echo "---------------------------------------------------------------------------------------------------------------"

# Extracting CPU usage and Top Cpu consuming process from the TOP command
CPU_Usage=$(top -n1 | grep '%Cpu(s)' | awk '{print 100-$8}')

TopCpuProcess=$(top -n1 -o %CPU | egrep -v '%Cpu|top|Tasks|MiB|PID' | head -n 6 | awk '{print $13}' | xargs)

# Checking if the integer part of CPU usage is greater than threshold limit
if [ ${CPU_Usage%.*} -gt $CPU_Threshold2 ]
then
    echo -e "\e[31mDANGER - Above Second Threshold"
    echo -e "\e[31m$CPU_Usage% Usage\e[39m"
    echo ' '
elif [ ${CPU_Usage%.*} -gt $CPU_Threshold1 ]
then
    echo -e "\e[33mWarning - Above First Threshold"
    echo -e "\e[33m$CPU_Usage% Usage\e[39m"
    echo ' '
else
    echo -e "\e[32mBelow Threshold"
    echo -e "\e[32m$CPU_Usage% Usage\e[39m"
    echo ' '
fi

echo 'Top CPU Comsuming Processes -'
echo $TopCpuProcess




# Printing RAM Details
echo " "
echo "---------------------------------------------------------------------------------------------------------------"
echo 'RAM Usage:'
echo "---------------------------------------------------------------------------------------------------------------"

# Extracting various RAM details from FREE command
Ram_Usage=$(free | grep 'Mem' | awk '{print $3/$2 * 100}')

Total_Ram=$(free -h --giga | grep 'Mem' | awk '{print $2}')
Used_Ram=$(free -h --giga | grep 'Mem' | awk '{print $3}')

echo "Total Ram = $Total_Ram"
echo "Used Ram  = $Used_Ram"

# Comparing the integer part of RAM usage with specified Threshold level
if [[ ${Ram_Usage%.*} -gt $RAM_Threshold ]]
then
    echo -e "\e[31mDANGER - Above Threshold"
    echo -e "\e[31m$Ram_Usage% Usage\e[39m"
    echo ' '
else
    echo -e "\e[32mBelow Threshold% Usage\e[39m"
    echo -e "\e[32m$Ram_Usage% Usage\e[39m"
fi
echo " "

# Extracting top RAM Consuming process from TOP Command
TopRamProcess=$(top -n1 -o %CPU | egrep -v '%Cpu|top|Tasks|MiB|PID' | head -n 6 | awk '{print $13}' | xargs)

echo "Top Memory Comsuming Processes -"
echo $TopRamProcess


# Checking status of important services
echo " "
echo "---------------------------------------------------------------------------------------------------------------"
echo 'Important Services Status:'
echo "---------------------------------------------------------------------------------------------------------------"

# Initializing a empty array for storing the list of stopped services
declare -a servicesDown

for i in ${IMP_ServiceList[*]}; do
    # Checking status using the PIDOF command
    status= $(pidof -z $i >2 /dev/null)

    if [[ $? != 1 ]]
    then
        echo "$i"
        echo -e "\e[32mStatus: Running\e[39m"
    else
        echo "$i"
        servicesDown+="$i "
        echo -e "\e[31mStatus: Not Running\e[39m"
    fi

    echo " "
done

# Entering a NONE value in array to display if no service is down
if [ ${#servicesDown[@]} == 0 ]
then
    servicesDown+="None"

fi

# Logging all the details in the variable
reportLog+="\n[$loggingDate] CPU-Usage = $CPU_Usage%
\n[$loggingDate] UpTime = $uptime
\n[$loggingDate] Load-AVG = $loadavg
\n[$loggingDate] RAM-Usage = $Ram_Usage%
\n[$loggingDate] Services-Down = $servicesDown
"


echo "---------------------------------------------------------------------------------------------------------------"
echo 'Disk Usage Details:'
echo "---------------------------------------------------------------------------------------------------------------"

for i in ${userFileSystem[@]}; do
    # Checking if the filepath mention is correct
    if [ -d $i ]
    then
        # Extracting the size of directory if it is correct using the DU command
        size=$(du -sh $i | awk '{print $1}')
        echo Size of $i : $size
    else
        size="$i Directory Not Found"
    fi

    reportLog+="\n[$loggingDate] Size of $i = $size"
done


# Extracting the various system disk usage details from the DF command
totalSize=$(df -h --total | grep -v tmp | grep 'total' | awk '{print $2}')
usedSize=$(df -h --total | grep -v tmp | grep 'total' | awk '{print $3}')
availSize=$(df -h --total | grep -v tmp | grep 'total' | awk '{print $4}')
diskUsage=$(df -h --total | grep -v tmp | grep 'total' | awk '{print $5}' | tr -d "%")


#Printing Disk Details
echo " "
echo "Total Disk Size:" $totalSize
echo "Used Disk Size:"$usedSize
echo "Available Disk Size:"$availSize

# comparing the disk usage with threshold level
if [[ ${diskUsage%.*} -gt $disk_Threshold ]]
then
    echo -e "\e[31mDisk Usage : $diskUsage% \e[39m"
    echo -e "\e[31mDANGER - Above Threshold"
    echo ' '
else
    echo -e "\e[32mDisk Usage : $diskUsage%\e[39m"
    echo -e "\e[32mBelow Threshold% Usage\e[39m"
fi

# logging the disk details
reportLog+="\n[$loggingDate] Disk Free Space = $availSize"
reportLog+="\n[$loggingDate] Disk Free %age = $diskUsage%"





# Printing LOG Details
echo " "
echo "---------------------------------------------------------------------------------------------------------------"
echo 'Logs Management Details:'
echo "---------------------------------------------------------------------------------------------------------------"


# Checking for Specified folder and making archive folder if not present
if [[ ! -d $userLogPath ]]
then
    echo "$userLogPath not present"
else
    if [[ ! -d $userLogPath/archive ]]
    then
        mkdir $userLogPath/archive
        echo "Archive directory created in $userLogPath" 
    fi     
fi

# Finding log files as per specifications
bigLogList=$(find $userLogPath -maxdepth 1 -type f -name "*.log" -size +$userLogSize)

if [[ ! $bigLogList ]]
then
    echo "No log files found as per the specified criteria in $userLogPath"
    reportLog+="\n[$loggingDate] No Logs to Archive in $userLogPath"
else
    for element in ${bigLogList[@]}; do
        # extracting the name of log file to categorize the logs
        logtype=$(basename -s ".log" $element)

        # Creating archive folder for log if not present already
        if [ ! -d $userLogPath/archive/$logtype ]
        then
            mkdir $userLogPath/archive/$logtype
        fi
        # creating the new name of the log file based on the log file name and date/time
        newlogname=$logtype-$date_archiving.log
        # renaming the older name to new name
        mv $element $newlogname
        # zipping the log file
        gzip $newlogname
        # moving the zipped log file to the archive folder
        mv $newlogname.gz $userLogPath/archive/$logtype/$newlogname.gz
        # Logging the archived log details
        echo "archived $element ==> $userLogPath/archive/$logtype"
        reportLog+="\n[$loggingDate] archived $element ==> $userLogPath/archive/$logtype"
    done
fi
echo " "




# Searching for log files as per specified criteria
sysLogList=$(find $systemLogPath -maxdepth 1 -type f -size +$systemLogSize ! -name "*.gz")

if [[ ${sysLogList[@]} ]]
then
    for element in ${sysLogList[@]}; do
        if [ $element ]
        then
            # extracting the name of log file to categorize the logs
            logname=$(basename -s ".log" $element)
            # creating the new name of the log file based on the log file name and date/time
            newlogname=$logname-$date_archiving.log

            # Creating archive folder for log if not present already
            if [ ! -d $archivingPath/$logname ]
            then
                mkdir $archivingPath/$logname
            fi
            # coping the log file to the archive folder with the new name of file
            sudo cp $element $archivingPath/$logname/$newlogname
            # zipping the log file
            sudo gzip $archivingPath/$logname/$newlogname
            # deleting the data of main file without affecting the user permissions
            sudo truncate -s 0 $element

            # Logging the archived log details
            echo "Archived $element ==> $archivingPath/$logname"
            reportLog+="\n[$loggingDate] $element archived and rotated to folder ==> $archivingPath/$logname"
        fi
    done
else
    echo "No log files found as per the specified criteria in $systemLogPath"
    reportLog+="\n[$loggingDate] No Logs to Archive in $systemLogPath"
fi
echo " "


# checking the usage of CPU and Disk and list of not working services.
# if CPU/DISK usage is above threshold or any service is down the alert will be sent
if [[ ${CPU_Usage%.*} -gt $CPU_Threshold2 ]] || [[ $diskUsage -gt $disk_Threshold  ]] || [[ $servicesDown != "NONE" ]]
then
    echo -e $reportLog | mail -s "$hostname Health Check Report $date" $senderMail
    reportLog+="\nReport Sent to: $senderMail"
    echo Report Sent to: $senderMail
else
    reportLog+="\nSystem resources under Threshold Level. No Alert sent"
    echo "System resources under Threshold Level. No Alert sent"
fi

reportLog+="\n---------------------------------------------------------------------------------------------------------------"

echo -e $reportLog >> reportGen.log

