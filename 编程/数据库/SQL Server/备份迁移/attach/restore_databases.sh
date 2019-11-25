#!/usr/bin/env bash
SA_PASSWORD=$1

CURRENT_PATH=`cd $(dirname $0) && pwd`
TEMP_SQL_FILE_PATH="${CURRENT_PATH}/tmp.sql"

ls /var/opt/mssql/ | grep -Po '[^.]+\.bak' | while read DB_NAME_BACKUP_FILE
do
    DB_NAME=`echo ${DB_NAME_BACKUP_FILE} |sed  's#.bak##g'`
    echo "restore database ${DB_NAME}"
    sed 's#$(db_name)#'${DB_NAME}'#g' "${CURRENT_PATH}/restore_database.sql" > ${TEMP_SQL_FILE_PATH}
    /opt/mssql-tools/bin/sqlcmd \
        -S localhost -U SA -P "${SA_PASSWORD}" -i "${TEMP_SQL_FILE_PATH}"
done