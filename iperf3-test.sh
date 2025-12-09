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

# Ashburn DATAPACKET
run_test iperf3 -c 37.19.206.20 -p 5201
run_test iperf3 -c 37.19.206.20 -p 5201 -R -P 5 -t 10

# Ashburn Clouvider
run_test iperf3 -c ash.speedtest.clouvider.net -p 5200
run_test iperf3 -c ash.speedtest.clouvider.net -p 5200 -R -P 5 -t 10

# Atlanta DATAPACKET
run_test iperf3 -c 185.152.66.67 -p 5201
run_test iperf3 -c 185.152.66.67 -p 5201 -R -P 5 -t 10

# Atlanta Clouvider
run_test iperf3 -c atl.speedtest.clouvider.net -p 5200
run_test iperf3 -c atl.speedtest.clouvider.net -p 5200 -R -P 5 -t 10

# Boston DATAPACKET
run_test iperf3 -c 109.61.86.65 -p 5201
run_test iperf3 -c 109.61.86.65 -p 5201 -R -P 5 -t 10

# Charleston Optimum
run_test iperf3 -c speedtest15.suddenlink.net -p 5201
run_test iperf3 -c speedtest15.suddenlink.net -p 5201 -R -P 5 -t 10

# Chicago DATAPACKET
run_test iperf3 -c 185.93.1.65 -p 5201
run_test iperf3 -c 185.93.1.65 -p 5201 -R -P 5 -t 10

# Chicago LeaseWeb
run_test iperf3 -c speedtest.chi11.us.leaseweb.net -p 5201
run_test iperf3 -c speedtest.chi11.us.leaseweb.net -p 5201 -R -P 5 -t 10

# Dallas DATAPACKET
run_test iperf3 -c 89.187.164.1 -p 5201
run_test iperf3 -c 89.187.164.1 -p 5201 -R -P 5 -t 10

# Dallas Clouvider
run_test iperf3 -c dal.speedtest.clouvider.net -p 5200
run_test iperf3 -c dal.speedtest.clouvider.net -p 5200 -R -P 5 -t 10

# Dallas LeaseWeb
run_test iperf3 -c speedtest.dal13.us.leaseweb.net -p 5201
run_test iperf3 -c speedtest.dal13.us.leaseweb.net -p 5201 -R -P 5 -t 10

# Houston DATAPACKET
run_test iperf3 -c 37.19.216.1 -p 5201
run_test iperf3 -c 37.19.216.1 -p 5201 -R -P 5 -t 10

# Los Angeles DATAPACKET
run_test iperf3 -c 185.152.67.2 -p 5201
run_test iperf3 -c 185.152.67.2 -p 5201 -R -P 5 -t 10

# Los Angeles Clouvider
run_test iperf3 -c la.speedtest.clouvider.net -p 5200
run_test iperf3 -c la.speedtest.clouvider.net -p 5200 -R -P 5 -t 10

# Los Angeles LeaseWeb
run_test iperf3 -c speedtest.lax12.us.leaseweb.net -p 5201
run_test iperf3 -c speedtest.lax12.us.leaseweb.net -p 5201 -R -P 5 -t 10

# Miami DATAPACKET
run_test iperf3 -c 195.181.162.195 -p 5201
run_test iperf3 -c 195.181.162.195 -p 5201 -R -P 5 -t 10

# Miami LeaseWeb
run_test iperf3 -c speedtest.mia11.us.leaseweb.net -p 5201
run_test iperf3 -c speedtest.mia11.us.leaseweb.net -p 5201 -R -P 5 -t 10

# New York DATAPACKET
run_test iperf3 -c 185.59.223.8 -p 5201
run_test iperf3 -c 185.59.223.8 -p 5201 -R -P 5 -t 10

# New York HOSTKEY
run_test iperf3 -c spd-uswb.hostkey.com -p 5205
run_test iperf3 -c spd-uswb.hostkey.com -p 5205 -R -P 5 -t 10

# New York Clouvider
run_test iperf3 -c nyc.speedtest.clouvider.net -p 5201
run_test iperf3 -c nyc.speedtest.clouvider.net -p 5201 -R -P 5 -t 10

# New York LeaseWeb
run_test iperf3 -c speedtest.nyc1.us.leaseweb.net -p 5201
run_test iperf3 -c speedtest.nyc1.us.leaseweb.net -p 5201 -R -P 5 -t 10

# Phoenix LeaseWeb
run_test iperf3 -c speedtest.phx1.us.leaseweb.net -p 5201
run_test iperf3 -c speedtest.phx1.us.leaseweb.net -p 5201 -R -P 5 -t 10

# San Francisco LeaseWeb
run_test iperf3 -c speedtest.sfo12.us.leaseweb.net -p 5201
run_test iperf3 -c speedtest.sfo12.us.leaseweb.net -p 5201 -R -P 5 -t 10

# Seattle
iperf3 -c 84.17.41.11
iperf3 -c speedtest.sea11.us.leaseweb.net -p 5201-5210

# Washington
iperf3 -c speedtest.wdc2.us.leaseweb.net -p 5201-5210

echo "====================================="
echo "Fastest server: $FASTEST_SERVER at $FASTEST_SPEED Mbits/sec"
