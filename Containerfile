FROM alpine:3.24

RUN apk add mariadb mariadb-client && \
    mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld/ /var/lib/mysql/ && \
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql/

EXPOSE 3306

CMD [ "mariadbd", "--user=mysql" , "--bind-address=0.0.0.0" , "--port=3306" , "--skip-networking=0" , "--datadir=/var/lib/mysql/" ]