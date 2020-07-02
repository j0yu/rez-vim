ARG CENTOS_MAJOR=7
FROM centos:$CENTOS_MAJOR

COPY install-deps.sh /
RUN bash /install-deps.sh

COPY entrypoint.sh /
ENTRYPOINT ["bash", "/entrypoint.sh"]

