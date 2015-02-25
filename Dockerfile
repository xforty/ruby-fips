FROM phusion/baseimage
MAINTAINER Matt Edlefsen <matt@xforty.com>

CMD ["/sbin/my_init"]

RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y python patch gawk g++ gcc make libc6-dev patch libreadline6-dev zlib1g-dev libyaml-dev libsqlite3-dev sqlite3 autoconf libgdbm-dev libncurses5-dev automake libtool bison pkg-config libffi-dev 

RUN cd /root && curl 'https://www.openssl.org/source/openssl-fips-2.0.7.tar.gz' | tar -xz
RUN cd /root/openssl-fips-2.0.7; ./config; make; make install

RUN cd /root && curl 'https://www.openssl.org/source/openssl-1.0.1h.tar.gz' | tar -xz
RUN cd /root/openssl-1.0.1h; ./config fips shared -fPIC; make depend; make; make install

RUN echo 'export PATH="/usr/local/ssl/bin:$PATH"' > /etc/profile.d/usr-local-ssl.sh && chmod +x /etc/profile.d/usr-local-ssl.sh

RUN bash -c 'source /etc/profile.d/usr-local-ssl.sh && openssl version | grep fips'

RUN \curl -sSL https://get.rvm.io | bash -s stable

RUN bash -l -c 'rvm autolibs disable'

RUN bash -l -c 'rvm install --disable-binary ruby -C --with-openssl-dir=/usr/local/ssl --with-static-linked-ext'
