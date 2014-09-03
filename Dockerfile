#
# Openhab 1.5.0
# * configuration is injected
#
FROM ubuntu:14.04
MAINTAINER Tom Deckers <tom@ducbase.com>

RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install openjdk-7-jre unzip supervisor

# Download Openhab 1.5.0
ADD https://github.com/openhab/openhab/releases/download/v1.5.0/distribution-1.5.0-runtime.zip /tmp/distribution-1.5.0-runtime.zip
ADD https://github.com/openhab/openhab/releases/download/v1.5.0/distribution-1.5.0-addons.zip /tmp/distribution-1.5.0-addons.zip

RUN mkdir -p /opt/openhab/addons-avail
RUN unzip -d /opt/openhab /tmp/distribution-1.5.0-runtime.zip
RUN unzip -d /opt/openhab/addons-avail /tmp/distribution-1.5.0-addons.zip
RUN chmod +x /opt/openhab/start.sh

ADD http://downloads.sourceforge.net/project/sigar/sigar/1.6/hyperic-sigar-1.6.4.tar.gz /tmp/hyperic-sigar-1.6.4.tar.gz
RUN mkdir -p /opt/openhab/lib
RUN tar -zxf /tmp/hyperic-sigar-1.6.4.tar.gz --wildcards --strip-components=2 -C /opt/openhab hyperic-sigar-1.6.4/sigar-bin/lib/*

# Configure supervisor to run openhab
ADD files/supervisord.conf /etc/supervisor/supervisord.conf
ADD files/openhab.conf /etc/supervisor/conf.d/openhab.conf

EXPOSE 8080 8443 5555 9001

CMD ["/usr/bin/supervisord"]
