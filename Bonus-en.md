<h1 align=center>
	<b>Bonus Part</b>
</h1>

<p align=center>
	This is the implementation guide for the bonus part of the `born2beroot` project. In here, we will describe the implementation of a Wordpress site and a service of our choice in both the operating systems defined by the project. The bonus implementation of the other partitioning scheme was already explained during both the <a href="https://github.com/caroldaniel/42sp-cursus-born2beroot/blob/master/Debian-en.md">Debian</a> and the <a href="https://github.com/caroldaniel/42sp-cursus-born2beroot/blob/master/CentOS-en.md">CentOS</a> implementation guides, so you might want to check those out first. 
</p>

---
<h2 align=center> Index </h2>
<h3 align="center"><b>
	<a href="#WP">Wordpress</a>
	<span> • </span>
	<a href="#ltpd">Lighttpd</a>
	<span> • </span>
	<a href="#DB">MariaDB</a>
	<span> • </span>
	<a href="#PHP">PHP</a>
	<span> • </span>
	<a href="#Instr">Instructions</a>
	<span> • </span>
	<a href="#SELinux">Fail2ban</a>
	<span> • </span>
	<a href="#ref">References</a>
</b></h3>

---
<h2 id="WP">
	Wordpress
</h2>

**Wordpress** is a Content Manager System (CMS). In other words, it's an application that allows you to create blogs and websites, and was originally designed to be a simple, user-friendly platform so that anyone, anywhere, could create a functional website.

In this project, we will have to set up a Wordpress website so that our server works as host to it. We will need to set up `http`, `Database` and `PHP` services, and make sure the website or blog is completely functional. 

We will also need to deal with our firewall and MAC systems in order to allow communication through the correct ports. But first, let`s understand the services we will need to install beforehand. 

---
<h2 id="ltpd">
	Lighttpd
</h2>

**Lighttpd** is an open-source web server known for being fast, secure and optimized for less memory consumption than its pairs. 

To install `lighttpd` on your system, you first need to make sure your packages are all up-to-date. You will need root privileges for the entire process. 

In CentOS:
```sh
# dnf -y update
```
In Debian:
```sh
# apt update
```

For CentOS, you will need the `EPEL` repository in order to install lighttpd. You already downloaded it during the `UFW` installation, but if you need, here's the command one more time:
```sh
# dnf install epel-release -y
```

Now you can install lighttpd.

In CentOS:
```sh
# dnf install lighttpd
```
In Debian:
```sh
# apt install lighttpd
```

After installation is complete, you can use the following commands to start and enable lighttpd at startup. Don't forget to also check its status and current version. The output should appear like this on [CentOS](screenshots/40.png)
```sh
# systemctl start lighttpd
# systemctl enable lighttpd
# systemctl status lighttpd
# lighttpd -v
```

Now, you will need to allow HTTP traffic in you Firewall.
```sh
# ufw allow http
``` 
The default port for `http` traffic is `80`. Make sure it is already [included](screenshots/41.png) on your firewall settings. 
```sh
# ufw status
``` 
Now, if you're using CentOS, you must make sure SELinux is also permiting communication through port 80. To do so, check the HTTP ports and include 80 in your allowed list if its not already there (by default it usually is) by the following commands:
```sh
# semanage port -l | grep http
# semanage port -a -t http_port_t -p tcp 80
```

---
<h2 id="DB">
	MariaDB
</h2>

**MariaDB** is an open source database management system that is a sort-of replacement for the MySQL database tecnology, being very much compatible and even sharing some of its own commands. It is SQL based and completely free. 

To install `MariaDB` on your server, you must do the following steps:

In CentOS:
```sh
# dnf install mariadb-server
```
In Debian:
```sh
# apt install mariadb-server
```

Same thing as done in `lighttpd`, you must make sure to start and enable `MariaDB` on startup:
```sh
# systemctl start mariadb
# systemctl enable mariadb
# systemctl status mariadb
```

Then, you should make sure tu secure MariaDB server with the following command:

```sh
# mysql_secure_installation
```
You should configure your MariaDB like [this](screenshots/42.png) and [this](screenshots/43.png): 

```sh
# Enter current password for root (enter for none): Enter
# Set root password? [Y/n]: Y
# New password: Enter password
# Re-enter new password: Repeat password
# Remove anonymous users? [Y/n]: Y
# Disallow root login remotely? [Y/n]: Y
# Remove test database and access to it? [Y/n]:  Y
# Reload privilege tables now? [Y/n]:  Y
```

Then, you must restart `MariaDB` service:
```sh
# systemctl restart mariadb
```

Now you already have a database management system intalled and ready to go on your server.

---
<h2 id="DB">
	PHP
</h2>

---
<h2 id="ref">
	References
</h2>

<p><a href="https://wordpress.com/"><i><b>Wordpress Website</b></i></a></p>
<p><a href="https://www.lighttpd.net/"><i><b>Lighttpd Website</b></i></a></p>
<p><a href="https://mariadb.org/"><i><b>MariaDB Website</b></i></a></p>
<p><a href="https://www.osradar.com/install-wordpress-with-lighttpd-debian-10/"><i><b>How to install WordPress with lighttpd on Debian 10?</b></i></a></p>
<p><a href="https://www.tecmint.com/install-lighttpd-with-php-fpm-mariadb-on-centos/"><i><b>How to Install Lighttpd with PHP and MariaDB on CentOS/RHEL 8/7</b></i></a></p>