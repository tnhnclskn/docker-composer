FROM tnhnclskn/php-w-exts

MAINTAINER Tunahan ÇALIŞKAN <mail@tunahancaliskan.com.tr>

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /tmp
ENV COMPOSER_VERSION 1.6.5

RUN apt-get install -y git && \
    curl -s -f -L -o /tmp/installer.php https://raw.githubusercontent.com/composer/getcomposer.org/b107d959a5924af895807021fcef4ffec5a76aa9/web/installer && \
    php -r " \
    \$signature = '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061'; \
    \$hash = hash('SHA384', file_get_contents('/tmp/installer.php')); \
    if (!hash_equals(\$signature, \$hash)) { \
        unlink('/tmp/installer.php'); \
        echo 'Integrity check failed, installer is either corrupt or worse.' . PHP_EOL; \
        exit(1); \
    }" && \
    php /tmp/installer.php --no-ansi --install-dir=/usr/bin --filename=composer --version=${COMPOSER_VERSION} && \
    composer --ansi --version --no-interaction && \
    rm -rf /tmp/* /tmp/.htaccess

ARG user=composer
ARG group=composer
ARG uid=1000
ARG gid=1000
ARG COMPOSER_HOME=/var/www/html

RUN mkdir -p $COMPOSER_HOME \
  && chown ${uid}:${gid} $COMPOSER_HOME \
  && groupadd -g ${gid} ${group} \
  && useradd -d "$COMPOSER_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

WORKDIR $COMPOSER_HOME

CMD ["composer"]
