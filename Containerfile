FROM alpine:3.24

RUN apk add mariadb mariadb-client && \
    mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld/

COPY init-db.sh /usr/local/bin/init-db.sh
RUN chmod +x /usr/local/bin/init-db.sh

EXPOSE 3306
ENTRYPOINT ["/usr/local/bin/init-db.sh"]