#!/bin/bash
# -----------------------------------------------------------------------------------
# This script is used to prepare the files that bind-chroot need.
#
# -----------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------
# Configuration before run.
# 1. where is the root path of all the configuration file of bind-chroot.
NAMED_ROOT=/var/named/chroot
# -----------------------------------------------------------------------------------



# change the root path of named-chroot
sudo /usr/libexec/setup-named-chroot.sh "${NAMED_ROOT}" on
# copy the main config file.
sudo cp /etc/named.conf "${NAMED_ROOT}/etc/named.conf"
sudo cp /etc/named.rfc1912.zones "${NAMED_ROOT}/etc/named.rfc1912.zones"
sudo cp /etc/named.root.key "${NAMED_ROOT}/etc/named.root.key"

# copy the template file.
sudo cp -R /usr/share/doc/bind-*/sample/var/named/* "${NAMED_ROOT}/var/named/"

# generate some fundamental files.
sudo mkdir -p "${NAMED_ROOT}/var/named/data"
sudo touch "${NAMED_ROOT}/var/named/data/cache_dump.db"
sudo touch "${NAMED_ROOT}/var/named/data/named_stats.txt"
sudo touch "${NAMED_ROOT}/var/named/data/named_mem_stats.txt"
sudo touch "${NAMED_ROOT}/var/named/data/named.run"
sudo chmod 664 "${NAMED_ROOT}/var/named/data/*"

sudo mkdir -p "${NAMED_ROOT}/var/named/dynamic"
sudo touch "${NAMED_ROOT}/var/named/dynamic/managed-keys.bind"
sudo chmod 664 "${NAMED_ROOT}/var/named/dynamic/*"

sudo chgrp -R named "${NAMED_ROOT}"