#!/bin/bash

name=$1
WEB_ROOT_DIR='/var/www/'
mkdir $WEB_ROOT_DIR$name
mkdir $WEB_ROOT_DIR$name/htdocs
mkdir $WEB_ROOT_DIR$name/logs
email=${2-'webmaster@localhost'}
sitesEnable='/etc/apache2/sites-enabled/'
sitesAvailable='/etc/apache2/sites-available/'
sitesAvailabledomain=$sitesAvailable$name.conf
echo "Creating a virtual host for\n $sitesAvailabledomain\n with a webroot\n $WEB_ROOT_DIR$name"

### create virtual host rules file
echo "<VirtualHost *:80>
  ServerName $name
  ServerAdmin $email
  DocumentRoot $WEB_ROOT_DIR$name/htdocs/
    <Directory $WEB_ROOT_DIR$name/htdocs/>
      Options Indexes FollowSymLinks MultiViews
      AllowOverride All
      Order allow,deny
      allow from all
    </Directory>
  ErrorLog $WEB_ROOT_DIR$name/logs/error_log
  CustomLog $WEB_ROOT_DIR$name/logs/access_log common
</VirtualHost>" > $sitesAvailabledomain
echo "\nNew Virtual Host Created\n"

sed -i "1s/^/127.0.0.1  $name\n/" /etc/hosts

a2ensite $name
service apache2 reload

echo "Done, please browse to http://$name to check!"


