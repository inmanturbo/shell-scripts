BACKUP_DIR="/mnt/ssd/backups/ConfigBackup"
SQLITE_FILE="/data/freenas-v1.db"
TS=$(date "+%Y%m%d-%H%M%S")
RETENTION_DAYS="14"
HOST="nitro.turbodomain"
REMOTE_USER="inman"
REMOTE_DIR="/home/inman/freenas_bak"
KEYFILE="/root/.ssh/id_rsa"

mkdir -p ${BACKUP_DIR}

ssh -i ${KEYFILE} ${REMOTE_USER}@${HOST} "mkdir -p \"$REMOTE_DIR\""

sqlite3 ${SQLITE_FILE} .dump >  ${BACKUP_DIR}/freenas-v1.sql.${TS} &&
sqlite3 ${BACKUP_DIR}/freenas-v1.db.${TS} < ${BACKUP_DIR}/freenas-v1.sql.${TS}

scp -i ${KEYFILE} ${BACKUP_DIR}/freenas-v1.db.${TS} ${REMOTE_USER}@${HOST}:${REMOTE_DIR}

#If you want to delete old files. Change the RETENTION_DAYS to change backup retention.
ssh -i ${KEYFILE} ${REMOTE_USER}@${HOST} "find \"$REMOTE_DIR\" -type f -mtime +\"$RETENTION_DAYS\" -exec rm -f {} \;"
find ${BACKUP_DIR} -type f -mtime +${RETENTION_DAYS} -exec rm -f {} \;
