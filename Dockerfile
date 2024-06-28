ARG VERSION

FROM --platform=${TARGETPLATFORM} adminer:${VERSION}


# ENV LD_LIBRARY_PATH /usr/local/instantclient_21_9
# ENV ORACLE_HOME /usr/local/instantclient_21_9

ADD package/. /tmp/.
# ADD ini/instantclient.ini /etc/php.d/instantclient.ini

USER root
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get dist-upgrade -y && \
    apt-get -y autoremove && \
    apt-get clean
RUN apt-get install -y unzip
RUN apt-get install -y php-dev php-pear build-essential libaio1
RUN rm -rf /var/lib/apt/lists/*

RUN unzip -d /opt/oracle/ /tmp/instantclient-basic-linux.x64-21.9.0.0.0dbru.zip
RUN unzip -d /opt/oracle/ /tmp/instantclient-sdk-linux.x64-21.9.0.0.0dbru.zip
RUN unzip -d /opt/oracle/ /tmp/instantclient-sqlplus-linux.x64-21.9.0.0.0dbru.zip

RUN echo "/opt/oracle/instantclient_21_9" > /etc/ld.so.conf.d/oracle-instantclient.conf

RUN ldconfig
# RUN pear channel-update pear.php.net && pecl channel-update pecl.php.net
RUN echo "instantclient,/opt/oracle/instantclient_21_9" | pecl install oci8-2.2.0
RUN echo "extension=oci8.so" >> /etc/php/7.4/cli/php.ini
# RUN echo "extension=oci8.so" >> /etc/php/7.4/mods-available/oci8.ini


# ENTRYPOINT ["/sbin/tini" "--"]
