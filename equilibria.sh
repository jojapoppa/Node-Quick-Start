#! /bin/bash

install_checks () {
sudo apt install git
    install_node
}

install_node () {
  sudo apt install wget unzip
  sudo apt update
  sudo apt-get install  build-essential cmake pkg-config libboost-all-dev libssl-dev libzmq3-dev libunbound-dev libsodium-dev libunwind8-dev liblzma-dev libreadline6-dev libldns-dev libexpat1-dev doxygen graphviz libpgm-dev qttools5-dev-tools libhidapi-dev libusb-dev libprotobuf-dev protobuf-compiler
  git clone --branch jojabranch --recursive 'https://github.com/jojapoppa/Equilibria.git' equilibria && cd equilibria
  git submodule init && git submodule update
#  git checkout v10.2.0
  make

#  cd build/Linux/_HEAD_detached_at_v10.2.0_/release && mv bin ~/
  mkdir ~/bin
  cd /root/Node-Quick-Start/equilibria/build/Linux/jojabranch/release/bin
  cp -r * ~/bin

  rm /etc/systemd/system/eqnode.service
  cp /root/Node-Quick-Start/eqnode.service /etc/systemd/system/
  sudo systemctl daemon-reload
  sudo systemctl enable eqnode.service
}

prepare_sn () {
  ~/bin/daemon prepare_sn
}

start () {
  systemctl start eqnode.service
  echo Service node started to check it works use bash equilibria.sh log
}

status () {
  ~/bin/daemon status
  #systemctl status eqnode.service
}

stop_all_nodes () {
  echo Stopping XEQ node
  sudo systemctl stop eqnode.service
}

log () {
  sudo journalctl -u eqnode.service -af
}

update () {
  git pull
}

fork_update () {
  rm -r ~/Equilibria/equilibria
  git clone --branch jojabranch --recursive 'https://github.com/jojapoppa/Equilibria.git' equilibria && cd equilibria
  git submodule init && git submodule update
  #git checkout v10.2.0
  make
  sudo systemctl stop eqnode.service
  rm -r ~/bin
  #cd build/Linux/_HEAD_detached_at_v10.2.0_/release && mv bin ~/
  mkdir ~/bin
  cd /root/Node-Quick-Start/equilibria/build/Linux/jojabranch/release/bin 
  cp -r * ~/bin

  sudo systemctl enable eqnode.service
  sudo systemctl start eqnode.service
}

case "$1" in
  install ) install_checks ;;
  prepare_sn ) prepare_sn ;;
  start ) start ;;
  stop ) stop_all_nodes ;;
  status ) status ;;
  log ) log ;;
  update ) update ;;
  fork_update ) fork_update ;;
esac
