# build docker image to run the unifi controller
#
# the unifi contoller is used to admin ubunquty wifi access points
#
FROM ubuntu
MAINTAINER stuart nixon dotcomstu@gmail.com
ENV DEBIAN_FRONTEND noninteractive

RUN mkdir -p /var/log/supervisor /usr/lib/unifi/data && \
    touch /usr/lib/unifi/data/.unifidatadir

#Install gnupg
RUN apt-get update
RUN apt-get -q -y install gnupg

#Add keys first
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv 06E85760C0A52C50 

# add unifi and mongo repo
ADD ./101-mongo.list /etc/apt/sources.list.d/101-mongo.list
ADD https://dl.ui.com/unifi/5.12.22/unifi_sysvinit_all.deb /usr/lib/unifi

#Add keys for mongo and unifi
RUN apt-get update
RUN apt-get install -q -y /usr/lib/unifi/unifi_sysvinit_all.deb

VOLUME /usr/lib/unifi/data
EXPOSE  8443 8880 8080 27117 3478
WORKDIR /usr/lib/unifi
CMD ["java", "-Xmx256M", "-jar", "/usr/lib/unifi/lib/ace.jar", "start"]
