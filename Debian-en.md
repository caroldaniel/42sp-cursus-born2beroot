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



---
<h2>
	<b>References</b>
</h2>
<p><a href="https://www.debian.org/intro/why_debian"><i><b>Why Debian?</b></i></a></p>
