# nextcloudcmd-systemd-service
 Service to sync nextcloud in non-gui linux
 Tested on ubuntu 20.04 LTS on raspberry pi.
 Be aware the nextcloud username and password will be visible in the output of ps -ef  when the nextcloudcmd program is active

 The Service uses 6 files 

nextcloudsync.service: the systemd service
nextcloud_cmd.sh: called by the service, executing the nextcloudcmd program at a fixed interval.
nextcloud_sync_stop.cmd: called by the service, stopping the nextcloud_cmd script and the nextcloudcmd program.
nc_sync_env: the environment used by the 2 shell scripts
excluded: Contains the files excluded in the sync
nextcloudsync_logrotate: used to roate the log file

Installation

Make a .nextcloud directory and set the permissions to user only
mkdir ~/.nextcloud
chmod 700 ~/.nextcloud



copy the service file into the system directory

cd nextcloudcmd-systemd-service
sudo cp nextcloudsync.service /usr/lib/systemd/system/

copy environment and shell files to the ~/.nextcloud directory

cp nc_sync_env
cp *.sh ~/.nextcloud/

Edit both the shell scripts and replace [USERNAME] with the user directory name.

Edit the nc_sync_env file and replace all the linux and nextcloud username and nextcloud password placeholders.

create the log file and change the permissions

sudo touch /var/log/nextcloudsync.log
sudo chown USER:GROUP /var/log/nextcloudsync.log

Copy the log rotation file and restart the service
sudo cp nextcloudsync_logrotate /etc/logrotate.d/
sudo systemctl restart logrotate.service	

Reload the daemons, enable and start the service

sudo systemctl daemon-reload
sudo systemctl enable nextcloudsync.service
sudo systemctl start nextcloudsync.service
