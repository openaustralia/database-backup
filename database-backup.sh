#!/bin/sh

# Putting the database dumps into a similar place as automysqlbackup
DUMP_DIR="/var/lib/database-backup"
mkdir -p $DUMP_DIR
# Created files should just readable (and writeable) by root
umask 077 

#MUSER=""
#MPASS=""
#MDEFAULTS="-u $MUSER -p$MPASS"

MDEFAULTS="--defaults-file=/etc/mysql/debian.cnf"

MYSQLDUMP="$(which mysqldump)"

# The databases to back up
MYSQLDBS="$(mysql $MDEFAULTS -Bse 'show databases')"

# Slightly hacky way of getting the directory that this script is in
# without depending on the current working directory being set
this_dir=$(dirname $(readlink -f $0))

echo "Backing up MySQL databases to directory $DUMP_DIR..."
for db in $MYSQLDBS
do
  if [ "$db" != "information_schema" ]; then
    echo $db
    # We're not compressing these because the backup script proper will do that
    $MYSQLDUMP $MDEFAULTS $db > $DUMP_DIR/mysql-$db
  fi
done

echo "Backing up Postgres databases to directory $DUMP_DIR..."
PGDBS="$(psql -qAt -c 'select datname from pg_database where datallowconn' postgres)"
for db in $PGDBS
do
  echo $db
  pg_dump $db > $DUMP_DIR/pg-$db
done

echo "Now transferring backups to S3..."
# Now do the actual backup (with the backup configuration here)
$this_dir/duplicity-backup.sh --config $this_dir/duplicity-backup.conf --backup
