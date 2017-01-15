#!/bin/sh

# url=$(awk -F = '{print $2}' urls.txt)
mkdir -p data
for i in $(cat urls.txt);
do 
	wget "${i}" -P ./data
	sleep 5
done