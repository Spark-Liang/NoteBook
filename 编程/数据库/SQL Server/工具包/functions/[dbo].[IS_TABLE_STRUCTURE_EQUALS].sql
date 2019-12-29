-- #############################################################
-- This function is to compare whether the given tables are equal or not.
--
-- Currenlty this function will compare the table on different level.
-- First is column level, we will compare 
-- 
-- Then is index level,
-- 
-- Then is 
-- @CONTROL_STR is to control this function's action. For example, skip comparing the data in the table.
-- You can add the item with ',' as deliminator to enable some feature of the function.
-- Currently, @CONTROL_STR support the following items:
--		1. SKIP_INDEXES
--		2. SKIP_TABLE_LEVEL_CONSTRAINTS
--		3. SKIP_PARTITIONS
--
-- This function return xml. The XML structure is listed as follow:
-- <Result>
--     <Value></Value>
--     <DetailMessage></DetailMessage>
-- </Result>
-- 
-- #############################################################

DROP FUNCTION if exists [dbo].[IS_TABLE_STRUCTURE_EQUALS];
GO

CREATE FUNCTION [dbo].[IS_TABLE_STRUCTURE_EQUALS](
    @EXPECTED_TABLE_FULL_NAME as NVARCHAR(1024)
    ,@ACTUAL_TABLE_FULL_NAME as NVARCHAR(1024)
    ,@CONTROL_STR as NVARCHAR(max)=''
)
returns XML
BEGIN

    declare @IS_FIELD_COMPARATION_PASS as BIT;
    declare @IS_FIELD_COMPARATION_MSG as NVARCHAR(max);
    
    declare @IS_INDEX_COMPARATION_PASS as BIT;
    declare @IS_INDEX_COMPARATION_MSG as NVARCHAR(max);
    
    declare @IS_CONSTRAIN_COMPARATION_PASS as BIT;
    declare @IS_CONSTRAIN_COMPARATION_MSG as NVARCHAR(max);

    declare @IS_PARTITION_BOUNDARY_COMPARATION_PASS as BIT;
    declare @IS_PARTITION_BOUNDARY_COMPARATION_MSG as NVARCHAR(max);

    --  config common variable
	declare @CONTROL_ITEMS as table (
		item NVARCHAR(4000)
	);
	insert into @CONTROL_ITEMS
	select 
		value
	from string_split(@CONTROL_STR,',')
	;
    
    with column_info as (
        select 
            c.*
            -- for calculation field
            ,calc_c.definition              calc_field_definition
            ,calc_c.uses_database_collation calc_field_uses_database_collation
            ,calc_c.is_persisted            calc_field_is_persisted
            -- for calculation field
            -- for field's default constraion definition
            ,c_default.definition           field_default_definition
            -- for field's default constraion definition
            -- for field's check constraion definition
            ,c_check.definition             fleld_check_definition
            -- for field's check constraion definition
        from sys.columns c
        left join sys.computed_columns calc_c on 
            c.object_id = calc_c.object_id
            and c.column_id = calc_c.column_id
        left join sys.default_constraints c_default on 
            c.object_id = c_default.parent_object_id 
            and c.column_id = c_default.parent_column_id
        left join sys.check_constraints c_check on 
            c.object_id = c_check.parent_object_id 
            and c.column_id = c_check.parent_column_id
            and c_check.parent_column_id <> 0
    )
    select 
        @IS_FIELD_COMPARATION_PASS=iif(
            count(*)=sum(iif(FailedReason='',1,0))
            ,1,0
        )
        ,@IS_FIELD_COMPARATION_MSG = 
            '<FieldComparation>'
            +STRING_AGG(CONVERT(NVARCHAR(max)
                ,iif(
                    FailedReason=''
                    ,'','<Field><Name>'+[name]+'</Name><FailedReason>
					'+FailedReason+'
					</FailedReason></Field>'+CHAR(10)
                )
            ),'')+
            '</FieldComparation>'
    from (
        SELECT
            expected.name
            ,iif(
                expected.user_type_id = actual.user_type_id 
                and expected.max_length = actual.max_length
                and expected.precision = actual.precision
                and expected.scale = actual.scale
                and expected.is_nullable = actual.is_nullable
                and (
                    expected.collation_name is null or (
                        expected.collation_name = actual.collation_name
                    )
                )
                ,'','<FieldDataTypeNotEqual/>'
            )+iif(
                (0 = expected.is_computed and expected.is_computed = actual.is_computed)
                or (
                    1 = expected.is_computed 
                    and expected.is_computed = actual.is_computed 
                    and expected.field_default_definition = actual.field_default_definition
                )
                ,'','<CalculationFieldDefinitionNotEqual/>'
            ) + iif(
                (expected.field_default_definition is null and actual.field_default_definition is null)
                or expected.field_default_definition = actual.field_default_definition
                ,'','<FieldDefaultDefinitionNotEqual/>'
            ) + iif(
                (expected.fleld_check_definition is null and actual.fleld_check_definition is null)
                or expected.fleld_check_definition = actual.fleld_check_definition
                ,'','<FieldCheckDefinitionNotEqual/>'
            ) 
			FailedReason
        from (
            select * 
            from column_info
            where object_id = object_id(@EXPECTED_TABLE_FULL_NAME)
        ) expected 
        left join (
            select *
            from column_info
            where object_id = object_id(@ACTUAL_TABLE_FULL_NAME)
        ) actual ON expected.name = actual.name
    )t
    ; 
    -- compare table's index 
    with index_info as (
        select 
            idx.*
            ,key_columns_definition
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
        ) partition_key_def on idx.object_id = partition_key_def.object_id and idx.index_id = partition_key_def.index_id
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
            where is_included_column>0
            group by idx_col.object_id,idx_col.index_id
        ) included_col_def on idx.object_id = included_col_def.object_id and idx.index_id = included_col_def.index_id
                
    )
    select 
        @IS_INDEX_COMPARATION_PASS=iif(
            count(*)=sum(iif(FailedReason='',1,0))
            ,1,0
        )
        ,@IS_INDEX_COMPARATION_MSG =
            '<IndexComparation>'
            +STRING_AGG(CONVERT(NVARCHAR(MAX)
                ,iif(
                    FailedReason = ''
                    ,''
					,'<Index><IndexId>'+convert(nvarchar(10),[index_id])+'</IndexId><FailedReason>'+
                        FailedReason
                    +'</FailedReason></Index>'+CHAR(10)
                )
            ),'')+
            '</IndexComparation>'
    from (
        select 
            expected.index_id
            ,expected.name
            ,iif(
				expected.type = actual.type
				,'','<IndexTypeNotEqual/>'+CHAR(10)
			)+ iif(
				expected.is_unique = actual.is_unique
				,'','<IndexUniquenessNotEqual/>'+CHAR(10)
			)+ iif(
				expected.ignore_dup_key = actual.ignore_dup_key
				,'','<IndexIgnoreDupKeyNotEqual/>'+CHAR(10)
			)+ iif(
				expected.is_primary_key = actual.is_primary_key
				,'','<IndexIsPrimaryKeyNotEqual/>'+CHAR(10)
			)+ iif(
				expected.is_unique_constraint = actual.is_unique_constraint
				,'','<IndexIsUniqueConstraintNotEqual/>'+CHAR(10)
			)+ iif(
				expected.fill_factor = actual.fill_factor
				,'','<IndexFillFactorNotEqual/>'+CHAR(10)
			)+ iif(
				expected.is_padded = actual.is_padded
				,'','<IndexIsPaddedNotEqual/>'+CHAR(10)
			)+ iif(
				expected.is_disabled = actual.is_disabled
				,'','<IndexIsDisableNotEqual/>'+CHAR(10)
			)+ iif(
				expected.is_hypothetical = actual.is_hypothetical
				,'','<IndexIsHypotheticalNotEqual/>'+CHAR(10)
			)+ iif(
				expected.allow_row_locks = actual.allow_row_locks
				,'','<IndexAllowRowLocksNotEqual/>'+CHAR(10)
			)+ iif(
				expected.allow_page_locks = actual.allow_page_locks
				,'','<IndexAllowPageLocksNotEqual/>'+CHAR(10)
			)+ iif(
                (expected.filter_definition is null and actual.filter_definition is NULL)
					or expected.filter_definition=actual.filter_definition
                ,'','<IndexFilterDefinitionNotEqual/>'+CHAR(10)
            )+ iif(
				(expected.key_columns_definition is null and actual.key_columns_definition is null)
					or expected.key_columns_definition = actual.key_columns_definition
                ,'','<IndexKeyColumnsDefinitionNotEqual><Expected>'
						+coalesce(expected.key_columns_definition,'')
						+'</Expected><Actual>'
						+coalesce(actual.key_columns_definition,'')
					+'</Actual></IndexKeyColumnsDefinitionNotEqual>'+CHAR(10)
            )+ iif(
				'SKIP_PARTITIONS' in (select item from @CONTROL_ITEMS)
					or (expected.partition_columns_definition is null and actual.partition_columns_definition is null)
                    or expected.partition_columns_definition = actual.partition_columns_definition
                ,'','<IndexPartitionColumnsDefinitionNotEqual><Expected>'
						+coalesce(expected.partition_columns_definition,'')
						+'</Expected><Actual>'
						+coalesce(actual.partition_columns_definition,'')
					+'</Actual></IndexPartitionColumnsDefinitionNotEqual>'+CHAR(10)
            )
            + iif(
                (expected.included_columns_definition is null and actual.included_columns_definition is null)
                    or expected.included_columns_definition = actual.included_columns_definition
                ,'','<IndexIncludeColumnsDefinitionNotEqual><Expected>'
						+coalesce(expected.included_columns_definition,'')
						+'</Expected><Actual>'
						+coalesce(actual.included_columns_definition,'')
					+'</Actual></IndexIncludeColumnsDefinitionNotEqual>'+CHAR(10)
            )
            FailedReason
        from (
            select * from index_info where object_id = object_id(@EXPECTED_TABLE_FULL_NAME)
        ) expected 
        left join (
            select * from index_info where object_id = object_id(@ACTUAL_TABLE_FULL_NAME)
        ) actual ON expected.index_id = actual.index_id
    )t
    ;

    -- compare table's constrain 
    -- currently will validate primary key constraints and check constraints.
    with constraint_info as (
        select 
            t.object_id
			,key_def.key_definition_str
            ,check_def.table_level_check_def
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
    ), expected as (
		select * from constraint_info where object_id = object_id(@EXPECTED_TABLE_FULL_NAME,'U')
	), actual as (
		select * from constraint_info where object_id = object_id(@ACTUAL_TABLE_FULL_NAME,'U')
	)
    select 
		@IS_CONSTRAIN_COMPARATION_PASS = iif(
            FailedReason=''
            ,1,0
        )
		,@IS_CONSTRAIN_COMPARATION_MSG = iif(
            FailedReason=''
            ,''
			,'<ConstraintComparation>
			'+FailedReason+'
			</ConstraintComparation>'
        )
	from (
		select 
			iif(
				(select key_definition_str from expected) <> (select key_definition_str from actual)
				,'<KeyDefinitionIsNotEqual><ExpectedKey>'+(select key_definition_str from expected)+'</ExpectedKey></KeyDefinitionIsNotEqual>'
				,''
			)+iif(
				not (
					(select table_level_check_def from expected) is null and (select table_level_check_def from actual) is null
					or (select table_level_check_def from expected) = (select table_level_check_def from actual)
				),'<TableLevelCheckConstraintIsNotEqual/>'+CHAR(10),''
			)as FailedReason
	)t
	;
    
    -- compare table partition boundary
	with partition_info as (
		select 
			t1.*
			,'(
			'+COALESCE(RANGE_BOUNDARY_LIST,'')+'
			)'RANGE_BOUNDARY_LIST
		from (
			select
				TABLE_OBJECT_ID,[PARTITION_COLUMN],[PARTITION_COLUMN_TYPE],[PARTITION_COLUMN_MAX_LENGTH],[PARTITION_COLUMN_PRECISION],[PARTITION_COLUMN_SCALE]
			from [dbo].[TABLE_PARTITION_INFO_SIMPLE]
			group by TABLE_OBJECT_ID,[PARTITION_COLUMN],[PARTITION_COLUMN_TYPE],[PARTITION_COLUMN_MAX_LENGTH],[PARTITION_COLUMN_PRECISION],[PARTITION_COLUMN_SCALE]
		) t1
		left join (
			select
				TABLE_OBJECT_ID
				,STRING_AGG(CONVERT(NVARCHAR(MAX)
					,''''+RANGE_BOUNDARY+''''
				),',') WITHIN GROUP(ORDER BY PARTITION_NUMBER)
				RANGE_BOUNDARY_LIST
			from [dbo].[TABLE_PARTITION_INFO_SIMPLE]
			where [RANGE_BOUNDARY] is not null
			group by TABLE_OBJECT_ID
		)t2 on t1.TABLE_OBJECT_ID = t2.TABLE_OBJECT_ID
	), expected as (
		select * from partition_info where TABLE_OBJECT_ID = object_id(@EXPECTED_TABLE_FULL_NAME,'U')
	), actual as (
		select * from partition_info where TABLE_OBJECT_ID = object_id(@ACTUAL_TABLE_FULL_NAME,'U')
	)
    select 
		@IS_PARTITION_BOUNDARY_COMPARATION_PASS = iif(
            FailedReason=''
            ,1,0
        )
		,@IS_PARTITION_BOUNDARY_COMPARATION_MSG = iif(
            FailedReason=''
            ,''
			,'<PartitionBoundaryComparation>
			'+FailedReason+'
			</PartitionBoundaryComparation>'
        )
	from (
		select 
			iif(
				(select [PARTITION_COLUMN] from expected) <> (select [PARTITION_COLUMN] from actual)
				,'<PartitionColumnIsNotEqual/>'+CHAR(10),''
			)+iif(
				(select [PARTITION_COLUMN_TYPE] from expected) <> (select [PARTITION_COLUMN_TYPE] from actual)
				,'<PartitionColumnTypeIsNotEqual/>'+CHAR(10),''
			)+iif(
				(select [PARTITION_COLUMN_MAX_LENGTH] from expected) <> (select [PARTITION_COLUMN_MAX_LENGTH] from actual)
				,'<PartitionColumnMaxLengthIsNotEqual/>'+CHAR(10),''
			)+iif(
				not (
					(select [PARTITION_COLUMN_PRECISION] from expected) = (select [PARTITION_COLUMN_PRECISION] from actual)
				),'<PartitionColumnPrecisionIsNotEqual/>'+CHAR(10),''
			)+iif(
				not (
					(select [PARTITION_COLUMN_SCALE] from expected) = (select [PARTITION_COLUMN_SCALE] from actual)
				),'<PartitionColumnScaleIsNotEqual/>'+CHAR(10),''
			)+iif(
				not (
					(select RANGE_BOUNDARY_LIST from expected) = (select RANGE_BOUNDARY_LIST from actual)
				),'<PartitionBoundaryValueListIsNotEqual/>'+CHAR(10),''
			)as FailedReason
	)t
	;

    return convert(
        XML
        ,
'<Result>
    <Value>'+iif(
            @IS_FIELD_COMPARATION_PASS = 1
            and ('SKIP_INDEXES' in (select item from @CONTROL_ITEMS) or @IS_INDEX_COMPARATION_PASS=1)
            and ('SKIP_TABLE_LEVEL_CONSTRAINTS' in (select item from @CONTROL_ITEMS) or @IS_CONSTRAIN_COMPARATION_PASS=1)
			and ('SKIP_PARTITIONS' in (select item from @CONTROL_ITEMS) or @IS_PARTITION_BOUNDARY_COMPARATION_PASS=1)
        ,'true','false')+'</Value>
    <DetailMessage>'
        +coalesce(@IS_FIELD_COMPARATION_MSG,'')
        +coalesce(@IS_INDEX_COMPARATION_MSG,'')
        +coalesce(@IS_CONSTRAIN_COMPARATION_MSG,'')
		+coalesce(@IS_PARTITION_BOUNDARY_COMPARATION_MSG,'')
    +'</DetailMessage>
</Result>')
END

