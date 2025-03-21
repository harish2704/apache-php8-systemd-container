FROM chialab/php:8.3-apache

ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  systemd systemd-sysv dbus dbus-user-session

RUN cd /lib/systemd/system/sysinit.target.wants/ \
    && rm $(ls | grep -v systemd-tmpfiles-setup)

RUN rm -f /lib/systemd/system/multi-user.target.wants/* \
    /etc/systemd/system/*.wants/* \
    /lib/systemd/system/local-fs.target.wants/* \
    /lib/systemd/system/sockets.target.wants/*udev* \
    /lib/systemd/system/sockets.target.wants/*initctl* \
    /lib/systemd/system/basic.target.wants/* \
    /lib/systemd/system/anaconda.target.wants/* \
    /lib/systemd/system/plymouth* \
    /lib/systemd/system/systemd-update-utmp*

RUN apt-get install -y --no-install-recommends procps iproute2 vim openssh-server;\
    rm /var/log/apache2/* ;\
    systemctl enable apache2

RUN cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"; \
    sed -i 's/#Port 22/Port 2022/' /etc/ssh/sshd_config

RUN mkdir -p /etc/systemd/system/sshd.service.d; \
    systemctl mask systemd-journald.service systemd-journald.socket; \
    printf "[Unit]\nWants=systemd-user-sessions.service\nAfter=systemd-user-sessions.service\n" > /etc/systemd/system/sshd.service.d/override.conf

EXPOSE 80/tcp
EXPOSE 2022/tcp

STOPSIGNAL SIGRTMIN+3
VOLUME [ "/var/log/apache2/", "/var/www/" ]

ENTRYPOINT [ "/lib/systemd/systemd", "--log-target=console" ]
