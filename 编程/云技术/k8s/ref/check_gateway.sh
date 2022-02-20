#!/bin/sh
# check gateway connectivity
readonly GATEWAY_IP=192.168.188.2

ping "$GATEWAY_IP" -c 4

