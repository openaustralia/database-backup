#!/bin/sh

# Putting the database dumps into a similar place as automysqlbackup
DUMP_DIR="/var/lib/database-backup"

#MUSER=""
#MPASS=""
#MDEFAULTS="-u $MUSER -p$MPASS"

MDEFAULTS="--defaults-file=/etc/mysql/debian.cnf"

MYSQLDUMP="$(which mysqldump)"

# The databases to back up
MYSQLDBS="$(mysql $MDEFAULTS -Bse 'show databases')"

echo "Backing up databases to directory $DUMP_DIR"
for db in $MYSQLDBS
do
  if [ "$db" != "information_schema" ]; then
    echo $db
    # We're not compressing these because the backup script proper will do that
    $MYSQLDUMP $MDEFAULTS $db > $DUMP_DIR/mysql-$db
  fi
done

# Now do the actual backup (with the backup configuration here)
duplicity-backup.sh --config ./duplicity-backup.conf --backup
