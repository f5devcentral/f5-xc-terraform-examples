#!/bin/bash

echo "Enter number of iterations:"
read itr

echo "Enter flask app ip:"
read ip

echo "Enter sleep interval:"
read intrvl

for n in $(seq 1 $itr)
do
    sleep $intrvl
    curl -X POST http://$ip:8888/send-metrics
done