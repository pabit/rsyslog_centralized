#!/bin/bash
# Rsyslog and auditd client configuration (for centralized Rsyslog achitecture)
sudo apt-get install -y auditd

# auditd configuration
sudo echo '-a exit,always -F arch=b64 -S execve -k root-commands' >> /etc/audit/rules.d/audit.rules
sudo echo '-a exit,always -F arch=b32 -S execve -k root-commands' >> /etc/audit/rules.d/audit.rules
service auditd restart
sudo auditctl -l


# rsyslog configuration
sudo echo 'Configuring rsyslog...'
sudo read -p "What is the rsyslog server IP? (format : 192.168.1.12) Please, do not fail, no verification done..." ipserver
sudo echo '# Logs to be sent to central rsyslog (auditd logs)' >> /etc/rsyslog.conf
sudo echo '$ModLoad imfile' >> /etc/rsyslog.conf
sudo echo '$InputFileName /var/log/audit/audit.log' >> /etc/rsyslog.conf
sudo echo '$InputFileTag tag_audit_log:' >> /etc/rsyslog.conf
sudo echo '$InputFileStateFile audit_log' >> /etc/rsyslog.conf
sudo echo '$InputFileFileSeverity info' >> /etc/rsyslog.conf
sudo echo '$InputFileFileFacility local6' >> /etc/rsyslog.conf
sudo echo '$InputRunFileMonitor' >> /etc/rsyslog.conf
sudo echo "local6.* @$ipserver:514" >> /etc/rsyslog.conf
sudo echo 'rsyslog configured to send audit logs to rsyslog central server'
sudo echo 'Restarting resyslog to apply the new configuration...'

systemctl restart rsyslog
systemctl status rsyslog

exit
