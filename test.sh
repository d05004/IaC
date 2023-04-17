#!/bin/sh

echo "script start" >> /tmp/result
apt-get update -y
apt-get install apache2
echo "script end" >> /tmp/result


