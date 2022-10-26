
# Nextcloudcmd Systemd Sync Service

Service to sync nextcloud in non-gui linux. Tested with RaspberryPi. on ubuntu 20.04 LTS.
**Note** The nextcloud username and password will be visible in the output of ```ps -ef```, when the nextcloudcmd program is running.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

Might be obvious nextcloudcmd needs to be installed.

```
sudo apt install nextcloud-desktop-cmd
```

### Installing

Clone the project the target computer 
```
git clone https://github.com/Skammi/nextcloudcmd-systemd-service.git
```
The Service uses 6 files:

| filename | purpose |
|----------|---------|
| nextcloudsync.service | the systemd service |
| nextcloud_cmd.sh | called by the service, executing the nextcloudcmd program at a fixed interval. |
| nextcloud_sync_stop.cmd | called by the service, stopping the nextcloud_cmd script and the nextcloudcmd program. |
| nc_sync_env | the environment used by the 2 shell scripts  |
| excluded | Contains the files excluded in the sync |
| nextcloudsync_logrotate | used to roate the log file |
A step by step series of examples that tell you how to get a development env running

1. Get into the project directory.
```
cd nextcloudcmd_systemd_service
```
2. Adapt the files to the user.
2.1.Replace ```[USERNAME]``` with the appropriate user name in: nextcloudsync.service, nextcloud_cmd.sh, nextcloud_sync_stop.sh and .nc_sync_env
2.2. In the environment file nc_sync_env replace ```[NEXTCLOUD_USERNAME]``` and ```[NEXTCLOUD_PASSWORD]``` with the Nextcloud username and password. And provide the appropriate url in the NC_SERVER variable.
3. Copy the service file to the sytemd service directory
```
sudo cp nextcloudsync.service /usr/lib/systemd/system/
```
4. Copy the log rotate file to the etc/.. directory
```
sudo cp nextcloudsync_logrotate /etc/logrotate.d/
```
5. Create a directory in the users home directory.
```
mkdir ~/.nextcloud
chmod 700 ~/.nextcloud
```
6. copy the shell, environment and exclude file to that directory
```
cp *.sh ~/.nextcloud/
cp {nc_sync_env,excluded} ~/.nextcloud/
```
7. Create the logfile
```
sudo touch /var/log/nextcloudsync.log
```
8. If required populate the excluded. Nextcloud syncronise everthing from the server side off the user. The parts that should not be syncronised must be entered in the exclude file

9. Enable and start the service.
```
sudo systemctl enable nextcloudsync.service
sudo systemctl start nextcloudsync.service
```
10. Check the status, a successful output looks like this:
```
sudo systemctl status nextcloudsync.service
```
``` 
● nextcloudsync.service - launch nexcloud sync package
     Loaded: loaded (/lib/systemd/system/nextcloudsync.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2022-10-25 19:01:30 CDT; 19min ago
   Main PID: 2035 (nextcloud_cmd.s)
      Tasks: 2 (limit: 4201)
     CGroup: /system.slice/nextcloudsync.service
             ├─2035 /bin/bash /home/jac/.nextcloud/nextcloud_cmd.sh
             └─2272 sleep 151

Oct 25 19:10:06 minipupper nextcloud_cmd.sh[2035]: nextcloud_cmd.sh: start
Oct 25 19:12:40 minipupper nextcloud_cmd.sh[2035]: nextcloud_cmd.sh: start
Oct 25 19:15:14 minipupper nextcloud_cmd.sh[2035]: nextcloud_cmd.sh: start
Oct 25 19:17:49 minipupper nextcloud_cmd.sh[2035]: nextcloud_cmd.sh: start
Oct 25 19:20:24 minipupper nextcloud_cmd.sh[2035]: nextcloud_cmd.sh: start
```

## Example excluded file
The default of nextcloudcmd is to syncronise syncronise everthing from the server side off the user. When specifiek directories are not required they have to be placed in the ```excluded``` file. The startpoint is a standard nextcloud directory structure.
```
cd ~/nextcloud
ls | sort
Documents
Nextcloud Manual.pdf
Nextcloud intro.mp4
Nextcloud.png
OurCode
OurManual
Photos
Reasons to use Nextcloud.pdf
Templates
```
With additional directories under documents: Business, Hobby and private.
```
find Documents/ -maxdepth 2 | sort
Documents/
Documents/Business
Documents/Example.md
Documents/Hobby
Documents/Nextcloud flyer.pdf
Documents/Private
Documents/Readme.md
Documents/Welcome to Nextcloud Hub.docx
```
When the Top directory Templates and the Documents subdirectries Private and Business are not required, then the excludes file is like this:
```
# file          ~/.nextcloud/excluded
Templates
Documents/Business
Documents/Private

```

## Security Note
As stated in the description, the nextcloud username and password will be in clear text in the output of ```ps -ef```, when the nextcloudcmd program is running. 
```
ps -fu ubuntu
```
See here: -u ubuntu and -p my1Secret_PWD
```
UID          PID    PPID  C STIME TTY          TIME CMD
...
ubuntu      2035       1  0 19:01 ?        00:00:00 /bin/bash /home/ubuntu/.nextcloud/nextcloud_cmd.sh
ubuntu      2053    2035 32 19:02 ?        00:00:00 /usr/bin/nextcloudcmd -s -u ubuntu -p my1Secret_PWD --unsyncedfolders /home/ubuntu/.nextcloud/excluded --non-interactive /home/ubuntu/nextcloud https://nextcloud.example.com
ubuntu      2059    1893  0 19:02 pts/0    00:00:00 ps -fu ubuntu
```
That is not a concern in de environment I use it in.

## Authors
Jacob Kamminga
