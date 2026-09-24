#!/bin/sh
set -e

chown -R mysql:mysql /var/lib/mysql

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing database..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql/

    # 初期化専用に一時起動（ネットワーク無効・ソケットのみ）
    mariadbd --user=mysql --datadir=/var/lib/mysql/ --skip-networking --socket=/run/mysqld/mysqld.sock &
    pid="$!"

    until mariadb --socket=/run/mysqld/mysqld.sock -u root -e "SELECT 1" >/dev/null 2>&1; do
        sleep 1
    done

    mariadb --socket=/run/mysqld/mysqld.sock -u root <<-EOSQL
        CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
        CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
        GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
        FLUSH PRIVILEGES;
EOSQL

    mariadb-admin --socket=/run/mysqld/mysqld.sock -u root shutdown
    wait "$pid"
fi

exec mariadbd --user=mysql --bind-address=0.0.0.0 --port=3306 --skip-networking=0 --datadir=/var/lib/mysql/