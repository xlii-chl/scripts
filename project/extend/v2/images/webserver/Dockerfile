# Despite it is total wrong we consider a "wexserver" as an "apache web server"

FROM wexample/ubuntu18:latest

LABEL authors="wexample <contact@wexample.com>"

COPY ./v2/images/webserver/entrypoint.sh /docker-entrypoint-webserver.sh

# Install base packages.
# Add server name to prevent warnings.
# Add VM user to www data (allow site modification).
# Activate apache2 modules.
# Install entrypoint.
# Cleanup.
RUN apt-get update -yqq && apt-get install apache2 -yqq && \
    sed -i "\$aServerName wexWebServer" /etc/apache2/apache2.conf && \
    usermod -u 1000 www-data && \
    a2enmod rewrite && \
    a2enmod ssl && \
    a2enmod headers && \
    a2enmod expires && \
    chmod +x /docker-entrypoint-webserver.sh && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/docker-entrypoint-webserver.sh"]
