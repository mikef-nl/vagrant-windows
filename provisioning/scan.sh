#!/bin/bash
echo "[windows]" >> /etc/ansible/hosts
for i in $( seq ${2} ${3} )
 do 
  ping -c 1 ${1}.${i} > /dev/null 2>&1
  if [ $? -eq 0 ]; then
   hostName=`host ${1}.${i} | awk {'print $5'}`
   echo "${1}.${i} ${hostName%?}" >> /etc/ansible/hosts
  else
   echo "No Response"
  fi
 done
