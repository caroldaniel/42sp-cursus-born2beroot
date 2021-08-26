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



---
<h2>
	<b>References</b>
</h2>
<p><a href="https://www.centos.org/"><i><b>The CentOS Project Website</b></i></a></p>
<p><a href="https://www.openlogic.com/blog/what-centos"><i><b>What is CentOS</b></i></a> - an OpenLogic article</a></p>
