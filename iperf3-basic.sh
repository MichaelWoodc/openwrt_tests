#!/bin/sh
# iperf3-basic.sh
# Run each iperf3 command explicitly, one at a time, with timeout and logging
# Grabbed most servers from: https://iperf3serverlist.net/
LOGFILE="/tmp/iperf3-results.log"
rm -f "$LOGFILE"

FASTEST_SERVER=""
FASTEST_SPEED=0

run_test() {
    echo "====================================="
    echo "Running: $*"
    timeout 25 $* 2>&1 | tee /tmp/iperf3-current.log

    # Look for the summary line that contains the total speed
    # Try to find the receiver summary line first (most reliable)
    SPEED_LINE=$(grep "receiver" /tmp/iperf3-current.log | tail -1)
    
    # If no receiver line, try sender line
    if [ -z "$SPEED_LINE" ] || [ "$SPEED_LINE" = "" ]; then
        SPEED_LINE=$(grep "sender" /tmp/iperf3-current.log | tail -1)
    fi
    
    SPEED_INT=0
    SPEED_RAW=""
    
    # Extract the speed value from the line
    if [ -n "$SPEED_LINE" ]; then
        # Extract the number before "Mbits/sec" or "Gbits/sec"
        SPEED_RAW=$(echo "$SPEED_LINE" | grep -oE '[0-9]+\.[0-9]+ Mbits/sec|[0-9]+\.[0-9]+ Gbits/sec|[0-9]+ Mbits/sec|[0-9]+ Gbits/sec' | head -1)
        
        if [ -n "$SPEED_RAW" ]; then
            # Get just the numeric part
            SPEED_VALUE=$(echo "$SPEED_RAW" | grep -oE '[0-9]+\.[0-9]+|[0-9]+')
            
            # Check if it's Gbits and convert to Mbits
            if echo "$SPEED_RAW" | grep -q "Gbits/sec"; then
                SPEED_VALUE=$(echo "$SPEED_VALUE * 1000" | bc 2>/dev/null || echo "$SPEED_VALUE" | awk '{print $1 * 1000}')
            fi
            
            # Convert to integer (rounding)
            SPEED_INT=$(echo "$SPEED_VALUE" | awk '{printf "%.0f", $1}')
        fi
    fi
    
    # If still 0, try a more aggressive search
    if [ "$SPEED_INT" -eq 0 ]; then
        SPEED_RAW=$(grep -oE '[0-9]+\.[0-9]+ Mbits/sec|[0-9]+ Mbits/sec' /tmp/iperf3-current.log | tail -1)
        if [ -n "$SPEED_RAW" ]; then
            SPEED_VALUE=$(echo "$SPEED_RAW" | grep -oE '[0-9]+\.[0-9]+|[0-9]+')
            SPEED_INT=$(echo "$SPEED_VALUE" | awk '{printf "%.0f", $1}')
        fi
    fi
    
    echo "Result: $SPEED_INT Mbits/sec" | tee -a "$LOGFILE"

    if [ "$SPEED_INT" -gt "$FASTEST_SPEED" ]; then
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
