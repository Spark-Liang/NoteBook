declare @list_result as table (
	LogicalName nvarchar(128)
	,PhysicalName nvarchar(260)
	,Type char(1)
	,FileGroupName nvarchar(128) 
	,Size numeric(20,0)
	,MaxSize numeric(20,0)
	,FileID bigint
	,CreateLSN numeric(25,0)
	,DropLSN numeric(25,0) 
	,UniqueID uniqueidentifier
	,ReadOnlyLSN numeric(25,0)
	,ReadWriteLSN numeric(25,0) 
	,BackupSizeInBytes bigint
	,SourceBlockSize int
	,FileGroupID int
	,LogGroupGUID uniqueidentifier 
	,DifferentialBaseLSN numeric(25,0) 
	,DifferentialBaseGUID uniqueidentifier 
	,IsReadOnly bit
	,IsPresent bit
	,TDEThumbprint varbinary(32) 
	,SnapshotURL nvarchar(360) 
);
declare @sql as nvarchar(max) = N'RESTORE FILELISTONLY FROM DISK = ''/var/opt/mssql/$(db_name).bak''';
insert into @list_result exec sp_executesql @sql;
set @sql = (select convert(
                       nvarchar(max)
                       , N'RESTORE DATABASE [$(db_name)] from disk = N''/var/opt/mssql/$(db_name).bak'' with ')
                       + string_agg(substatement, N',')
                       stmt
            from (
                     select convert(
                                nvarchar(max)
                                , replace(replace(
                                                  N'move ''<LogicalName>'' to ''<PhysicalName>'''
                                              , N'<LogicalName>', LogicalName)
                                 , N'<PhysicalName>', PhysicalName)
                                ) substatement
                     from @list_result
                 ) t
)
exec sp_executesql @sql;