#!/bin/sh
# iperf3-bidirectional.sh
LOGFILE="/tmp/iperf3-results.log"
rm -f "$LOGFILE"

BEST_UPLOAD_SERVER=""
BEST_UPLOAD_SPEED=0
BEST_DOWNLOAD_SERVER=""
BEST_DOWNLOAD_SPEED=0

run_bidirectional_test() {
    SERVER="$1"
    PORT="${2:-5201}"
    
    echo "====================================="
    echo "Testing $SERVER:$PORT (bidirectional)" | tee -a "$LOGFILE"
    
    # Run bidirectional test
    timeout 25 iperf3 -c "$SERVER" -p "$PORT" -t 10 --bidir 2>&1 | tee /tmp/iperf3-bidi.log
    
    # Get just the summary lines (last 8 lines after separator)
    SUMMARY=$(tail -8 /tmp/iperf3-bidi.log)
    
    # Get TX-C speeds from summary and find minimum
    UPLOAD_MIN=$(echo "$SUMMARY" | grep "\[TX-C\]" | \
                grep -oE '[0-9]+(\.[0-9]+)? Mbits/sec' | \
                grep -oE '[0-9]+(\.[0-9]+)?' | \
                awk 'BEGIN{min=999999} {if($1+0<min) min=$1} END{printf "%d", min}')
    
    # Get RX-C speeds from summary and find minimum
    DOWNLOAD_MIN=$(echo "$SUMMARY" | grep "\[RX-C\]" | \
                  grep -oE '[0-9]+(\.[0-9]+)? Mbits/sec' | \
                  grep -oE '[0-9]+(\.[0-9]+)?' | \
                  awk 'BEGIN{min=999999} {if($1+0<min) min=$1} END{printf "%d", min}')
    
    # Handle case where no speeds found
    if [ "$UPLOAD_MIN" -eq 999999 ]; then
        UPLOAD_MIN=0
    fi
    if [ "$DOWNLOAD_MIN" -eq 999999 ]; then
        DOWNLOAD_MIN=0
    fi
    
    echo "Result: Upload=$UPLOAD_MIN Mbits/sec, Download=$DOWNLOAD_MIN Mbits/sec" | tee -a "$LOGFILE"
    echo "" | tee -a "$LOGFILE"
    
    # Update best records...

    
    # Update best upload
    if [ "$UPLOAD_MIN" -gt "$BEST_UPLOAD_SPEED" ]; then
        BEST_UPLOAD_SPEED=$UPLOAD_MIN
        BEST_UPLOAD_SERVER="$SERVER:$PORT"
    fi
    
    # Update best download
    if [ "$DOWNLOAD_MIN" -gt "$BEST_DOWNLOAD_SPEED" ]; then
        BEST_DOWNLOAD_SPEED=$DOWNLOAD_MIN
        BEST_DOWNLOAD_SERVER="$SERVER:$PORT"
    fi
}

echo "Starting iperf3 speed tests..." | tee -a "$LOGFILE"
echo "=====================================" | tee -a "$LOGFILE"

# Test servers with bidirectional mode
run_bidirectional_test "37.19.206.20" "5201"
run_bidirectional_test "ash.speedtest.clouvider.net" "5200"
run_bidirectional_test "185.152.66.67" "5201"
run_bidirectional_test "atl.speedtest.clouvider.net" "5200"
run_bidirectional_test "109.61.86.65" "5201"
run_bidirectional_test "speedtest15.suddenlink.net" "5201"
run_bidirectional_test "185.93.1.65" "5201"
run_bidirectional_test "speedtest.chi11.us.leaseweb.net" "5201"
run_bidirectional_test "89.187.164.1" "5201"
run_bidirectional_test "dal.speedtest.clouvider.net" "5200"
run_bidirectional_test "speedtest.dal13.us.leaseweb.net" "5201"
run_bidirectional_test "37.19.216.1" "5201"
run_bidirectional_test "185.152.67.2" "5201"
run_bidirectional_test "la.speedtest.clouvider.net" "5200"
run_bidirectional_test "speedtest.lax12.us.leaseweb.net" "5201"
run_bidirectional_test "195.181.162.195" "5201"
run_bidirectional_test "speedtest.mia11.us.leaseweb.net" "5201"
run_bidirectional_test "185.59.223.8" "5201"
run_bidirectional_test "spd-uswb.hostkey.com" "5205"
run_bidirectional_test "nyc.speedtest.clouvider.net" "5201"
run_bidirectional_test "speedtest.nyc1.us.leaseweb.net" "5201"
run_bidirectional_test "speedtest.phx1.us.leaseweb.net" "5201"
run_bidirectional_test "speedtest.sfo12.us.leaseweb.net" "5201"
run_bidirectional_test "84.17.41.11" ""
run_bidirectional_test "speedtest.sea11.us.leaseweb.net" "5201"
run_bidirectional_test "speedtest.wdc2.us.leaseweb.net" "5201"

echo "====================================="
echo "FINAL RESULTS" | tee -a "$LOGFILE"
echo "Best Upload Server: $BEST_UPLOAD_SERVER at $BEST_UPLOAD_SPEED Mbits/sec" | tee -a "$LOGFILE"
echo "Best Download Server: $BEST_DOWNLOAD_SERVER at $BEST_DOWNLOAD_SPEED Mbits/sec" | tee -a "$LOGFILE"
echo "====================================="
