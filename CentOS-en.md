<h1 align=center>
	<b>CentOS Linux 8</b>
</h1>

<p align=center>
	As part of the challenge of setting up a functional server, I chose for this project to work with CentOS.
</p>
<p align=center>
    CentOS (Community Enterprise Operating System) is a free, open source GNU/Linux distribution. It is functionally compatible and derived from RHEL(Red Hat Enterprise Linux), its subscription-paid twin.
</p>
<p align=center>
    The choice for CentOS comes from a very practical and straightforward curiosity: it is Enterprise-focused and one of the most popular distros used for large-scale and modern business environments.
</p>
<p align=center>
    Even though CentOS was, as of this year, discontinued for new releases and support from December 2021, RHEL is still largely used in many environments, and will most likely continue to be so for the nearby future. CentOS and RHEL, being virtually the same system, require the same basic knowledge to be set, turning a CentOS project still of great value.
</p>
<p align=center>
    Apart from that, CentOS is a very stable OS, receiving very few and largely sparse upgrades, which turns it into the most likely system to be used as server in the real world. It was made for Enterprises, and for the purpose of this project, just makes more sense. 
</p>

---
<h2>
Pre-Requisites
</h2>

<p> The project will be run entirely on a Virtual Machine, so the initial setup consists of only two downloadables:

- The latest available <a href="https://www.virtualbox.org/">Oracle VIrtualBox</a> (VirtualBox 6.1 was the one used at the time of this project)
- The <a href="https://www.centos.org/download/">CentOS Linux 8</a> DVD ISO
</p>

---
<h2>
Installing
</h2>

1. Open `VirtualBox` and [click 'New'](screenshots/00.png);
2. Initial set up of the Virtual Machine includes [memory](screenshots/01.png) and [hard disk](screenshots/02.png) specifications (since I attempted the bonus part, the hard drive allocation will be of 30.8Gb instead of 8Gb);
3. After creating the VM, [click on 'Settings'](screenshots/03.png) and [enable your network](screenshots/04.png) with 'Bridge Adapter', so that your Virtual Machine will be able to use your local internet settings; 
4. [Start](screenshots/05.png) your machine and when prompted, choose the previously downloaded `.iso` file as a [start-up disk](screenshots/06.png) to boot;
5. When loaded, choose [Install CentOS Linux 8](screenshots/07.png) (no need to test the media beforehand) and wait for the graphical installer to appear;
6. On the graphical interface, set-up your machine as required:
> - Choose [language](screenshots/08.png) as better suited for you (I chose English as default);
> - [Time and date](screenshots/09.png) to be set accordinly to your current location;
> - [Software Selection](screenshots/10.png) has to be set for 'Minimal Install'. Once our goal is to set up a server, GUIs are explicitily forbidden and are, altogether, dispensable;
> - [KDump](screenshots/11.png) should be set to 'disabled'. Since CentOS installation is already complex enough, additional settings were understood as optional;
> - [Network and hostname](screenshots/12.png) should be set as per the original instructions: your `hostname` should be your `intralogin+42` (in my case, `cado-car42`) and you should make sure the internet is enabled (at this point, your hostname can be any of your choice, since you'll be asked to modify it by command-line once the installation is complete).
> - Set a strong [Root Password](screenshots/14.png) of at least 20 characters;
> - You can already [configure a user](screenshots/15.png) with your intra login if you want, but this step can be done once you boot you new machine; 
> - At last, you must correctly [set-up partitions](screenshots/17.png) according to specific instructions (at this point, you can choose to create the Mandatory part's partitioning, or the Bonus part's one. I chose the Bonus one). Once you [choose the hard drive](screenshots/13.png) to partition, you must define a `custom` configuration. Pay attention to the fact that `sda1` is a `Standard Partition` while all the others are `LVM` (see below for more on 'Logical Volume Manager'). For the LVM partitions, they must all be located under an [Encrypted Volume Group](screenshots/16.png) as per the example, and you must choose a password for it (do no forget it!). It is important to notice as well that, for the \boot partition, I chose to use `ext2` file system, and for everything else, `ext4`, as of beeing more well-known and stable formats for those categories. 
> At the end, your graphical set-up manager should look as something like [this](screenshots/18.png). Click on `Begin Installation` and you're all set.  

---
<h2>
Logical Volume Manager (LVM)
</h2>

`LVM` is a system of mapping and managing hard disk memory used on Linux-kernel's based systems. Instead of the old method of partitioning disks on a single filesystem, LVM allows you to work with "Logical Volumes", a more dinamically and flexible way to deals with your hardware.

There are three major concepts you must understand to fully grasp the behaviour of LVM:
- **Volume Group**: It is a named collection of physical and logical volumes. Typical systems only need one Volume Group to contain all of the physical and logical volumes on the system;
- **Physical Volumes**: They correspond to disks; they are block devices that provide the space to store logical volumes;
- **Logical Volumes**: They correspond to partitions: they hold a filesystem. Unlike partitions though, logical volumes get names rather than numbers, they can span across multiple disks, and do not have to be physically contiguous.

The idea sounds symple: You take a disk, declare it as a Physical Volume, then you take that Volume and append it to the Volume Group of your choice (usually only one per computer). At last, you may "partition" that volume into small Logical Volumes that can correspond to 1 or multiple disks, and can be reallocated in memory even if they are already in use. 

`LVM` is a great utility to have on servers and systems that demand usage stability and great necessity of quick management of the available physical devices (add or remove memory, for instance).

---
<h2>
Logging into the System
</h2>

Once the installation has completed, you must reboot your system and log into the OS. 

The first step is to [type in the password](screenshots/21.png) you used to encrypt your `LVM` partitions. Then, you must [choose a user to log-in](screenshots/22.png) to. I recommend using the `root` for now, as we still need to have root's privileges to completely finish the set-up. 

Once you're logged in, use the following commands to check if everything is according to the plan: 

> - `cat /etc/os-release` - see [information](screenshots/20.png) on the system installed;
> - `lsblk` - see the [partitioning](screenshots/19.png)'s scheme.

Some importante commands to keep in hand: 

> - `logout` or `exit` - exit current session to enable you to change the active user;
> - `reboot` - reboot the system (needs root permission);
> - `poweroff` - turns the system off (needs root permission).

---
<h2>
	<b>MAC</b>
</h2>

Mandatory Access Control (or MAC) is a security protocol that forbids any certain program, even one running on effective superuser privileges, to do anything other than what it is previously allowed to do. It is a secure measure used, mainly, in systems where stability and protection are paramount concepts (such as server units). 

To enforce MAC, we can use a variety of programs. For Red Hat based systems, such as Fedora, RHEL and, of couse, our own CentOS, `SELinux` is the default. It was developed by NSA and, as of today, it is known to be one of the best, most strict and secure MAC systems there is. Of course, it comes with a setback: `SELinux` is also known to be one of the most difficult MAC systems to configure and use on a daily basis.

Comparing `SELinux` with `AppArmor`, for instance, we can clearly see the difference. `AppArmor` enforces protection over objects as per configuration. That means, the application "imunizes" other apps one by one. By default, something that has not been previously set as "protected" is, by all means, vulnerable. 

`SELinux` on the other hand, has the opposite behaviour. It includes the whole system in its protocols, protecting any and everything that has not been set for its own specific function. It uses a mechanism called "security label" or "security context" which classifies resources. It uses 4 different fields to effectively label and enforce security measures: user, role, type and level. These labels, on every single one of the applications available on the system, help the administrator to have complete control over any activity. 

`SELinux` is, by far, more secure and more complex than any of its pairs. It is the MAC system used for this activity and most likely the biggest challenge of this project. 

To ensure `SELinux` is running at startup, [check its status](screenshots/25.png) with the command bellow:

```sh
# sestatus
```
As the project evolves, `SELinux` will need to be modified.

---
<h2>
	<b>Package Management in CentOS 8</b>
</h2>

Up until a while ago, `YUM` (Yellowdog Updater, Modified) was the official package manager for `RPM` (Red Hat Package Manager) based Linux distros (such as Fedora and RHEL).

Now, as of `CentOS Linux 8` distro and all its upstreams, `DNF` (Dandified YUM) became the new, upgraded and stable package manager, correcting some of its predecessors faults and errors, and presenting a better dependency management, better perfomance and better memory consumption.

Now, on your terminal window, [make sure](screenshots/23.png) that you have `DNF` installed and up-to-date. 

- `dnf --version` - to check its current installed version;
- `dnf metacache` - to update it to the most recent version. 

---
<h2>
	<b>UFW</b>
</h2>

`UFW` (or "Uncomplicated Firewall") is a program designed, as the name suggests, to be an easy-to-use firewall manager. 'Firewall', in turn, is a security device responsable for monitoring the information and data traffic from your local computer to the network. 

As per the instructions, `UFW` will have to be installed on our machine and configured in a way that will only allow connection to port 4242. 

`UFW` is not available on the CentOS repository. So, we need to install the EPEL repository on our server on root privileges:
```sh
# dnf install epel-release -y
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
The subject only allows for port 4242 to be enabled, so what you can do is delete all ports available and allow 4242 at the end. The following commands may help you with this:
```sh
# ufw default allow/deny incoming
# ufw default allow/deny outgoing
# ufw allow/deny <port-number>
```
If you only `deny` a port, it will keep appearing on the rules as "DENY". To delete it completely, use:
```sh
# ufw status numbered
# ufw delete <rule-number>
```
To eventually disable the firewall, use:
```sh
# ufw disable
```

However, since we are using SELinux, some additional steps must be taken to guarantee the 4242 port is, in fact, opened. 
For the next steps, we will need to use `semanage` (SELinux Policy Management Tool), in order to configure some rules for the `SELinux` protocol.

First, you will need to install `semanage` by discovering which package provides us with it. Use:
```sh
# dnf whatprovides semanage
```
After the results [appear on screen](screenshots/26.png), install the demander package:
```sh
# dnf install -y policycoreutils-python-utils
```
Then, run `semanage` to see its availability:
```sh
# semanage -h
```
After the installation, you must ensure SELinux is allowing port 4242 on its permitions. To do so check for the rules regarding `http_port_t`:
```sh
# semanage port -l | grep http_port_t
```
If rule 4242 is not set, set it with the following command:
```sh
# semanage port -a -t http_port_t -p tcp 4242
```
When running `semanage port -l` command again, you will be able to [see port 4242](screenshots/27.png) correctly set up. 

---
<h2>
	<b>SUDO install and configuration</b>
</h2>

Check if you already have `sudo` on your system:

```sh
# sudo --version
```
In case you don't, se `dnf` to install sudo. You will need root privileges:

```sh
# dnf install sudo
```

You will need first to configure some rules for the sudo group. there are many ways to do it: 

- edit the `/etc/sudoers` file using text editors such as `vim` or `nano` (you will need to install them beforehand),
- use the `visudo` command (which will open the same `/etc/sudoers` file) on a preeinstalled `vim` or
- include a new file with the new specific rules asked on `/etc/sudoers.d` (that is later automatically scanned and included on `/etc/sudoers`). 

For organizational purposes, I chose the latter. Some adjustments were necessary before, however. First, we need to create the sudo-log directory:

```sh
# mkdir /var/log/sudo
```
Then, we need to comment the line on `/etc/sudoers` that holds the information on the `secure_path` which we will be reassigning on the new file. 

To configure the new sudo rules, I used the following command (on root permition):

```sh
# visudo -f /etc/sudoers.d/sudoers-rules
```

On `vim` interface in the new file, [the rules were added](screenshots/24.png).

To check all users on the system, use: 

```sh
# less /etc/passwd
```

Each line in the file has seven fields delimited by colons that contain the following information:

> - User name;
> - Encrypted password (x means that the password is stored in the /etc/shadow file);
> - User ID number (UID);
> - User’s group ID number;
> - Full name of the user;
> - User home directory;
> - Login shell.

To check all groups on the system, and its users, use: 

```sh
# less /etc/group
```

You may notice that the `sudo` group, in CentOS, is called `wheel`, and in order to add a user to it you must use the command `gpasswd -a <user> wheel`. To remove them we use the `-r` flag instead of `-a`. To move the previously created user made on installation with the intra login, I used: 

```sh
# gpasswd -a cado-car wheel
```

You also have to make sure the line on `/etc/sudoers` that says `%wheel ALL=(ALL) ALL` is uncommented. 

Alternatively, to check all groups a certain member is, you may use:
```sh
# groups <user>
```

---
<h2>
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
