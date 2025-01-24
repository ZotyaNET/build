#!/bin/bash

sudo apt-get update
sudo apt-get install g++
sudo apt-get install snap
sudo snap isntall snapd
sudo snap install tabula

# unzip -p dbdump.sql.zip | mysql -u root -p yourdbname
