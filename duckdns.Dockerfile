FROM debian:bookworm-slim
ARG DUCKDNS_TOKEN

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
	bash \
	cron \
	curl \
	&& rm -rf /var/lib/apt/lists/*

COPY duckdns.sh /usr/local/duckdns.sh
COPY cronfile /etc/cron.d/duckdns

RUN sed -i "s/\$DUCKDNS_TOKEN/$DUCKDNS_TOKEN/g" /usr/local/duckdns.sh

RUN chmod +x /usr/local/duckdns.sh && chmod 0644 /etc/cron.d/duckdns \
	&& crontab /etc/cron.d/duckdns && touch /var/log/duck.log \
	&& echo "SHELL=/bin/bash" >> /etc/crontab

CMD ["sh", "-c", "service cron start && tail -f /var/log/duck.log"]
