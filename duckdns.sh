#!/bin/bash
curl -k -s -o /dev/null -w "*** Sending a new request to DuckDNS with status_code: %{http_code} ***\n" "https://www.duckdns.org/update?domains=mmorillo&token=${DUCKDNS_TOKEN}&ip=" >>/var/log/duck.log
