# WSGI service environment

FROM alpine:3.18

RUN apk add --no-cache --update bash shadow python3 py3-pip uwsgi uwsgi-python3 && \
    pip3 install --no-cache --upgrade pip && \
    chgrp 0 /etc/passwd && \
    chmod g=u /etc/passwd && \
    chgrp 0 /home && \
    chmod g=u /home

ADD entrypoint.sh /usr/local/etc/entrypoint.sh

ENV SERVICE_UID=33
ENV SERVICE_GID=33
ENV SERVICE_MOUNTPOINT='/'
# http://uwsgi-docs.readthedocs.io/en/latest/Options.html#buffer-size
ENV REQ_HEADER_BUFFER_SIZE=12288
ENV UWSGI_PROCESSES=1
ENV UWSGI_THREADS=4
ENV UWSGI_EXTRA=""
ENV PGSERVICEFILE="/srv/pg_service.conf"

STOPSIGNAL SIGINT

ENTRYPOINT ["/bin/bash", "/usr/local/etc/entrypoint.sh"]
