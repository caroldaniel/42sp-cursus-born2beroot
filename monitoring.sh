#!/bin/bash

## Shows the architecture of your operating system and its kernel version
uname -snrvmo
## Shows the number of physical processors (CPUs)
grep 'physical id' /proc/cpuinfo | uniq | wc -l
## Shows the number of virtual processors (vCPUs)
grep 'processor' /proc/cpuinfo | uniq | wc -l
## Shows the current available RAM on your server and its utilization rate as 
## percentage
free -m
