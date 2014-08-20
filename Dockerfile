FROM jprjr/dbmail
MAINTAINER John Regan <john@jrjrtech.com>

RUN pacman -Syy >/dev/null 2>/dev/null && \
    pacman -S --needed --quiet --noconfirm openssh && \
    rm -rf /etc/ssh/* && \
    mkdir /opt/ssh.default

RUN useradd -m mailadmin && \
    usermod -p mailadmin mailadmin && \
    passwd -u mailadmin && \
    rm -rf /etc/s6/dbmail-imapd && \
    rm -rf /etc/s6/dbmail-httpd && \
    rm -rf /etc/s6/dbmail-lmtpd && \
    mkdir -p /etc/s6/sshd && \
    ln -s /bin/true /etc/s6/sshd/finish && \
    mkdir -p /etc/s6/.s6-svscan && \
    ln -fs /bin/true /etc/s6/.s6-svscan/finish

COPY conf/sshd_config /opt/ssh.default/sshd_config

COPY sshd.setup /etc/s6/sshd/setup
COPY sshd.run /etc/s6/sshd/run

EXPOSE 22

ENTRYPOINT ["/usr/bin/s6-svscan","/etc/s6"]
CMD []
