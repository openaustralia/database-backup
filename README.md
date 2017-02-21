# OpenAustralia Foundation Backups

This repository contains details of all of OpenAustralia Foundation's backups and how to restore them. It also contains a script we use on some servers to do database backups and store them on Amazon S3.

## Backup and restore procedures

TODO.

## database-backup.sh

This script is a little misleadingly named as it also backs up directories to S3. It started off life as a simple script for dumping all the MySQL and PostgreSQL databases on an Ubuntu box and backing them up to S3 with https://github.com/zertrin/duplicity-backup

Before you start:
cp duplicity-backup.conf.example duplicity-backup.conf

And set
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
PASSPHRASE
in duplicity-backup.conf

For the time being this script is on the server in the directory /home/matthewl/database-backup

To verify and see what's going on with the backups:

sudo ./duplicity-backup.sh -v    verifies the backup
sudo ./duplicity-backup.sh -l    lists the files currently backed up in the archive
sudo ./duplicity-backup.sh -s    show all the backup sets in the archive


In an EMERGENCY:

Restore a specific file
sudo ./duplicity-backup.sh --restore-file [FILE_TO_RESTORE] [DESTINATION]   

Restores the entire backup to [path]
sudo ./duplicity-backup.sh --restore [PATH]

