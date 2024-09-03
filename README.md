# Server Health Check

### Health Check Script made with Bash

![GitHub repo size](https://img.shields.io/github/repo-size/m-asif-ansari/LinuxHealthCheck)
![GitHub contributors](https://img.shields.io/github/contributors/m-asif-ansari/LinuxHealthCheck)
![GitHub stars](https://img.shields.io/github/stars/m-asif-ansari/LinuxHealthCheck?style=social)
![GitHub forks](https://img.shields.io/github/forks/m-asif-ansari/LinuxHealthCheck?style=social)

`Health Check Script` is a `Bash Script` written mainly for `Debain Based LINUX Distros` which allows `System Administrators` to check the `Server Health` of their `Linux Servers`.

The Script is written in `BASH`. The `HealthCheckScriptConfig.sh` file contains the configurations for the script. The Config file should be modified as per user's requirements.

[![HealthCheckScript](https://img.shields.io/badge/HealthCheckScript-Source_Code-blue)](https://github.com/m-asif-ansari/LinuxHealthCheck)


<!-- <details>
<summary>
Demo Credentials for Website
</summary>

- Demo credentials for the website can be found in the `DOCTOR.MD` & `PATIENT.MD` files.

- Or you can create your own user profile and use them to login to the website.

</details> -->

## Main Funtionalities of the Script
- Checks the `System Uptime` and `Load Averages` of the `Linux Server`.
- Checks the `CPU Usage` of the `Linux Server`.
- Logs the `Top CPU Consuming Processes` of the `Linux Server`.
- Checks the `Status of Important Services` in the `Linux Server`.
- Checks the `RAM and DISK Usage` of the `Linux Server`.
- Logs the `Top RAM Consuming Processes` of the `Linux Server`.
- Checks the `File System Size` of file systems user mentioned in the config file.
- Compress and Archives the `Big Log Files` on the `Linux Server`.
- Send Alerts to the `Email Address` mentioned in the config file, if the CPU Usage / Disk Usage is greater than the threshold mentioned in the config file, or if any important service is down.
- Logs the `Result of Health Check Report` for future reference. 



## Output of the Script

The Output of the Script is as follows:


<details>
<summary> 
  <b>Terminal Output</b>
</summary>

![Output of the Script](https://github.com/m-asif-ansari/LinuxHealthCheck/blob/main/Images/OutputScreen1.png)
![Output of the Script](https://github.com/m-asif-ansari/LinuxHealthCheck/blob/main/Images/OutputScreen2.png)
![Output of the Script](https://github.com/m-asif-ansari/LinuxHealthCheck/blob/main/Images/OutputScreen3.png)

</details>
<br>

<details>
<summary> 
  <b>Alert Mail</b>
</summary>

![Output of the Alert Mail](https://github.com/m-asif-ansari/LinuxHealthCheck/blob/main/Images/AlertMail.png)

</details>
<br>

<details>
<summary> 
  <b>Log File Output</b>
</summary>

![Output of the Log File](https://github.com/m-asif-ansari/LinuxHealthCheck/blob/main/Images/LogFile.png)

</details>
<br>

## Contact

If you want to contact me you can reach me at <asif16907@gmail.com>.
