##### 采用backup和restore迁移DB



###### backup的步骤

1. 备份所有database_id 都大于4 的db。当database_id 小于等于4时是系统DB。

2. 采用下面的语句对每个DB进行备份。主要需要配置的是 要备份的DB 的名字和备份存到的路径。
   
   ```sql
   BACKUP DATABASE [<DB_NAME>] TO DISK = N'/var/opt/mssql/<DB_NAME>.bak' WITH NOFORMAT, NOINIT, SKIP, NOREWIND, NOUNLOAD, STATS = 10;
   ```

###### 恢复的步骤

1. 调用 RESTORE FILELISTONLY 语句先检查备份文件中包含的文件组

2. 然后调用 RESTORE DATABASE 进行恢复

在attach文件夹下有restore_databases.sh 的脚本用户批量恢复多个DB


