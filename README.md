# Jona WiFi

## Packages

* apache2
* php (libapache2-mod-php, php-mysql, php-mcrypt, php-gd, php-pear)
* mysql-server (freeradius-mysql)
* phpmyadmin
* hostapd
* dnsmasq
* freeradius
* iptables-persistent
 
## Installation
```
sudo apt update

sudo apt upgrade

sudo apt install -y \
	apache2 php libapache2-mod-php \
	php-mcrypt php-gd php-pear \
	mysql-server php-mysql \
	dnsmasq hostapd \
	freeradius freeradius-mysql \
	iptables-persistent git \
```

```
git clone https://github.com/technopreneural/jonawifi.git
```

```
curl -O http://https://nchc.dl.sourceforge.net/project/daloradius/daloradius/daloradius0.9-9/daloradius-0.9-9.tar.gz

tar -xvf daloradius-0.9-9.tar.gz

ln -s daloradius-0.9-9 /var/www/html/daloradius
```

## Initial Configuration

### Apache2

* Edit **/etc/apache2/sites-available/default-ssl.conf**

```
sudo a2ensite default-ssl
```

### MySQL

```
sudo mysql_secure_installation
```

```
Change password for root (Y/n) : Y
```
```
Remove miscellaneous users (Y/n) : Y
```
```
Remove example databases (Y/n) : Y
```

### Freeradius

* Test installation for authentication failure

```
radtest bob hello localhost 0 testing123
```

```
ACCESS-REJECT
```

* Add a test user

```
sudo mkdir /etc/freeradius/3.0/orig

sudo cp * /etc/freeradius/3.0/orig

sudo cat "bob ClearText-Password := 'hello'" > /etc/freeradius/3.0/users
```

* Test installation for authentication success
```
radtest bob hello localhost 0 testing123
```

```
ACCESS-ACCEPT
```


