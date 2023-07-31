FROM ubuntu:22.04

RUN set -eux; \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get update --yes; \
    apt-get install curl gnupg apt-transport-https --yes

RUN set -eux; \
    export DEBIAN_FRONTEND=noninteractive; \
    curl -1sLf "https://keys.openpgp.org/vks/v1/by-fingerprint/0A9AF2115F4687BD29803A206B73A36E6026DFCA" | gpg --dearmor > /usr/share/keyrings/com.rabbitmq.team.gpg; \
    curl -1sLf https://ppa1.novemberain.com/gpg.E495BB49CC4BBE5B.key | gpg --dearmor > /usr/share/keyrings/rabbitmq.E495BB49CC4BBE5B.gpg; \
    curl -1sLf https://ppa1.novemberain.com/gpg.9F4587F226208342.key | gpg --dearmor > /usr/share/keyrings/rabbitmq.9F4587F226208342.gpg; \
    echo 'deb [signed-by=/usr/share/keyrings/rabbitmq.E495BB49CC4BBE5B.gpg] https://ppa1.novemberain.com/rabbitmq/rabbitmq-erlang/deb/ubuntu jammy main' >> /etc/apt/sources.list.d/rabbitmq.list; \
    echo 'deb-src [signed-by=/usr/share/keyrings/rabbitmq.E495BB49CC4BBE5B.gpg] https://ppa1.novemberain.com/rabbitmq/rabbitmq-erlang/deb/ubuntu jammy main' >> /etc/apt/sources.list.d/rabbitmq.list; \
    echo 'deb [signed-by=/usr/share/keyrings/rabbitmq.9F4587F226208342.gpg] https://ppa1.novemberain.com/rabbitmq/rabbitmq-server/deb/ubuntu jammy main' >> /etc/apt/sources.list.d/rabbitmq.list; \
    echo 'deb-src [signed-by=/usr/share/keyrings/rabbitmq.9F4587F226208342.gpg] https://ppa1.novemberain.com/rabbitmq/rabbitmq-server/deb/ubuntu jammy main' >> /etc/apt/sources.list.d/rabbitmq.list; \
    apt-get update --yes

RUN set -eux; \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get install --yes gosu erlang-base erlang-asn1 erlang-crypto erlang-eldap erlang-ftp erlang-inets erlang-mnesia erlang-os-mon erlang-parsetools erlang-public-key erlang-runtime-tools erlang-snmp erlang-ssl erlang-syntax-tools erlang-tftp erlang-tools erlang-xmerl; \
    apt-get install rabbitmq-server --yes --fix-missing; \
    rabbitmq-plugins enable rabbitmq_management

ENV LANG=C.UTF-8 LANGUAGE=C.UTF-8 LC_ALL=C.UTF-8

COPY --chown=rabbitmq:rabbitmq 10-defaults.conf 20-management_agent.disable_metrics_collector.conf /etc/rabbitmq/conf.d/
COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 4369 5671 5672 15691 15692 25672
CMD ["rabbitmq-server"]
