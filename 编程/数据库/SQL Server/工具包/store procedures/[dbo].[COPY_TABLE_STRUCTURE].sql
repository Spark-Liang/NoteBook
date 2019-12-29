--	############################################################################
--	This stored procedure is to copy the entire table structure, including index and partition.
--	
-- Currently, @ADDITIONAL_CONTROL_STR support the following items:
--		1. WITH_CONSTRAINTS
--		2. WITH_PARTITIONS_AND_REUSE_PARTITION_FUNCTION_AND_SCHEME
--		3. WITH_PARTITIONS_AND_CREATE_NEW_PARTITION_FUNCTION_AND_SCHEME
--
--  Limitation of this function:
--      1. In the column level constraint, this version only support copying not full constraint.
--      2. Currently only support clusterd index, nonclustered index, clusterd column store index and nonclusterd column store index.
--	############################################################################

DROP PROCEDURE if EXISTS [dbo].[COPY_TABLE_STRUCTURE];
GO

create procedure [dbo].[COPY_TABLE_STRUCTURE]
    @SOURCE_FULL_TABLE_NAME NVARCHAR(128),
    @TARGET_FULL_TABLE_NAME nvarchar(128),
	@COPY_WITH_INDEX INT = 0,
	@ADDITIONAL_CONTROL_STR NVARCHAR(4000) = ''
AS
BEGIN

     --  config common variable
    declare @error_msg as NVARCHAR(max);
    declare @error_severity as int;
    declare @error_state as int;
    declare @sql as NVARCHAR(max);

    declare @SCHEMA_NM as nvarchar(128);
	declare @TABLE_NM as nvarchar(128);
	declare @CONTROL_TIEMS as TABLE(
		item NVARCHAR(4000)
	);
	insert into @CONTROL_TIEMS 
	select value from string_split(@ADDITIONAL_CONTROL_STR,',')
	-- ################################################# validate @ADDITIONAL_CONTROL_STR #################################################
	-- vaidate WITH_PARTITIONS_AND_REUSE_PARTITION_FUNCTION_AND_SCHEME and WITH_PARTITIONS_AND_CREATE_NEW_PARTITION_FUNCTION_AND_SCHEME not in the @ADDITIONAL_CONTROL_STR at the same time.
	if 2 = (
		select count(*) from @CONTROL_TIEMS
		where item in ('WITH_PARTITIONS_AND_REUSE_PARTITION_FUNCTION_AND_SCHEME','WITH_PARTITIONS_AND_CREATE_NEW_PARTITION_FUNCTION_AND_SCHEME')
	)
	begin
		set @error_msg = N'"WITH_PARTITIONS_AND_REUSE_PARTITION_FUNCTION_AND_SCHEME" and "WITH_PARTITIONS_AND_CREATE_NEW_PARTITION_FUNCTION_AND_SCHEME" can not be added into the @ADDITIONAL_CONTROL_STR at the same time';
		raiserror(@error_msg,18,1);
	end
	-- ################################################# validate @ADDITIONAL_CONTROL_STR #################################################
	declare @IS_WITH_CONSTRAINTS BIT = iif('WITH_CONSTRAINTS' in (select item from @CONTROL_TIEMS),1,0)
	declare @PARTITION_MODE INT = (case 
		when 'WITH_PARTITIONS_AND_REUSE_PARTITION_FUNCTION_AND_SCHEME' in (select item from @CONTROL_TIEMS) then 1
		when 'WITH_PARTITIONS_AND_CREATE_NEW_PARTITION_FUNCTION_AND_SCHEME' in (select item from @CONTROL_TIEMS) then 2
		else 0
	end)
	;

    -- skip the unexists source table object.
	if object_id(@SOURCE_FULL_TABLE_NAME,'U') is null 
	begin
		set @error_msg = replace(N'The table object "<TABLE_NAME>" is not exists!',N'<TABLE_NAME>',@SOURCE_FULL_TABLE_NAME);
		raiserror(@error_msg,18,1);
	end
    select 
		@SCHEMA_NM = s.name,@TABLE_NM = t.name
	from (
		select name,schema_id
		from sys.tables
		where object_id = object_id(@SOURCE_FULL_TABLE_NAME,'U')
	) t 
	inner join sys.schemas s on
		t.schema_id = s.schema_id
	;
    set @SOURCE_FULL_TABLE_NAME = [dbo].[GET_WRAP_NAME](@SCHEMA_NM)+'.'+[dbo].[GET_WRAP_NAME](@TABLE_NM)
    ;
    print 'Formatted source table name is:'+@SOURCE_FULL_TABLE_NAME;

    -- skip the exists target table object.
	if object_id(@TARGET_FULL_TABLE_NAME,'U') is not null 
	begin
		set @error_msg = replace(N'The table object "<TABLE_NAME>" is exists!',N'<TABLE_NAME>',@TARGET_FULL_TABLE_NAME);
		raiserror(@error_msg,18,1);
	end

	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    BEGIN TRANSACTION COPY_TBL_STRUC_TRAN;
    SAVE TRANSACTION COPY_TBL_STRUC_SAVE_POINT;

	BEGIN TRY
		-- lock the source table.
		set @sql = replace('declare @tmp as int = (select 1 from <TABLE_NAME> with(tablockx) where 1=2)',N'<TABLE_NAME>',@SOURCE_FULL_TABLE_NAME)
		print 'Run lock table sql:'+@sql;
		exec sp_executesql @sql;


		-- handle WITH_PARTITIONS_AND_REUSE_PARTITION_FUNCTION_AND_SCHEME or WITH_PARTITIONS_AND_CREATE_NEW_PARTITION_FUNCTION_AND_SCHEME
		declare @PARTITION_SCHEME_NAME as NVARCHAR(1024);
		if @PARTITION_MODE > 0
		BEGIN
			if @PARTITION_MODE = 1
			BEGIN
				-- reuse the partition function and partition scheme
				select 
					@PARTITION_SCHEME_NAME = ds.name
				from sys.indexes idx
				join sys.data_spaces ds on idx.data_space_id = ds.data_space_id and ds.type = 'PS'
				where idx.object_id = object_id(@SOURCE_FULL_TABLE_NAME,'U') and index_id in (0,1);
				if @PARTITION_SCHEME_NAME is null
				BEGIN
					set @error_msg = replace(N'The source table object "<TABLE_NAME>" is not a partition table!',N'<TABLE_NAME>',@SOURCE_FULL_TABLE_NAME);
					raiserror(@error_msg,18,1);
				END
			END
			else if @PARTITION_MODE = 2
			BEGIN
				print 'abc';
				
				-- create a new partition function and scheme for the table.
				with current_try(FULL_TABLE_NAME,PARTITION_FUNCTION_NAME,IS_EXISTS,TRY_TIMES) as (
					select 
						FULL_TABLE_NAME
						,PARTITION_FUNCTION_NAME
						,iif(
							exists(select 1 from [dbo].[TABLE_PARTITION_INFO_SIMPLE] where PARTITION_FUNCTION=t.PARTITION_FUNCTION_NAME or PARTITION_SCHEME=t.PARTITION_FUNCTION_NAME)
							,1,0
						)IS_EXISTS
						,0 TRY_TIMES
					from (
						select
						@TARGET_FULL_TABLE_NAME FULL_TABLE_NAME
						,convert(varchar(1024),'PATITION_'+convert(nvarchar(32),checksum(@TARGET_FULL_TABLE_NAME))) PARTITION_FUNCTION_NAME
					)t
					union all 
					select 
						FULL_TABLE_NAME
						,PARTITION_FUNCTION_NAME
						,iif(
							exists(select 1 from [dbo].[TABLE_PARTITION_INFO_SIMPLE] where PARTITION_FUNCTION=t.PARTITION_FUNCTION_NAME or PARTITION_SCHEME=t.PARTITION_FUNCTION_NAME)
							,1,0
						)IS_EXISTS
						,TRY_TIMES + 1 TRY_TIMES
					from (
						select 
							FULL_TABLE_NAME
							,convert(varchar(1024),'PATITION_'+convert(nvarchar(32),checksum(FULL_TABLE_NAME))+convert(varchar(10),TRY_TIMES)) PARTITION_FUNCTION_NAME
							,TRY_TIMES
						from (
							select
								max(TRY_TIMES) over(order by FULL_TABLE_NAME) as MAX_TRY_TIME
								,*
							from current_try
						)t
						where IS_EXISTS=1 and TRY_TIMES = MAX_TRY_TIME
					) t
				)
				select 
					@PARTITION_SCHEME_NAME=PARTITION_FUNCTION_NAME 
				from current_try where IS_EXISTS = 0
				;
				
				-- create partition function
				set @sql = (
					select 
						'create partition function '+[dbo].[GET_WRAP_NAME](@PARTITION_SCHEME_NAME)+'('
						+case
							when PARTITION_COLUMN_TYPE in ('varchar','nvarchar','varbinary','xml')
							then PARTITION_COLUMN_TYPE +N'('+iif(PARTITION_COLUMN_MAX_LENGTH<0,N'max',convert(nvarchar(10),PARTITION_COLUMN_MAX_LENGTH))+N')' -- handel the special case mentioned in https://docs.microsoft.com/zh-cn/sql/relational-databases/system-catalog-views/sys-columns-transact-sql?view=sql-server-2017.
							when PARTITION_COLUMN_TYPE in ('char','nchar','binary')
							then PARTITION_COLUMN_TYPE +N'('+convert(nvarchar(10),PARTITION_COLUMN_MAX_LENGTH)+N')'
							when PARTITION_COLUMN_TYPE in ('decimal','numeric') 
							then PARTITION_COLUMN_TYPE +N'('+convert(nvarchar(10),PARTITION_COLUMN_PRECISION)+N','+convert(nvarchar(10),PARTITION_COLUMN_SCALE)+N')'
							else PARTITION_COLUMN_TYPE
						end +')
						as range '+RANGE_BOUNDARY_BELONG_TO+'
						for values('+coalesce(RANGE_BOUNDARY_LIST,'')+')'
					from (
						select 
							distinct TABLE_OBJECT_ID,PARTITION_COLUMN_TYPE,PARTITION_COLUMN_MAX_LENGTH,PARTITION_COLUMN_PRECISION,PARTITION_COLUMN_SCALE,RANGE_BOUNDARY_BELONG_TO
						from [dbo].[TABLE_PARTITION_INFO_SIMPLE]
						where TABLE_OBJECT_ID = object_id(@SOURCE_FULL_TABLE_NAME,'U')
					)t1
					left join (
						select 
							TABLE_OBJECT_ID
							,STRING_AGG(CONVERT(NVARCHAR(MAX)
								,''''+RANGE_BOUNDARY+''''
							),',')WITHIN GROUP(ORDER BY PARTITION_NUMBER)
							RANGE_BOUNDARY_LIST
						from [dbo].[TABLE_PARTITION_INFO_SIMPLE]
						where TABLE_OBJECT_ID = object_id(@SOURCE_FULL_TABLE_NAME,'U')
						  and RANGE_BOUNDARY is not null
						group by TABLE_OBJECT_ID
					)t2 on t1.TABLE_OBJECT_ID = t2.TABLE_OBJECT_ID
				);
				print 'run create new partition function sql:'+@sql;
				exec sp_executesql @sql;

				-- create partition scheme
				set @sql = (
					select 
						'create partition scheme '+[dbo].[GET_WRAP_NAME](@PARTITION_SCHEME_NAME)+'
						as partition '+[dbo].[GET_WRAP_NAME](@PARTITION_SCHEME_NAME)+'
						to ('+STRING_AGG(CONVERT(NVARCHAR(MAX)
							,[dbo].[GET_WRAP_NAME](FILE_GROUP)
						),',')WITHIN GROUP(ORDER BY PARTITION_NUMBER)
						+')'
					from [dbo].[TABLE_PARTITION_INFO_SIMPLE] 
					where TABLE_OBJECT_ID = object_id(@SOURCE_FULL_TABLE_NAME,'U')
				);
				print 'run create new partition scheme sql:'+@sql;
				exec sp_executesql @sql;
				
			END
			else 
			BEGIN
				set @error_msg = N'Internal Error! Invalid @PARTITION_MODE:'+convert(varchar(10),@PARTITION_MODE);
				raiserror(@error_msg,18,1);
			END
		END

		-- copy fields definition
		declare @fields_definition as NVARCHAR(max) = (
			select 
				STRING_AGG(convert(nvarchar(max),column_definition),N',' + char(13))
			from (
				select 
					t_column.[name] as column_name
					,[dbo].[GET_WRAP_NAME](t_column.name)
					+case
						when type_nm in ('varchar','nvarchar','varbinary','xml')
						then type_nm +N'('+iif(t_column.max_length<0,N'max',convert(nvarchar(10),t_column.max_length))+N')' -- handel the special case mentioned in https://docs.microsoft.com/zh-cn/sql/relational-databases/system-catalog-views/sys-columns-transact-sql?view=sql-server-2017.
						when type_nm in ('char','nchar','binary')
						then type_nm +N'('+convert(nvarchar(10),t_column.max_length)+N')'
						when type_nm in ('decimal','numeric') 
						then type_nm +N'('+convert(nvarchar(10),t_column.precision)+N','+convert(nvarchar(10),t_column.scale)+N')'
						else type_nm
					end 
					+N' '+ iif(is_nullable = 1,'NULL','NOT NULL')
					+iif(@IS_WITH_CONSTRAINTS = 1 and c_default.definition is not null,' DEFAULT '+c_default.definition,'')
					+iif(@IS_WITH_CONSTRAINTS = 1 and c_check.definition is not null,' CHECK '+c_check.definition,'')
					as column_definition
				from sys.columns t_column
				left join (
					select 
						user_type_id
						,system_type_id
						,lower(trim(name)) type_nm
					from sys.types
				) t_type 
					on t_column.user_type_id = t_type.user_type_id
				left join sys.default_constraints c_default on 
					t_column.object_id = c_default.parent_object_id 
					and t_column.column_id = c_default.parent_column_id
				left join sys.check_constraints c_check on 
					t_column.object_id = c_check.parent_object_id 
					and t_column.column_id = c_check.parent_column_id
					and c_check.parent_column_id <> 0
				where t_column.[object_id] = object_id(@SOURCE_FULL_TABLE_NAME,'U')
			)tmp  
		);
		declare @key_constraints as NVARCHAR(max);
		declare @check_constraints as NVARCHAR(MAX);
		select 
			@key_constraints=key_definition_str
			,@check_constraints=table_level_check_def
		from sys.tables t 
		left join (
			select 
				idx.object_id
				/*
				,idx.is_primary_key
				,idx.index_id
				,idx.type
				,is_unique
				,ignore_dup_key
				,key_columns_definition
				*/
				,string_agg(CONVERT(NVARCHAR(MAX)
					,iif(
						1=idx.is_primary_key,'PRIMARY KEY','UNIQUE'
					)+' '+iif(
						idx.index_id=1,'CLUSTERED','NONCLUSTERED'
					)+' ('+key_columns_definition+')'
					+ iif(index_option='','','with('+index_option+')'+CHAR(10) )
				),',')
				key_definition_str
			from (
				select 
					concat_ws(','
						,iif(is_padded>0,'PAD_INDEX = ON',null)
						,iif(fill_factor>0,'FILLFACTOR='+convert(nvarchar(10),fill_factor),null)
						,iif([ignore_dup_key]>0,'IGNORE_DUP_KEY = ON',null)
						,iif([ALLOW_ROW_LOCKS]=0,'ALLOW_ROW_LOCKS = OFF',null)
						,iif([ALLOW_PAGE_LOCKS]=0,'ALLOW_PAGE_LOCKS = OFF',null)
					)index_option
					,*
				from sys.indexes
			)idx 
			join (
				select 
					idx_col.object_id
					,idx_col.index_id
					,string_agg(convert(NVARCHAR(max)
						,[dbo].[GET_WRAP_NAME](c.name)+' '+iif(is_descending_key=1,'desc','asc')
					),',') within group(order by key_ordinal)
					key_columns_definition
				from sys.index_columns idx_col
				join sys.columns c on c.object_id = idx_col.object_id and c.column_id = idx_col.column_id
				where key_ordinal>0
				group by idx_col.object_id,idx_col.index_id
			) key_col_def on idx.object_id = key_col_def.object_id and idx.index_id = key_col_def.index_id
			group by idx.object_id
		) key_def on t.object_id = key_def.object_id
		left join (
			select 
				parent_object_id
				,STRING_AGG(convert(NVARCHAR(max)
					,'CHECK '+iif(is_not_for_replication=1,'NOT FOR REPLICATION ','')+definition
				),','+CHAR(10)) WITHIN GROUP(order by definition)
				table_level_check_def
			from sys.check_constraints t_check
			where parent_column_id = 0
			group by parent_object_id
		) check_def on t.object_id = check_def.parent_object_id
		where t.object_id = object_id(@SOURCE_FULL_TABLE_NAME,'U')
		;
		declare @PARTITION_COLUMN as NVARCHAR(256) = (
			select
				distinct [dbo].[GET_WRAP_NAME](PARTITION_COLUMN)
			from [dbo].[TABLE_PARTITION_INFO_SIMPLE]
			where TABLE_OBJECT_ID = object_id(@SOURCE_FULL_TABLE_NAME,'U')
		);
		set @sql = N'create table '+@TARGET_FULL_TABLE_NAME+N'('
				+char(13)+@fields_definition+char(13)
				+iif(@IS_WITH_CONSTRAINTS = 1 and @key_constraints is not null,','+char(10)+@key_constraints,'')
				+iif(@IS_WITH_CONSTRAINTS = 1 and @check_constraints is not null,','+char(10)+@check_constraints,'')
			+char(10)+')'+iif(@PARTITION_MODE>0,'on '+[dbo].[GET_WRAP_NAME](@PARTITION_SCHEME_NAME)+'('+@PARTITION_COLUMN+')','')
		;
		print 'create table sql is :' + @sql;
		exec sp_executesql @sql;

		if @COPY_WITH_INDEX > 0 
		BEGIN
			set @sql = (
				/*
				For B-tree index:
					create <idx_unique_type> <index type> <index name> on <table name>(<index key cols>) 
					[ INCLUDE ( column_name [ ,...n ] )]
					[with(<index option>)] [on <partition scheme>(partition column)]
				For columnstore index:
					create <idx_unique_type> <index type> <index name> on <table name>
					[ INCLUDE ( column_name [ ,...n ] )]
					[on <partition scheme>(partition column)]
				*/
				select 
					string_agg(convert(nvarchar(max),
						case 
							when idx_type_id in (1,2) then
								N'create '+idx_unique_type+' '+idx_type+N' '+idx_name+N' on '+@TARGET_FULL_TABLE_NAME+coalesce('('+idx_key_cols+')',N'')+CHAR(10)
									+coalesce('INCLUDE ('+included_columns_definition+')'+CHAR(10),'')
									+iif(index_option='','','with ('+index_option+')'+CHAR(10))
									+iif(
										@PARTITION_MODE > 0
										,'on '+[dbo].[GET_WRAP_NAME](@PARTITION_SCHEME_NAME)+'('+partition_columns_definition+')'+CHAR(10),''
									)
							when idx_type_id in (5,6) then
								N'create '+idx_unique_type+' '+idx_type+N' '+idx_name+N' on '+@TARGET_FULL_TABLE_NAME
									+iif(
										@PARTITION_MODE > 0
										,'on '+[dbo].[GET_WRAP_NAME](@PARTITION_SCHEME_NAME)+'('+partition_columns_definition+')'+CHAR(10),''
									)
						end
					),N';'+char(10))
				from (
					select 
						iif(is_unique=1,'unique','') idx_unique_type
						,idx.type idx_type_id
						,case 
							when idx.type = 1 then 'clustered index'
							when idx.type = 2 then 'nonclustered index'
							when idx.type = 5 then 'clustered columnstore index'
							when idx.type = 6 then 'nonclustered columnstore index'
							else null
						end idx_type
						,[dbo].[GET_WRAP_NAME](idx.name) idx_name
						,iif(
							idx.type in (1,2,6)
							,key_columns_definition,null
						)idx_key_cols
						,concat_ws(','
							,iif(is_padded>0,'PAD_INDEX = ON',null)
							,iif(fill_factor>0,'FILLFACTOR='+convert(nvarchar(10),fill_factor),null)
							,iif([ignore_dup_key]>0,'IGNORE_DUP_KEY = ON',null)
							,iif([ALLOW_ROW_LOCKS]=0,'ALLOW_ROW_LOCKS = OFF',null)
							,iif([ALLOW_PAGE_LOCKS]=0,'ALLOW_PAGE_LOCKS = OFF',null)
						)index_option
						,partition_columns_definition
						,included_columns_definition
					from sys.indexes idx
					left join (
						select 
							idx_col.object_id
							,idx_col.index_id
							,string_agg(convert(NVARCHAR(max)
								,[dbo].[GET_WRAP_NAME](c.name)+' '+iif(is_descending_key=1,'desc','asc')
							),',') within group(order by key_ordinal)
							key_columns_definition
						from sys.index_columns idx_col
						join sys.columns c on c.object_id = idx_col.object_id and c.column_id = idx_col.column_id
						where key_ordinal>0
						group by idx_col.object_id,idx_col.index_id
					) key_def on idx.object_id = key_def.object_id and idx.index_id = key_def.index_id
					left join (
						select 
							idx_col.object_id
							,idx_col.index_id
							,string_agg(convert(NVARCHAR(max)
								,[dbo].[GET_WRAP_NAME](c.name)
							),',') within group(order by partition_ordinal)
							partition_columns_definition
						from sys.index_columns idx_col
						join sys.columns c on c.object_id = idx_col.object_id and c.column_id = idx_col.column_id
						where partition_ordinal>0
						group by idx_col.object_id,idx_col.index_id
					) partition_def on idx.object_id = partition_def.object_id and idx.index_id = partition_def.index_id
					left join (
						select 
							idx_col.object_id
							,idx_col.index_id
							,string_agg(convert(NVARCHAR(max)
								,[dbo].[GET_WRAP_NAME](c.name)
							),',') within group(order by c.name)
							included_columns_definition
						from sys.index_columns idx_col
						join sys.columns c on c.object_id = idx_col.object_id and c.column_id = idx_col.column_id
						where is_included_column>0 and key_ordinal=0
						group by idx_col.object_id,idx_col.index_id
					) included_col_def on idx.object_id = included_col_def.object_id and idx.index_id = included_col_def.index_id
					where idx.object_id = object_id(@SOURCE_FULL_TABLE_NAME,'U')
						and idx.is_primary_key = 0 and idx.is_unique_constraint = 0
				)t                
			);
			print 'create table index sql is :'+@sql;
			exec sp_executesql @sql;
		END

		COMMIT TRANSACTION COPY_TBL_STRUC_TRAN;
    END TRY  
    BEGIN CATCH
		exec [dbo].[PRINT_ERROR_MSG];
        if @@trancount > 0
            ROLLBACK TRANSACTION COPY_TBL_STRUC_SAVE_POINT;
            COMMIT TRANSACTION COPY_TBL_STRUC_TRAN;

        select 
            @error_msg = ERROR_MESSAGE()
            ,@error_severity = ERROR_SEVERITY()
            ,@error_state = ERROR_STATE()
        RAISERROR(@error_msg,@error_severity,@error_state);
    END CATCH
END