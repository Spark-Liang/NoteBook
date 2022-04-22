#!/bin/sh
# HAPROXY down
A=`ps -C haproxy --no-header | wc -l`
if [[ $A -eq 0 ]]; then
    systemctl start haproxy
    if [[ `ps -C haproxy --no-header | wc -l` -eq 0 ]]; then
        killall -9 haproxy
        echo "HAPROXY down" | mail -s "haproxy"
        sleep 3600
    fi
fi