#!/bin/ash
time=$(date +"%s")
ip=$(curl -s https://httpbin.org/ip | jq .origin)  # value is double-quoted
json="{\"time\": ${time}, \"address\": ${ip}}"

echo $json
echo $json | /root/google-cloud-sdk/bin/bq insert $BQ_TABLE
