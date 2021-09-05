<h1 align=center>
	<b>CentOS Linux 8</b>
</h1>

<p align=center>
	As part of the challenge of setting up a functional server, I chose <b>CentOS Linux 8</b> to work with in this project.
</p>
<p align=center>
    <b>CentOS</b> (Community Enterprise Operating System) is a free, open source GNU/Linux distribution. It is functionally compatible and derived from RHEL (Red Hat Enterprise Linux), its subscription-paid twin.
</p>
<p align=center>
    The choice for CentOS comes from a very practical and straightforward curiosity: it is enterprise-focused and one of the most popular distros used for large-scale and modern business environments.
</p>
<p align=center>
    Even though CentOS was discontinued for new releases and support as of December 2021, RHEL is still largely used in many environments, and will most likely continue to be so for the nearby future. CentOS and RHEL, being virtually the same system, require the same basic knowledge to be set, making a CentOS project still one of great value.
</p>
<p align=center>
    Apart from that, CentOS is a very stable OS, receiving very few and largely sparse upgrades, which turns it into the most likely system to be used as a real server elsewhere. It was made for enterprises, and for the purpose of this project, just makes a lot more sense. 
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
	<a href="#SELinux">SELinux</a>
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
	<span> • </span>
	<a href="#ref">References</a>
	<span> • </span>
	<a href="#sub">Submission</a>
</b></h3>

---

<h2 id="PreReq">
Pre-Requisites
</h2>

<p> The project will be run entirely on a Virtual Machine, so the initial setup consists of only two downloadables:

- The latest available <a href="https://www.virtualbox.org/">Oracle VIrtualBox</a> (VirtualBox 6.1 was the one used at the time of this project);
- The <a href="https://www.centos.org/download/">CentOS Linux 8</a> DVD ISO.
</p>

---
<h2 id="Install">
Installing
</h2>

1. Open `VirtualBox` and [click 'New'](screenshots/00.png);
2. Initial set up of the Virtual Machine includes [memory](screenshots/01.png) and [hard disk](screenshots/02.png) specifications (since I did the bonus part, the hard drive allocation was of 30.8Gb instead of 8Gb);
3. After creating the VM, [click on 'Settings'](screenshots/03.png) and [enable your network](screenshots/04.png) with 'Bridge Adapter', so that your Virtual Machine will be able to use your local internet settings; 
4. [Start](screenshots/05.png) your machine and when prompted, choose the previously downloaded `.iso` file as a [start-up disk](screenshots/06.png) to boot;
5. When loaded, choose [Install CentOS Linux 8](screenshots/07.png) (no need to test the media beforehand) and wait for the graphical installer to appear;
6. On the graphical interface, set-up your machine as required:
> - Choose a [language](screenshots/08.png) that is better suited for your needs (I chose *English* as default);
> - [Time and date](screenshots/09.png) must be set accordinly to your current location;
> - [Software Selection](screenshots/10.png) has to be set for 'Minimal Install'. Since our goal is to set up a server, GUIs are explicitily forbidden and are, altogether, very much dispensable;
> - [KDump](screenshots/11.png) should be set to 'disabled'. Since CentOS installation was already considered complex enough, this setting was flagged as optional;
> - [Network and hostname](screenshots/12.png) should be set as per the original instructions: your `hostname` should be your `intralogin+42` and you should make sure the internet is enabled (at this point, your hostname can be any of your choice, since you'll be asked to modify it by command-line once the installation is complete).
> - Set a strong [Root Password](screenshots/14.png) of at least 20 characters (again, this password will be changed during the project);
> - You can already [configure a user](screenshots/15.png) with your intra login if you want, but this step can be done once you boot your new machine; 
> - At last, you must correctly [set-up partitions](screenshots/17.png) according to specific instructions (at this point, you can choose to create the Mandatory part's partitioning, or the Bonus part's one. I chose the Bonus one). Once you [choose the hard drive](screenshots/13.png) to partition, you must define a `custom` configuration. Pay attention to the fact that `sda1` is a `Standard Partition` while all the others are `LVM` (see below for more on 'Logical Volume Manager'). For the LVM partitions, they must all be located under an [Encrypted Volume Group](screenshots/16.png) as per the example, and you must choose a password for it (For the love of God, do no forget it!). It is important to notice as well that, for the `\boot` partition, I chose to use `ext2` file system, and for everything else, `ext4`, as of beeing more well-known and stable formats for those categories, and preferable since we will be setting up SELinux. 
> At the end, your graphical set-up manager should look like something like [this](screenshots/18.png). Click on `Begin Installation` and you're all set.  

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

Once the installation has completed, you must reboot your system and log into the OS. 

The first step is to [type in the password](screenshots/21.png) you used to encrypt your `LVM` partitions. Then, you must [choose a user to log-in](screenshots/22.png) to. I recommend using the `root` for now, as we still need to have root privileges to completely finish the set-up. 

Once you're logged in, use the following commands to check if everything is according to the plan: 

- `cat /etc/os-release` - see [information](screenshots/20.png) on the system installed;
- `lsblk` - see the [partitioning](screenshots/19.png)'s scheme.

Some importante commands to keep in hand: 

- `logout` or `exit` - exit current session to enable you to change the active user;
- `reboot` - reboot the system (needs root permission);
- `poweroff` - turns the system off (needs root permission).

---
<h2 id="PackMan">
	<b>Package Management</b>
</h2>

Up until a while ago, `YUM` (Yellowdog Updater, Modified) was the official high-level package manager for `RPM` (Red Hat Package Manager) based Linux distros (such as Fedora and RHEL).

Now, as of `CentOS Linux 8` distro and all its upstreams, `DNF` (Dandified YUM) became the new, upgraded and stable package manager, correcting some of its predecessors faults and errors, and presenting a better dependency management, better perfomance and better memory consumption.

Now, on your terminal window, [make sure](screenshots/23.png) that you have `DNF` installed and up-to-date. 

- `dnf --version` - to check its current installed version.

---
<h2 id="SELinux">
	<b>SELinux</b>
</h2>

Mandatory Access Control (or MAC) is a security protocol that forbids any certain program, even one running on effective superuser privileges, to do anything other than what it was previously allowed to do. It is a secure measure used, mainly, in systems where stability and protection are paramount concepts (such as server units). 

To enforce MAC, we can use a variety of programs. For Red Hat based systems, such as Fedora, RHEL and, of couse, our own CentOS, `SELinux` (Security Enhanced LInux) is the default, preinstalled option. It was developed by NSA and, even today, it is known to be one of the best, most strict and secure MAC systems evailable. Of course, it comes with a setback: `SELinux` is also known to be one of the most difficult MAC systems to configure and not very user-friendly.

Comparing `SELinux` with `AppArmor`, for instance, we can clearly see the difference. `AppArmor` enforces protection over objects as per configuration. That means, the application "imunizes" other apps one by one. By default, something that has not been previously set as "protected" is, by all means, vulnerable. 

`SELinux` on the other hand, has the opposite behaviour. It includes the whole system in its protocols, protecting any and everything that has not been set for anything other than its own specific functions. It uses a mechanism called "security label" or "security context" which classifies resources. It uses 4 different fields to effectively label and enforce security measures: user, role, type and level. These labels, on every single one of the applications available on the system, help the administrator to have complete control over any activity. 

`SELinux` is, by far, more secure and more complex than any of its pairs. It is the MAC system used for this activity and most likely the biggest challenge of this project. 

To ensure `SELinux` is running at startup, [check its status](screenshots/25.png) with the command bellow:

```sh
# sestatus
```
As the project evolves, `SELinux` will need to be slightly modified to fulfil our needs.

---
<h2 id="UFW">
	<b>UFW</b>
</h2>

`UFW` (or "Uncomplicated Firewall") is a program designed, as the name suggests, to be an easy-to-use firewall manager. 'Firewall', in turn, is a security device responsable for monitoring the information and data traffic from your local computer to the network. 

As per the instructions, `UFW` will have to be installed on our machine and configured in a way that will only allow connection to port 4242. 

`UFW` is not available on the CentOS repository. So, we need to install the `EPEL` repository on our server on root privileges:
```sh
# dnf install -y epel-release
```
Only then we will be able to install `UFW` and then enable it:
```sh
# dnf install ufw -y
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

TIP: It's important to restart your firewall at any port's changes or additions, in order to make sure the alterations will stuck.
```sh
# systemctl restart ufw
```

---
<h2 id="SSH">
	<b>SSH</b>
</h2>

**Secure Socket Shell** is a network protocol that gives users, particularly system administrators, a secure way to access a computer over an unsecured network. It provides users with a strong password authentication as well as a public key authentication. It attempts to safely communicate encrypted data over two computers using an open network. 

In order to install or update the SSH server and client, use: 
```sh
# dnf install openssh
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

In order to change the default SSH port, you need to [edit](screenshots/28.png) the `/etc/ssh/sshd_config` so that you deny access from root and the default port becomes 4242. Use a text editor of your choice. I chose vim (you may need to install it by using `dnf install vim` on the command line). 
```sh
# vim /etc/ssh/sshd_config
```
However, since we are alson using **SELinux**, some additional steps must be taken to guarantee the 4242 port is, in fact, opened to SSH. 
For the next steps, we will need to use `semanage` (SELinux Policy Management Tool), in order to configure some rules in the `SELinux` protocol.

First, you will need to install `semanage` by discovering which package provides you with it. Use:
```sh
# dnf whatprovides semanage
```
After the result [appear on screen](screenshots/26.png), install the demanded package:
```sh
# dnf install -y policycoreutils-python-utils
```
Then, run `semanage` to see its availability:
```sh
# semanage -h
```
After the installation, you must ensure SELinux is allowing port 4242 on its permitions. To do so check for the rules regarding `ssh_port_t`:
```sh
# semanage port -l | grep ssh
```
If rule 4242 is not set (port 22 was the only default), set it with the following command:
```sh
# semanage port -a -t ssh_port_t -p tcp 4242
```
When running `semanage port -l` command again, you will be able to [see port 4242](screenshots/27.png) correctly set up. 

After performing the changes, restart the SSH service.
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

In some computers, it is possible that your own internet connection is being classified as `socket`, and is beeing listed as such like in the following [example](screenshots/29.png). In my case, the network interface used by the Virtual Machine only appeared upon the restarting of the NetworkManager.service (`systemctl restart NetworkManager.service`), but in some cases it might be permanently set as so. 

To try and mitigate this, so that only SSH is being used as a valid socket, you should set your Machine IP as **static**. To do so, install `net-tools` in your machine, in order to adquire the `ifconfig` command. You will need it to easily [extract some information](screenshots/30.png) about your machine: your `network interface`, you `IP address`, your `netmask` and your `gateway`.  

```sh
# dnf install net-tools
# ifconfig -a
# route -n
```

My best guess is that since CentOS uses NetworkManager as default upon boot, it takes a while to identify the connection and eventually set it to static if it is set as so. If automatic, it might or might not judge necessary at all. However, we must ensure it **always** to be the case. To do so, we can use a tool called `tui` provided with NetworkManager. [Make sure it is already installed](screenshots/31.png) and then use it to configure your network interface:

```sh
# nmtui-edit enp0s3
```
The [before](screenshots/32.png) and [after](screenshots/33.png) of this operation. 

To check the new settings, restart your NetworkManager Service and wait a few minutes. Then list the sockets available again.

```sh
# systemctl restart NetworkManager 
# ss -tunlp
```

At the end, your socket list should look like something like [this](screenshots/34.png).

---
<h2 id="TestSSH">
	<b>Testing the SSH connection</b>
</h2>

You can easily test if your SSH conection is properly working by attempting to connect to your VM using another computer's terminal. On Linux's distros, WSL or MacOS it is available by default. On Windows your have to install `PuTTY`.

To connect remotely to your server use: 
```sh
# ssh <server-user>@<server's IP number> -p <ssh-port>
```
 To check your server's IP number, use the command `ip addr show` as [this](screenshots/36.png)

 In my server, the command was written as followed:
> ```sh
> # ssh cado-car@192.168.15.181 -p 4242
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
In case you don't, use `dnf` to install it. You will need root privileges:

```sh
# dnf install sudo
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
# visudo -f /etc/sudoers.d/sudoers-rules
```

On the `vim` interface in the new file, [the rules were added](screenshots/24.png).

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

You may notice that the `sudo` group, in **CentOS**, is called `wheel`, and in order to add a user to it you must use the command `gpasswd -a <username> wheel`. To remove them we use the `-r` flag instead of `-a`. To move the previously created user made on installation with the intra login, I used: 

```sh
# gpasswd -a cado-car wheel
```

You also have to make sure the line on `/etc/sudoers` that says `%wheel ALL=(ALL) ALL` is uncommented. 

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

The first 4 rules must be set by editing `/etc/login.defs`. The final result should look like [this](screenshots/35.png).

For the users already created (root included) these optons will not be automatically enabled. You will have to enforce them by using the `chage` command and manually apply the rules above. You can use the flag `-l` to list the rules applied to a specific user.
```sh
# chage -M 30 <username/root>
# chage -m 2 <username/root>
# chage -W 7 <username/root>
# chage -l <username/root>
```

The last 3 rules can be applied by using a package already installed on CentOS by default called `pam-pwquality`. Check its version using: 
```sh
# dnf list installed | grep libpwquality 
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
- For **root**: `2001SpaceOdyssey`.
- For **cado-car**: `LaD0lceVita`.

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

**Cron** is a service that runs on the backgroud and lauches configured tasks on a schedule. Cron is present on CentOS by default. To check its version or even, by some reason, eventually install it, use: 
```sh
# rpm -q crontabs
# dnf install crontabs
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
It will create your own crontab (each user has one - or many). You can edit to your own like, following the syntax shown [here](screenshots/37.png). 

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

- [System basic requirements](screenshots/38.png)
- [Monitoring Script](screenshots/39.png)

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
<h2 id="ref">
	<b>References</b>
</h2>
<p><a href="https://www.centos.org/"><i><b>The CentOS Project Website</b></i></a></p>
<p><a href="https://www.openlogic.com/blog/what-centos"><i><b>What is CentOS</b></i></a></p>
<p><a href="https://wiki.ubuntu.com/Lvm"><i><b>What is LVM</b></i></a></p>
<p><a href="https://www.golinuxcloud.com/create-lvm-during-installation-rhel-centos-8/"><i><b>LVM during CentOS installation</b></i></a></p>
<p><a href="https://blog.eldernode.com/dnf-command-on-centos-8/"><i><b>DNF command on CentOS 8</b></i></a></p>
<p><a href="https://www.scionova.com/2019/04/08/securing-linux-with-mandatory-access-control/"><i><b>Securing Linux with MAC</b></i></a></p>
<p><a href="https://wiki.centos.org/HowTos/SELinux"><i><b>About SELinux</b></i></a></p>
<p><a href="https://www.linode.com/docs/guides/a-beginners-guide-to-selinux-on-centos-8/"><i><b>SELinux on CentOS 8</b></i></a></p>
<p><a href="https://shouts.dev/install-and-setup-ufw-firewall-on-centos-8-rhel-8"><i><b>Set up UFW on CentOS 8</b></i></a></p>
<p><a href="https://www.itzgeek.com/how-tos/linux/centos-how-tos/semanage-command-not-found-in-centos-8-rhel-8.html"><i><b>Install 'semanage' command</b></i></a></p>
<p><a href="https://paritoshbh.me/blog/allow-access-port-selinux-firewall"><i><b>Allow SELinux access to port on Firewall permition</b></i></a></p>
<p><a href="https://searchsecurity.techtarget.com/definition/Secure-Shell"><i><b>What is SSH</b></i></a></p>
<p><a href="https://www.howtoforge.com/how-to-configure-a-static-ip-address-on-centos-8/"><i><b>Configure Static IP Address on CentOS 8</b></i></a></p>
<p><a href="https://www.server-world.info/en/note?os=CentOS_8&p=pam&f=1"><i><b>Configure Password Policy on CentOS 8</b></i></a></p>
<p><a href="https://serverspace.io/support/help/automate-regular-tasks-cron-centos-8/"><i><b>Automate Cron tasks on CentOS 8</b></i></a></p>
