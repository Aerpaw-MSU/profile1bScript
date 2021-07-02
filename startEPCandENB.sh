#!/bin/bash

# MODE is either IQ_EMULATION, or PL_EMULATION, or TESTBED
#MODE=IQ_EMULATION
MODE=$1
EXEC_PATH=/home/openairinterface5g/cmake_targets/lte_build_oai/build/lte-softmodem
CONFIG_PATH=/home/openairinterface5g/ci-scripts/conf_files/enb.band7.tm1.100PRB.usrpb210.conf

if [ $MODE == "TESTBED" ]
then 
  mkdir /dev/net
  mknod /dev/net/tun c 10 200
  ip tuntap add mode tun srs_spgw_sgi
  ifconfig srs_spgw_sgi 172.16.0.1/24
  srsepc &
  $EXEC_PATH -O $CONFIG_PATH |  ts '[%Y-%m-%d %H:%M:%sS]' > OAI_ENB.log
  #gnome-terminal -x bash -c "$EXEC_PATH -O $CONFIG_PATH | ts '[%Y-%m-%d %H:%M:%.S]' > OAI_ENB.log;exec bash" &
#elif [ $MODE == "IQ_EMULATION" ]
#then
#  mkdir /dev/net
#  mknod /dev/net/tun c 10 200
#  ip tuntap add mode tun srs_spgw_sgi
#  ifconfig srs_spgw_sgi 172.16.0.1/24
#  srsepc &
#  ./$EXEC_PATH -O $CONFIG_PATH & 
#elif [ $MODE == "IQ_DIRECT" ]
#then
#  mkdir /dev/net
#  mknod /dev/net/tun c 10 200
#  ip tuntap add mode tun srs_spgw_sgi
#  ifconfig srs_spgw_sgi 172.16.0.1/24
#  srsepc &
#  ./$EXEC_PATH -O ~/$CONFIG_PATH  & 
elif [ $MODE == "PL_EMULATION" ]
then
  python3 zmq_tun.py -c -i ${CHEM_IP_ADDR} -p 5001 -t 172.16.0.1 -n tun &
elif [ $MODE == "PL_DIRECT" ]
then
  python3 zmq_tun.py -s -p 5002 -t 172.16.0.1 -n tun &
else
  echo "No mode specified"
fi
