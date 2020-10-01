#! /bin/bash
FILE=/usr/share/elasticsearch/credentials.json
if [ -f "$FILE" ]; then
    echo "$FILE exist"
    exit 0
fi

################### INSTALL PREREQUISITIES  #####################
sudo apt update
sudo apt -y install default-jre curl jq
cd /tmp
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.9.2-amd64.deb
sudo dpkg -i elasticsearch-7.9.2-amd64.deb
