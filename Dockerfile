FROM --platform=${TARGETPLATFORM} adminer


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
RUN echo "extension=oci8.so" >> /etc/php/7.4/mods-available/oci8.ini

# RUN ln -s /usr/lib/libnsl.so.2 /usr/lib/libnsl.so.1
# RUN ln -s /lib/libc.so.6 /usr/lib/libresolv.so.2
# RUN ln -s /lib64/ld-linux-x86-64.so.2 /usr/lib/ld-linux-x86-64.so.2

RUN ldconfig
RUN pear channel-update pear.php.net && pecl channel-update pecl.php.net
RUN echo "instantclient,/opt/oracle/instantclient_21_9" | pecl install oci8-2.2.0


# RUN docker-php-ext-configure oci8 --with-oci8=instantclient,$ORACLE_HOME
# RUN docker-php-ext-install oci8

# ENTRYPOINT ["/sbin/tini" "--"]
