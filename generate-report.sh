#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

RESULTS_FILE="target/jmeter/results/20250106-n11_search_test.csv"
HTML_REPORT="target/jmeter/reports/n11_search_test/index.html"

[ ! -f "$RESULTS_FILE" ] && { echo -e "${RED}Results file not found: $RESULTS_FILE${NC}"; exit 1; }

calculate_metrics() {
    local file=$1
    echo "$(tail -n +2 "$file" | awk -F',' '
        BEGIN { total=0; success=0; }
        {
            total++
            if($5=="true") success++
            sum+=$2
            if(NR==1 || $2<min) min=$2
            if($2>max) max=$2
        }
        END {
            printf "%d,%d,%d,%.2f,%d,%d", 
            total, success, total-success, 
            sum/total, min, max
        }')"
}

echo -e "${BLUE}=== PERFORMANCE TEST REPORT ===${NC}"
echo "$(date '+%Y-%m-%d %H:%M:%S')"
echo "----------------------------------------"

IFS=',' read -r total success failed avg min max <<< "$(calculate_metrics "$RESULTS_FILE")"

echo -e "\n${GREEN}Test Summary${NC}"
echo "----------------------------------------"
echo "Total Requests: $total"
echo "Success Rate: $(echo "scale=2; $success * 100 / $total" | bc)%"
echo "Failed Requests: $failed"

echo -e "\n${GREEN}Response Times${NC}"
echo "----------------------------------------"
echo "Average: ${avg}ms"
echo "Min: ${min}ms"
echo "Max: ${max}ms"

echo -e "\n${GREEN}Response Codes${NC}"
echo "----------------------------------------"
tail -n +2 "$RESULTS_FILE" | awk -F',' '{codes[$4]++} END {
    for (code in codes) 
        printf "HTTP %s: %d requests (%.1f%%)\n", 
               code, codes[code], codes[code]*100/NR
}' | sort

echo -e "\n${BLUE}Report Locations${NC}"
echo "----------------------------------------"
echo "1. HTML Report: $HTML_REPORT"
echo "2. CSV Results: $RESULTS_FILE"

[[ "$OSTYPE" == "darwin"* ]] && open "$HTML_REPORT" 