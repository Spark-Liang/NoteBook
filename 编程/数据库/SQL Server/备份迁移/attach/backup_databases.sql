use master
GO

declare
    @sql as nvarchar(max);

set @sql = (
    select string_agg(convert(nvarchar(max), backup_statment),char(10)) stmt
    from (
             select replace(
                            N'BACKUP DATABASE [<DB_NAME>] TO DISK = N''/var/opt/mssql/<DB_NAME>.bak'' WITH NOFORMAT, NOINIT, SKIP, NOREWIND, NOUNLOAD, STATS = 10;'
                        , N'<DB_NAME>'
                        , name
                        )
                        backup_statment
             from sys.databases
             where database_id > 4
         ) t
)
exec sp_executesql @sql;
