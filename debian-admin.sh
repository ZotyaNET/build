#!/bin/bash

# WEBMIN & VIRTUALMIN
sudo sh -c "$(curl -fsSL https://software.virtualmin.com/gpl/scripts/virtualmin-install.sh) -- --bundle LAMP --hostname admin.44dev.com --minimal --verbose"

# PHP SOURCE
apt-get -y install apt-transport-https lsb-release ca-certificates curl
curl -sSL -o /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/sury-debian-php-$(lsb_release -sc).list'
apt-get update

# PHP VERSIONS
sudo apt-get install -y php7.4-{cgi,cli,fpm,pdo,gd,mbstring,mysqlnd,opcache,sqlite3,bcmath,curl,xml,zip,intl}
sudo apt-get install -y php8.0-{cgi,cli,fpm,pdo,gd,mbstring,mysqlnd,opcache,sqlite3,bcmath,curl,xml,zip,intl}
sudo apt-get install -y php8.1-{cgi,cli,fpm,pdo,gd,mbstring,mysqlnd,opcache,sqlite3,bcmath,curl,xml,zip,intl}
apt-get install -y php8.2-{cgi,cli,fpm,pdo,gd,mbstring,mysqlnd,opcache,sqlite3,bcmath,curl,xml,zip,intl}
apt-get install -y php8.3-{cgi,cli,fpm,pdo,gd,mbstring,mysqlnd,opcache,sqlite3,bcmath,curl,xml,zip,intl}

# INSTALLATRON
wget https://data.installatron.com/installatron-plugin.sh
chmod +x installatron-plugin.sh
./installatron-plugin.sh -f
/usr/local/installatron/installatron --convert
