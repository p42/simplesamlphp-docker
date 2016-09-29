FROM centos:centos7

MAINTAINER Unicon, Inc.

RUN yum -y install epel-release \
    && yum -y update \
    && yum -y install httpd mod_ssl php php-mcrypt php-pdo php-pear php-xml php-mysql php-ldap wget \
    && yum -y clean all

RUN ssp_version=1.14.8; \
    ssp_hash=fc13d3b4cd29445124daeefd382d41643e64fa8ab37af31eb24c5d9e1c1aa92b; \
    wget https://github.com/simplesamlphp/simplesamlphp/releases/download/v$ssp_version/simplesamlphp-$ssp_version.tar.gz \
    && echo "$ssp_hash  simplesamlphp-$ssp_version.tar.gz" | sha256sum -c - \
	&& cd /var \
	&& tar xzf /simplesamlphp-$ssp_version.tar.gz \
    && mv simplesamlphp-$ssp_version simplesamlphp \
    && rm /simplesamlphp-$ssp_version.tar.gz

RUN echo $'\nSetEnv SIMPLESAMLPHP_CONFIG_DIR /var/simplesamlphp/config\nAlias /simplesaml /var/simplesamlphp/www\n \
<Directory /var/simplesamlphp/www>\n \
    Require all granted\n \
</Directory>\n' \
       >> /etc/httpd/conf/httpd.conf

COPY httpd-foreground /usr/local/bin/

EXPOSE 80 443

CMD ["httpd-foreground"]
