#!/bin/bash
# ©2009 synapze
# hacked for linux by jah
TUN=he-ipv6                         # tunnel device for IPv6 IP's
EXCLUDE=""                      # IP's to exclude from vhost listing
IFCONFIG=/sbin/ifconfig
HOST=/usr/bin/host
DATE=`date "+%Y-%m-%d%n"`
TIME=`date "+%H:%M:%S"`
DGRAY="\e[1;30m"
TEAL="\e[1;34m"
PINK="\e[01;31m"
WHITE="\e[1;37m"
GREEN="\e[1;32m"
PISS="\e[0;33m"
GRAY="\e[0;37m"
YELLOW="\e[1;33m"
RESET="\e[0m"
TOTAL=1
UP=0
DOWN=0
IPS="`$IFCONFIG | grep inet6 | grep -ve $TUN -ve "fe80::" | grep -wv "::1" | awk '{print $3}' | sed "s/addr://" | sed "s=/64=="`"
#SOCKSTATS="/usr/bin/sockstats"

echo -e "${DGRAY}Last updated: $DATE       _               _  Server: `hostname`"
echo -e "${WHITE}                        __   _| |__   ___  ___| |_ ___"
echo -e "${WHITE}                        \ \ / / '_ \ / _ \/ __| __/ __|"
echo '                         \ V /| | | | (_) \__ \ |_\__ \'
echo -e "${WHITE}                          \_/ |_| |_|\___/|___/\__|___/"
echo -e "${DGRAY}    Time: $TIME"
echo
echo -e "${DGRAY}****************************************************************************"
echo -e "    ${DGRAY}Status     IP Address         Hostname (unique users) (sockets)  Notes"
for EACH in $IPS; do
 SOCKETS=0
 UNIQUE=0
 if [ "`echo $EXCLUDE | grep -w $EACH`" == "" ]; then
  HOSTDATA=`$HOST $EACH`
  HOSTNAME=`echo $HOSTDATA | grep "domain name pointer" | awk '{print $5}' | sed "s/.$//" 2>/dev/null`
  if [ "$HOSTNAME" == "" ]; then
   HOSTNAME="localhost"
  fi
  if [ "`echo $EACH | grep ":"`" == "" ]; then
   IP=`$HOST -t A $HOSTNAME | awk '{print $5}' 2>/dev/null`
  else
   IP=`$HOST -t AAAA $HOSTNAME | awk '{print $5}' 2>/dev/null`
  fi
 # DATA=`$SOCKSTATS $EACH 2>/dev/null`
  UNIQUE=`echo $DATA | awk '{print $1}'`
  SOCKETS=`echo $DATA | awk '{print $2}'`
  if [ "$EACH" == "$IP" ]; then
   echo -e "    ${DGRAY}[${TEAL}PASS${DGRAY}] - ${WHITE}${IP} ${DGRAY}- ${GRAY}${HOSTNAME} ${DGRAY}(${GREEN}${UNIQUE}${DGRAY})   ${DGRAY}(${GREEN}${SOCKETS}${DGRAY})"
   UP=`expr $UP + 1`
  else
   echo -e "    ${DGRAY}[${PINK}FAIL${DGRAY}] - ${DGRAY}${EACH} ${DGRAY}- ${HOSTNAME} ${DGRAY}(${GREEN}${UNIQUE}${DGRAY})   ${DGRAY}(${GREEN}${SOCKETS}${DGRAY})  ${PINK}* Down *"
   DOWN=`expr $DOWN + 1`
  fi
 fi
 TOTAL=`expr $TOTAL + 1`
done
echo -e "${DGRAY}****************************************************************************"
echo -e "${DGRAY}                             Up: ${TEAL}${UP} ${DGRAY}Down: ${PINK}$DOWN ${DGRAY}Total: ${WHITE}${TOTAL}${RESET}"
