-- ####################################################################################
-- This function is to generate a hash-based partition function name.

-- ####################################################################################

drop function if exists [dbo].[GET_PARTITION_FUNCTION_NAME];
GO

create function [dbo].[GET_PARTITION_FUNCTION_NAME](
    @SCHEMA_NAME as NVARCHAR(256)
    ,@TABLE_NAME as NVARCHAR(256)
)
RETURNS NVARCHAR(256)
as
BEGIN
    declare @FULL_QUALIFIED_TBL_NM_PATTERN as nvarchar(4000) = '[<SCHEMA_NAME>].[<TABLE_NAME>]';
    declare @FULL_TABLE_NAME as nvarchar(1024) = REPLACE(REPLACE(
        @FULL_QUALIFIED_TBL_NM_PATTERN
        ,N'<SCHEMA_NAME>',@SCHEMA_NAME)
        ,N'<TABLE_NAME>',@TABLE_NAME
    );
    if object_id(@FULL_TABLE_NAME,'U') is not null
        return (
            select top 1 PARTITION_FUNCTION from [dbo].[TABLE_PARTITION_INFO_SIMPLE]
            where SCHEMA_NAME=@SCHEMA_NAME and TABLE_NAME=@TABLE_NAME
        )
    
    declare @PARTITION_FUNCTION as NVARCHAR(256);
    with current_try(FULL_TABLE_NAME,PARTITION_FUNCTION_NAME,IS_EXISTS,TRY_TIMES) as (
        select 
            FULL_TABLE_NAME
            ,PARTITION_FUNCTION_NAME
            ,iif(
                exists(select 1 from [dbo].[TABLE_PARTITION_INFO_SIMPLE] where PARTITION_FUNCTION=t.PARTITION_FUNCTION_NAME)
                ,1,0
            )IS_EXISTS
            ,0 TRY_TIMES
        from (
            select
            @FULL_TABLE_NAME FULL_TABLE_NAME
            ,convert(varchar(1024),'PATITION_'+convert(nvarchar(32),checksum(@FULL_TABLE_NAME))) PARTITION_FUNCTION_NAME
        )t
        union all 
        select 
            FULL_TABLE_NAME
            ,PARTITION_FUNCTION_NAME
            ,iif(
                exists(select 1 from [dbo].[TABLE_PARTITION_INFO_SIMPLE] where PARTITION_FUNCTION=t.PARTITION_FUNCTION_NAME)
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
        @PARTITION_FUNCTION=PARTITION_FUNCTION_NAME 
    from current_try where IS_EXISTS = 0
    ;
    RETURN @PARTITION_FUNCTION;
END