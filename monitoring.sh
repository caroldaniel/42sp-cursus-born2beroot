#!bin/bash

## Command substitutions
ARCH=$(uname -snrvmo)
CPU=$(grep 'physical id' /proc/cpuinfo | uniq | wc -l)
VCPU=$(grep 'processor' /proc/cpuinfo | uniq | wc -l)
FREERAM=$(free -m | grep Mem: | awk '{print $3}')
USEDRAM=$(free -m | grep Mem: | awk '{print $2}')
PCTRAM=	$(free -m | grep Mem: | awk '{printf("%.2f"), $3/$2*100}')
FREEDISK=
USEDDISK=
PCTDISK=

## Shows the architecture of the operating system and its kernel version
echo "#Architecture: ${ARCH}"

## Shows the number of physical processors (CPUs)
echo "#CPU physical: ${CPU}"

## Shows the number of virtual processors (vCPUs)
echo "#vCPU: ${VCPU}"

## Shows the current available RAM on your server and its utilization rate as percentage
echo "#Memory Usage: ${FREERAM}/${USEDRAM}MB (${PCTRAM}%)"
