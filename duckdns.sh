#!/bin/bash -l
(
	echo "url=https://www.duckdns.org/update?domains=mmorillo&token=$DUCKDNS_TOKEN&ip="
	echo
) | curl -k -K - | tee -a /var/log/duck.log
echo "" >>/var/log/duck.log
