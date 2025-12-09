#!/bin/sh
# iperf3-explicit-test.sh
# Run each iperf3 command explicitly, one at a time, with timeout and logging
# Grabbed most servers from: https://iperf3serverlist.net/
LOGFILE="/tmp/iperf3-results.log"
rm -f "$LOGFILE"

FASTEST_SERVER=""
FASTEST_SPEED=0

run_test() {
    echo "====================================="
    echo "Running: $*"
    timeout 25 $* | tee /tmp/iperf3-current.log

    SPEED=$(grep -E "sender|receiver" /tmp/iperf3-current.log | awk '{print $(NF-1)}')
    SPEED_INT=$(echo "$SPEED" | awk 'BEGIN{max=0}{if($1+0>max)max=$1}END{print int(max)}')

    echo "Result: ${SPEED_INT:-0} Mbits/sec" | tee -a "$LOGFILE"

    if [ -n "$SPEED_INT" ] && [ "$SPEED_INT" -gt "$FASTEST_SPEED" ]; then
        FASTEST_SPEED=$SPEED_INT
        FASTEST_SERVER="$*"
    fi
}

# Explicit commands, each on its own line:
run_test iperf3 -c 37.19.206.20 -R -u
run_test iperf3 -c ash.speedtest.clouvider.net -p 5200-5209 -R -6 -u
run_test iperf3 -c 185.152.66.67 -R -u
run_test iperf3 -c atl.speedtest.clouvider.net -p 5200-5209 -R -6 -u
run_test iperf3 -c 109.61.86.65 -R -u
run_test iperf3 -c speedtest15.suddenlink.net -R -u
run_test iperf3 -c 185.93.1.65 -R -u
run_test iperf3 -c speedtest.chi11.us.leaseweb.net -p 5201-5210 -R -6
run_test iperf3 -c 89.187.164.1 -R
run_test iperf3 -c dal.speedtest.clouvider.net -p 5200-5209 -R -6 -u
run_test iperf3 -c speedtest.dal13.us.leaseweb.net -p 5201-5210 -R -6
run_test iperf3 -c 37.19.216.1 -R -u
run_test iperf3 -c 185.152.67.2 -R -u
run_test iperf3 -c la.speedtest.clouvider.net -p 5200-5209 -R -6 -u
run_test iperf3 -c speedtest.lax12.us.leaseweb.net -p 5201-5210 -R -6
run_test iperf3 -c 195.181.162.195 -R -u
run_test iperf3 -c speedtest.mia11.us.leaseweb.net -p 5201-5210 -R -6
run_test iperf3 -c 185.59.223.8 -R -u
run_test iperf3 -c spd-uswb.hostkey.com -p 5205 -R
run_test iperf3 -c nyc.speedtest.clouvider.net -p 5201-5209 -R -6 -u
run_test iperf3 -c speedtest.nyc1.us.leaseweb.net -p 5201-5210 -R -6 -u
run_test iperf3 -c speedtest.phx1.us.leaseweb.net -p 5201-5210 -R -6
run_test iperf3 -c speedtest.sfo12.us.leaseweb.net -p 5201-5210 -R -6
run_test iperf3 -c 84.17.41.11 -R
run_test iperf3 -c speedtest.sea11.us.leaseweb.net -p 5201-5210 -R -6
run_test iperf3 -c speedtest.wdc2.us.leaseweb.net -p 5201-5210 -R -6

echo "====================================="
echo "Fastest server: $FASTEST_SERVER at $FASTEST_SPEED Mbits/sec"
