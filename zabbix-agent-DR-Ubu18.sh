#!/bin/bash

# Download zabbix-agent2-dbgsym package
wget 10.96.1.212/ubuntu/download/zabbix-agent/ubuntu18/zabbix-agent2-dbgsym_6.4.12-1+ubuntu18.04_amd64.deb

# Download dczabbix_agentd.conf
wget 10.96.1.212/ubuntu/download/zabbix-agent/ubuntu18/drzabbix_agentd.conf

# Install libpcre2-8-0 package
apt install libpcre2-8-0 -y

# Install zabbix-agent2-dbgsym package
dpkg -i zabbix-agent2-dbgsym_6.4.12-1+ubuntu18.04_amd64.deb

# Move dczabbix_agentd.conf to /etc/zabbix
mv drzabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf -f

# Replace placeholder in zabbix_agentd.conf
sed -i "s/thaythe/$HOSTNAME /g" /etc/zabbix/zabbix_agentd.conf

# Restart zabbix-agent service
systemctl restart zabbix-agent.service

# Enable zabbix-agent service
systemctl enable zabbix-agent.service
