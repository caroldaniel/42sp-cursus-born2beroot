<h1 align=center>
	<b>Debian 11</b>
</h1>

<p align=center>
	This implementation guide was made in collaboration with <a href="https://github.com/HCastanha">@HCastanha</a>, who indeed chose <b>Debian</b> as the OS to implement this project (I just tagged along for the fun). 
</p>
<p align=center>
    <b>Debian</b> is a GNU/Linux distribution composed interely of free and open-source software. It is also one of the oldest operating systems based on the Linux Kernel. Debian is the basis for many other distros, being the most popular one <i>Ubuntu</i>. 
</p>
<p align=center>
    Debian has one of the most active communities online, what can be very helpful when you are searching for error fixes and bugs in open forums. Debian is also updated a lot more frequently, what can be a downside if you're looking for stability, but also represents packages less prone to contain bugs. 
</p>
<p align=center>
    Overall, Debian is a stable enough system to operate smaller servers, and it's a lot more user-friendly than its pairs. It is a very good system to learn the basics on how to deal with servers and its utilities - what is, at the end, the whole purpose of this project. 
</p>

---
<h2 align=center> Index </h2>
<h3 align="center"><b>
	<a href="#Install">Installing</a>
	<span> • </span>
	<a href="#LVM">LVM</a>
	<span> • </span>
	<a href="#LogIn">Logging in</a>
	<span> • </span>
	<a href="#PacMan">Package Management</a>
	<span> • </span>
	<a href="#App">AppArmor</a>
	<span> • </span>
	<a href="#UFW">UFW</a>
	<span> • </span>
	<a href="#SSH">SSH</a>
	<span> • </span>
	<a href="#TestSSH">Testing the SSH connection</a>
	<span> • </span>
	<a href="#SUDO">SUDO</a>
	<span> • </span>
	<a href="#Passwd">Password Policy</a>
	<span> • </span>
	<a href="#Host">Hostname, Users and Groups</a>
	<span> • </span>
	<a href="#Script">Monitoring Script</a>
	<span> • </span>
	<a href="#Bonus">Bonus</a>
</b></h3>

---

<h2 id="PreReq">
Pre-Requisites
</h2>

<p> The project will be run entirely on a Virtual Machine, so the initial setup consists of only two downloadables:

- The latest available <a href="https://www.virtualbox.org/">Oracle VIrtualBox</a> (VirtualBox 6.1 was the one used at the time of this project);
- The <a href="https://www.debian.org/download">Debian 11</a> ISO.
</p>

---
<h2 id="Install">
Installing
</h2>

1. Open `VirtualBox` and [click 'New'](screenshots/d00.png);
2. Initial set up of the Virtual Machine includes [memory](screenshots/d01.png) and [hard disk](screenshots/d02.png) specifications (since I did the bonus part, the hard drive allocation was of 30.8Gb instead of 8Gb);
3. After creating the VM, [click on 'Settings'](screenshots/d03.png) and [enable your network](screenshots/d04.png) with 'Bridge Adapter', so that your Virtual Machine will be able to use your local internet settings; 
4. [Start](screenshots/d05.png) your machine and when prompted, choose the previously downloaded `.iso` file as a [start-up disk](screenshots/d06.png) to boot;
5. When loaded, you will be asked to choose among a few options, including "Graphical install" or just "Install". They are virtually the same, so whatever you choose shouldn't impact too much for you to follow along. I [chose "Install"](screenshots/d07.png).
6. On the chosen interface, set-up your machine as required:
> - Choose a [language](screenshots/d08.png) that is better suited for your needs (I chose *English* as default);
> - **Location** must be set accordinly to your current location. I chose ['other'](screenshots/d09.png) >['South America'](screenshots/d10.png)>['Brazil'](screenshots/d11.png)  and then you must choose your "locale configuration" (aka keyboard language) (mine is ['en_US.UTF-8'](screenshots/d12.png)>['American English'](screenshots/d13.png));
> - **Configure the network** by [setting you hostname](screenshots/d14.png) according to the especifications (`intralogin+42`). At this part, your hostname can be any of your choice, since you'll be asked to modify it by command-line once the installation is complete). Your [domain name](screenshots/d15.png) will be automatically generated if you just hit continue on the next step;
> - **Set up users ans passwords** by choosing a strong [Root Password](screenshots/d16.png) (again, this password will be changed during the project). You can already configure a user by typing your [fullname](screenshots/d17.png) and your [intra login](screenshots/d18.png) if you want, but this step can be done once you boot your new machine; 
> - [**Configure the clock*](screenshots/d19.png)* by choosing your current location;
> - You must correctly set-up partitions choosing [Manual](screenshots/d20.png) configuration, according to specific instructions (at this point, you can choose to create the Mandatory part's partitioning, or the Bonus part's one. I chose the Bonus one). Once you [choose the hard drive](screenshots/d21.png) to partition and click **yes**. Now you must [choose your available free space](screenshots/d22.png) to start partitioning. GO on [Create new partition](screenshots/d23.png) for `\boot` with the specified size. Choose [primary](screenshots/d24.png)(this is a Standard Partition) at the [beggining](screenshots/d25.png) of the available space. At the end, your `sda1` must look like something like [this](screenshots/d26.png);
> - To set up the Logical Volumes you need to undestand the basics of what a LVM really is (see below for more on LVM). You will choose the next available free space and configure it as a ['physical volume for encryption'](screenshots/d27.png). Then, you must choose to ['configure encrypted volumes'](screenshots/d28.png)>['created encrypted volumes'](screenshots/d29.png)>['choose volumes to encrypt'](screenshots/d30.png)>['finish'](screenshots/d31.png) so that the partition will be [overwritten with random data](screenshots/d32.png). When it is done, you will be asked to [type in the passphrase](screenshots/d33.png) to protect your ENcrypted Disk;
> - After encrypting the partition, you will have to declare it a Volume Group by going to ['Configure the Logical Volume Manager'](screenshots/d34.png), then [write the changes on disk](screenshots/d35.png), [create a Logical Group](screenshots/d36.png), [name it](screenshots/d37.png), [select the partition to do it](screenshots/d38.png) and finally [create the Logical Volumes](screenshots/d39.png) one by one by [giving it a name](screenshots/d40.png), [set its size](screenshots/d41.png) and create them with the specifications declared on the project. At the end, you can [display](screenshots/d42.png) the volumes created (mine showed something like [this](screenshots/d43.png)). I use `ext4` as a filesystem to the Logical Volumes in this part. Click on ['Finish'](screenshots/d44.png). At last, don't forget to mount the volumes by [clicking](screenshots/d45.png) on each of them and choosing a correct [mount point](screenshots/d46.png) before [finishing the partitioning](screenshots/d47.png). The overview should look like [this](screenshots/d48.png);
> - Now you make sure to be scanning for new packages and to set your location correctly to configure the `apt` package manager (this is Debian's default, but you can change it for appititude later if you wish);
> - In the next step you must make sure you are [not installing any graphical interface](screenshots/d49.png) to your Debian OS. Since our goal is to set up a server, GUIs are explicitily forbidden and are, altogether, very much dispensable;
> - [Install the GRUB boot loader](screenshots/d51.png) and, when that's done, finally reboot your new system so you're now all set!

<h3>
TIP
</h3>
If might have come to your attention that, when partitioning the hard drives, there might be some inconsistency regarding the total number of GB available. If you've set, at the initial VM set up, a total drive of 30.8GB and now it appears to you as though you have a 33.1GB of available disk space, or even if you're typing 500MB, but the system only reserves 467MB or something: fear not, 'cause you're not alone.

My best guess is that it happens because of a malfunction conversion of the Debian installer itself. You see, 1 kylobyte equals to 1024 bytes, not 1000. If you project that to Megas or even Gigas, it's a lot of bytes you're simply not counting. That's what Debian's installer is doing.

To be very practical, it matters not in your day-to-day life either you're converting bytes by the 1000s or 1024s. But, since the project's specifications were very precise, I decided to follow along and convert everything to **real bytes** before typing them down on the partioning menu (for example, 500 MegaBytes turned into 524288000 Bytes. A lot of numbers in this one, I know, but Excel is your friend). 

However, whether you do that in your own project is completely up to you!

---
<h2 id="LVM">
LVM
</h2>

**Logical Volume Manager** is a system of mapping and managing hard disk memory used on Linux-kernel's based systems. Instead of the old method of partitioning disks on a single filesystem, and having it be limited to only 4 partitions, LVM allows you to work with "Logical Volumes", a more dinamically and flexible way to deal with your hardware.

There are three major concepts you must understand to fully grasp the behaviour of LVM:
- **Volume Group**: It is a named collection of physical and logical volumes. Typical systems only need one Volume Group to contain all of the physical and logical volumes on the system;
- **Physical Volumes**: They correspond to disks; they are block devices that provide the space to store logical volumes;
- **Logical Volumes**: They correspond to partitions: they hold a filesystem. Unlike partitions though, logical volumes get names rather than numbers, they can span across multiple disks, and do not have to be physically contiguous.

The idea sounds simple enough: You take a disk, declare it as a *Physical Volume*, then you take that volume and append it to the *Volume Group* of your choice (usually only one per computer). At last, you may "partition" that volume into small *Logical Volumes* that can correspond to 1 or multiple disks, and can be reallocated in memory even if they are already in use. 

LVM is a great utility to have on servers and systems that demand usage stability and great necessity of quick management of the available physical devices (it makes it way easier to add or remove memory, for instance).

---
<h2 id="LogIn">
Logging in
</h2>

Once the installation has completed, and you've rebooted your system you must log into the OS. 

The first step is to [type in the password](screenshots/d52.png) you used to encrypt your `LVM` partitions. Then, you must [choose a user to log-in](screenshots/d53.png) to. I recommend using the `root` for now, as we still need to have root privileges to completely finish the set-up. 

Once you're logged in, use the following commands to check if everything is according to the plan: 

- `cat /etc/os-release` - see [information](screenshots/d54.png) on the system installed;
- `lsblk` - see the [partitioning](screenshots/d55.png)'s scheme.

Some importante commands to keep in hand: 

- `logout` or `exit` - exit current session to enable you to change the active user;
- `reboot` - reboot the system (needs root permission);
- `poweroff` - turns the system off (needs root permission).

---
<h2 id="PackMan">
	<b>Package Management</b>
</h2>

Debian based systems, by default, use `APT` (Advanced Package Tool) and `DPKG` package management tools. While `DPKG` is a low level package manager, used to install, remove and provide information about `.deb` packages, `APT` is more high leveled, working its way through complex package relations, such as dependency resolution. 

For Debian, `APT` is the most common and most used package manager. It comes installed by default and provides command-line management for all the packages you might need on your computer in a resonably user-friendly way, with shorter and more intuitive commands.

It is also preferable, for some users, to use the `Aptitude` package manager. `Aptitude` is a front-end alternative to `APT`. It allows the user to interactively pick the packages they want to install or remove, apart from also allowing flexible search patterns, such as commands and/or close-typed words. 

For this project, one would be wise to work with `APT` as it is more scriptable and replicable, which makes a good choice for writing documentation (including this one). It is to my understading that `APT` can handle most of `Aptitude`'s functions through certain in-line commands (althought in not such an user-friendly and graphical way). 

However, I will choose `Aptitude` for pedagogical purposes and for the fact that it has more elaborate algorithms when trying to handle difficult situations. Aptitude is a great alternative to `APT`. 

Since `Aptitude` doesn't come installed in Debian, you will need to install it.

```sh
# apt-get install aptitude
```
After the installation is completed, type `aptitude` to [open aptitude front-end](screenshots/d56.png). From here forward, we'll use `aptitude` to manage the packages needed. 

<h2 id="App">
	<b>AppArmor</b>
</h2>

Mandatory Access Control (or MAC) is a security protocol that forbids any certain program, even one running on effective superuser privileges, to do anything other than what it was previously allowed to do. It is a secure measure used, mainly, in systems where stability and protection are paramount concepts (such as server units). 

To enforce MAC, we can use a variety of programs. For Debian and all its similar systems, the default option is `AppArmor`. It enforces protection over objects as per configuration. That means, the application "imunizes" other apps one by one. By default, something that has not been previously set as "protected" is, by all means, vulnerable. 

AppArmor might not be considered as efficient and secure as `SELinux`, for example, but it has an easier interface and is more user-friendly. For someone who is not all-accostumed to system administration, it becomes a great alternative for managing access control. 

To make sure `AppArmor` is installed, use:
```sh
# aptitude search apparmor
```
If by any reason it is not installed, you must install it first and enable it at startup:

```sh
# aptitude install apparmor
# aa-status 
# systemctl enable apparmor
```
---
<h2 id="UFW">
	<b>UFW</b>
</h2>

`UFW` (or "Uncomplicated Firewall") is a program designed, as the name suggests, to be an easy-to-use firewall manager. 'Firewall', in turn, is a security device responsable for monitoring the information and data traffic from your local computer to the network. 

As per the instructions, `UFW` will have to be installed on our machine and configured in a way that will only allow connection to port 4242. 

`UFW` needs to installed and then enabled:
```sh
# aptitude install ufw
# ufw enable
```

To check the `UFW` current status and ports allowed or denied, use:
```sh
# ufw status verbose
```

You will see that the 'outgoing' rule is set to `allow`. Do not change that, otherwise the package manager and other essencial applications will stop working. 
The subject only allows for port 4242 to be enabled, so what you can do is deny all ports available and allow only 4242. The following commands may help you with this:
```sh
# ufw default allow/deny incoming
# ufw default allow/deny outgoing
# ufw allow/deny <port-number>
```
However, if you only `deny` a port, it will keep appearing on the rules as "DENY" status. To delete it completely, use:
```sh
# ufw status numbered
# ufw delete <rule-number>
```

Do not forget to **enable your firewall on startup**. 
```sh
# systemctl enable ufw
```
To eventually disable the firewall, use:
```sh
# ufw disable
```
---
<h2 id="SSH">
	<b>SSH</b>
</h2>

**Secure Socket Shell** is a network protocol that gives users, particularly system administrators, a secure way to access a computer over an unsecured network. It provides users with a strong password authentication as well as a public key authentication. It attempts to safely communicate encrypted data over two computers using an open network. 

In order to install or update the SSH server and client, use: 
```sh
# aptitude install openssh-server openssh-client
```
In order to check if the ssh service is running, use:
```sh
# systemctl status sshd
```
To start or stop the service use:
```sh
# systemctl start/stop sshd
```
To enable it on boot (**very important**), use:
```sh
# systemctl enable sshd
```

In order to change the default SSH port, you need to [edit](screenshots/d57.png) the `/etc/ssh/sshd_config` so that you deny access from root and the default port becomes 4242. Use a text editor of your choice. I chose vim (you may need to install it by using `aptitude install vim` on the command line). 
```sh
# vim /etc/ssh/sshd_config
```
After you edit the configuration file, restart your sshd service.
```sh
# systemctl restart sshd
```
Now you must make sure that your `SSH` connection is the only socket available on your server. A `socket` is a logical endpoint for communication. They exist on the transport layer. You can send and receive things on a socket, you can bind and listen to a socket. A socket is specific to a protocol, machine, and port, and is addressed as such in the header of a packet. To ckeck your socket status, use:

```sh
# ss -tunlp
```

<h3>
IMPORTANT
</h3>

In some computers, it is possible that your own internet connection is being classified as `socket`, and is beeing listed as such like in the following [example](screenshots/d58.png). 

To try and mitigate this, so that only SSH is being used as a valid socket, you should set your Machine IP as **static**. To do so, install `net-tools` in your machine, in order to adquire the `ifconfig` command. You will need it to easily [extract some information](screenshots/d59.png) about your machine: your `network interface`, you `IP address`, your `netmask` and your `gateway`.  

```sh
# aptitude install net-tools
# ifconfig -a
# route -n
```

Now, edit the file `/etc/network/interfaces`so it looks like [this](screeshots/d60.png).

Now, list the sockets available again.

```sh
# ss -tunlp
```

At the end, your socket list should look like something like [this](screenshots/d61.png).

---
<h2 id="TestSSH">
	<b>Testing the SSH connection</b>
</h2>

You can easily test if your SSH conection is properly working by attempting to connect to your VM using another computer's terminal. On Linux's distros, WSL or MacOS it is available by default. On Windows your have to install `PuTTY`.

To connect remotely to your server use: 
```sh
# ssh <server-user>@<server's IP number> -p <ssh-port>
```
 To check your server's IP number, use the command `ip addr show` as [this](screenshots/d62.png)

 In my server, the command was written as followed:
> ```sh
> # ssh hcastanh@192.168.15.121 -p 4242
> ```

However this command only works if both computers are logged into the same local network. You may test this in your own computer. There are no root access in this method, my security reasons. 

You may also send files through SSH using the following command: 
```sh
# scp -P <ssh-port> <filename> <server-user>@<server's IP number>:<newfilepath>
```

To leave SSH connection use: 
- `logout`
- `exit`

---
<h2 id="SUDO">
	<b>SUDO</b>
</h2>

Check if you already have `sudo` on your system:

```sh
# sudo --version
```
In case you don't, install it. You will need root privileges:

```sh
# aptitude install sudo
```

You will first need to configure some rules for the sudo group. There are many ways to do it: 

- Edit the `/etc/sudoers` file using text editors such as `vim` or `nano` (you will need to install them beforehand),
- Use the `visudo` command (which will open the same `/etc/sudoers` file) on a preeinstalled `vim` or
- Include a new file with the new specific rules asked on `/etc/sudoers.d` (that is later automatically scanned and included on `/etc/sudoers`). 

For organizational purposes, I chose the latter. However, some adjustments were necessary before. First, we need to create the `/var/log/sudo/` directory:

```sh
# mkdir /var/log/sudo
```
Then, we need to comment the line on `/etc/sudoers` that holds the information on the `secure_path` which we will be reassigning on the new file. 

To configure the new sudo rules, I used the following command on root permition:

```sh
# visudo -f /etc/sudoers.d/sudoers-specs 
```

On the `vim` interface in the new file, [the rules were added](screenshots/d63.png).

To check all users on the system, use: 

```sh
# less /etc/passwd
```

Each line in the file has seven fields delimited by colons that contain the following information:

> - User name;
> - Encrypted password (x means that the password is stored in the /etc/shadow file);
> - User ID number (UID);
> - User’s group ID number (GID);
> - Full name of the user;
> - User home directory;
> - Login shell.

To check all groups on the system, and its users, use: 

```sh
# less /etc/group
```

In order to add a user to the `sudo`group you must use the command `gpasswd -a <username> sudo`. To remove them we use the `-d` flag instead of `-a`. To move the previously created user made on installation with the intra login, I used: 

```sh
# gpasswd -a hcastanh sudo
```

You also have to make sure the line on `/etc/sudoers` that says `%sudo ALL=(ALL:ALL) ALL` is uncommented. After aplying the changes, you may need to reboot your system. 

Alternatively, to check all groups a certain member is, you may use:
```sh
# groups <username>
```

---
<h2 id="Passwd">
	<b>Password Policy</b>
</h2>

We must apply a strong password policy for all users, root included, that must be set to this:
> 1. Your password has to expire every 30 days.
> 2. The minimum number of days allowed before the modification of a password will be set to 2.
> 3. The user has to receive a warning message 7 days before their password expires.
> 4. Your password must be at least 10 characters long. 
> 5. It must contain an uppercase letter and a number. Also, it must not contain more than 3 consecutive identical characters.
> 6. The password must not include the name of the user.
> 7. The following rule does not apply to the root password **by default**: The password must have at least 7 characters that are not part of the former password.

The first 4 rules must be set by editing `/etc/login.defs`. The final result should look like [this](screenshots/d64.png).

For the users already created (root included) these optons will not be automatically enabled. You will have to enforce them by using the `chage` command and manually apply the rules above. You can use the flag `-l` to list the rules applied to a specific user.
```sh
# chage -M 30 <username/root>
# chage -m 2 <username/root>
# chage -W 7 <username/root>
# chage -l <username/root>
```

The last 3 rules can be applied by using a package called `pam-pwquality`. To download it use: 
```sh
# aptitude install libpam-pwquality
```
To apply these rules, you shoud edit `etc/security/pwquality.conf` by uncommenting and changing the following lines: 

```sh
# Number of characters in the new password that must not be present in the 
# old password.
difok = 7
# The minimum acceptable size for the new password (plus one if 
# credits are not disabled which is the default)
minlen = 10
# The maximum credit for having digits in the new password. If less than 0 
# it is the minimun number of digits in the new password.
dcredit = -1
# The maximum credit for having uppercase characters in the new password. 
# If less than 0 it is the minimun number of uppercase characters in the new 
# password.
ucredit = -1
# The maximum number of allowed consecutive same characters in the new password.
# The check is disabled if the value is 0.
maxrepeat = 3
# Whether to check it it contains the user name in some form.
# The check is disabled if the value is 0.
usercheck = 1
# Prompt user at most N times before returning with error. The default is 1.
retry = 3
# Enforces pwquality checks on the root user password.
# Enabled if the option is present.
enforce_for_root
```

Then you will need to set new passwords for the users already created (root included), following the new password policy:
```sh
# passwd <username>
```
In my server, I used:
- For **root**: `Ell4F1tzgerald`.
- For **hcastanh**: `Lou1s4rmstrong`.

---
<h2 id="Host">
	<b>Hostname, Users and Groups</b>
</h2>

You must be able to change, on demand, the `hostname` on you computer. For this project, the hostname must be your **intra login + 42**. It was already set upon installation, but the commands you must use to do this by command line are:

- `hostnamectl status` - show current host information;
- `hostnamectl set-hostname <new-hostname>` - change hostname on command line.

You can also change your hostname by editing `/etc/hostname`. 

On boot, you must have at least root and personal users available. The personal user must be your **intra login**. 
To be evaluated, you must be able to show all users on your computer, add or remove users on command, change username, add users to groups or change the user's main group name. Here are some commands to help you do that: 
- `less /etc/passwd | cut -d ":" -f 1` - show list of all users on computer;
- `users` - show list of all users who are currently logged in;
- `useradd <username>` - create new user with home directory;
- `usermod <username>` - modify users settings, `-l` for username, `-c` for comments/Full Name and `-g` for GID;
- `userdel -r <username>` - deletes user and all files attached to it;
- `id -u <username>` - shows user's UID.

Your intra login user must be on `wheel`(`sudo`) and `user42` groups. To ensure that happens, you can use some of the following commands:

- `less /etc/group | cut -d ":" -f 1` - show list of all users on computer;
- `groups <username>` - shows user's groups;
- `groupadd <groupname>` - create new group;
- `groupdel <groupname>` - delete group;
- `gpasswd -a <username> <groupname>` - adds user to group;
- `gpasswd -d <username> <groupname>` - removes user from group;
- `getent group <groupname>` - show users in group;
- `id -g <username>` - show user's main group GID.

---
<h2 id="Script">
	<b>Monitoring Script</b>
</h2>

It is mandatory to, at server startup, for a script to be displayed every 10 minutes to all terminals with some important information on the server's status. This information is listed below: 
> - The architecture of your operating system and its kernel version;
> - The number of physical processors;
> - The number of virtual processors;
> - The current available RAM on your server and its utilization rate as a percentage;
> - The current available memory on your server and its utilization rate as a percentage;
> - The current utilization rate of your processors as a percentage;
> - The date and time of the last reboot;
> - Whether LVM is active or not;
> - The number of active connections;
> - The number of users using the server;
> - The IPv4 address of your server and its MAC (Media Access Control) address;
> - The number of commands executed with the sudo program.

You must write your script on a file called [`monitoring.sh`](https://github.com/caroldaniel/42sp-cursus-born2beroot/blob/5397a3faa91f689bd956d2b656ccea8d2b199412/script/monitoring.sh), and it **must** have execution rights (I chose to `chmod 755`).

To run the script as demanded, we must first understand two very important concepts: 

<h3>
WALL
</h3>

**Wall** is a command that allows you to write a message to all users, in all terminals. It can receive either a text (it broadcasts message like `echo`) or a file content (like `cat`). 

By default, `wall` broadcasts message with a banner on top. For this project, the banner is optional.

To use **wall** you have two options:

- `wall <"message">`
- `wall -n <"message">` - displays with no banner

<h3>
CRON
</h3>

**Cron** is a service that runs on the backgroud and lauches configured tasks on a schedule. Cron is present on Debian by default. To check its version or even, by some reason, eventually install it, use: 
```sh
# aptitude install cron
```

Now, let's make sure it is running at startup:
```sh
# systemctl enable crond
```
You can also `disable`, `start`, `stop` and `restart` this service at your will.

Cron uses `crontab` files to schedule given tasks. To manage those tasks and its frequency of execution, run: 
```sh
# crontab -e
```
It will create your own crontab (each user has one - or many). You can edit to your own like, following the syntax shown [here](screenshots/d65.png). 

The task specified (in my case `bash /root/scripts/monitoring.sh | wall`) will be executed on a step of every 10 (`*/10`) minutes (first column). However, according to the projects specifications, the script must run from the server **startup**. To do so, I added [`sleep.sh`](https://github.com/caroldaniel/42sp-cursus-born2beroot/blob/cfe26f86e79f43340f18544342e61b246247232c/script/sleep.sh) on my crontab. 

Some useful cron commands:
- `crontab -l` - display the current cron settings
- `crontab -u <username> -l` - display the current cron settings of a specific user
- `crontab -u <username> -e` - edit the cron settings of a specific user

---
<h2 id="Bonus">
	<b>Bonus</b>
</h2>

The **bonus** part implementation can be seen [here](Bonus-en.md). It is, however, completely optional. To complete the mandatory part, however, this is all you need to know about CentOS. The end product up until this point should be the following:

- [System basic requirements](screenshots/d66.png)
- [Monitoring Script](screenshots/d67.png)

---
<h2 id="sub">
	<b>Submission</b>
</h2>

In order to submit this project, we need to extract an [`signature.txt`]() file from your Virtual Machine. To do so, go to you `Virtual Box VMs` folder in you local computer and use the following command: 

- **Windows**: certUtil -hashfile centos_serv.vdi sha1
- **Linux**: sha1sum centos_serv.vdi
- **For Mac M1**: shasum Centos.utm/Images/disk-0.qcow2
- **MacOS**: shasum centos_serv.vdi

`centos_serv` being your active Virtual Machine. 

---
<h2>
	<b>References</b>
</h2>
<p><a href="https://www.debian.org/intro/why_debian"><i><b>Why Debian?</b></i></a></p>
