#!/bin/bash 
set -e 

dnf upgrade -y 
dnf install httpd -y 
systemctl start httpd 
systemctl enable httpd 
echo "<h1> Hello Felix, this is my server</h1>" | tee /var/www/html/index.html