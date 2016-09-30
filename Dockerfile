FROM project42/s6-centos:centos7

MAINTAINER Jordan Clark jordan.clark@esu10.org

ENV SSP_VERSION 1.14.8
ENV SSP_HASH fc13d3b4cd29445124daeefd382d41643e64fa8ab37af31eb24c5d9e1c1aa92b

RUN yum -y update && \
yum -y install epel-release && \
yum -y update && \
yum -y install httpd mod_ssl php php-mcrypt php-pdo php-pear php-xml php-mysql php-ldap php-pecl-memcache && \
yum -y clean all && \
wget https://github.com/simplesamlphp/simplesamlphp/releases/download/v$SSP_VERSION/simplesamlphp-$SSP_VERSION.tar.gz && \
echo "$SSP_HASH  simplesamlphp-$SSP_VERSION.tar.gz" | sha256sum -c - && \
cd /var && \
tar xzf /simplesamlphp-$SSP_VERSION.tar.gz && \
mv simplesamlphp-$SSP_VERSION simplesamlphp && \
rm /simplesamlphp-$SSP_VERSION.tar.gz

COPY container-files /

EXPOSE 80 443
