
-- 	################################## [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnTrueIfIsSameTable] ############################
BEGIN TRAN
BEGIN TRY
	declare @result XML;
    --  given
    drop table if exists [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnTrueIfIsSameTable-1];
    drop table if exists [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnTrueIfIsSameTable-2];

    create partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnTrueIfIsSameTable-1](int)
    as range right 
    for values(1,2);
    create partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnTrueIfIsSameTable-1]
    as partition [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnTrueIfIsSameTable-1]
    all to ([primary]);

    create table [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnTrueIfIsSameTable-1](
        PARTITION_ID int NOT NULL
        ,pk_id int       NOT NULL
        ,str_data varchar(32) default '' check(len(str_data) > 1)
        ,primary key nonclustered (
            PARTITION_ID,pk_id desc
        )
        ,check(PARTITION_ID + pk_id > 0 )
		,check(PARTITION_ID + pk_id + 1 > 1 )
    )ON[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnTrueIfIsSameTable-1](PARTITION_ID)
    ;

    --	when
    set @result = [dbo].[IS_TABLE_STRUCTURE_EQUALS](
        '[dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnTrueIfIsSameTable-1]'
        ,'[dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnTrueIfIsSameTable-1]'
		,''
    )

    --  then
    select 'test_scnario：' test_case,'ReturnTrueIfIsSameTable' result
    union all
    select 'check_if_return_true_if_table_structure_is_equals.' test_case
        ,iif(
            'true' = @result.value('(/Result/Value)[1]','nvarchar(8)')
        ,'pass','failed') result
    ;
	if 'true' <> @result.value('(/Result/Value)[1]','nvarchar(8)')
		select @result.query('/Result/DetailMessage')
	rollback
	END TRY
BEGIN CATCH
    exec [dbo].[PRINT_ERROR_MSG];
    rollback
END CATCH
GO

-- 	################################## [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnTrueIfTableEquals] ############################
BEGIN TRAN
BEGIN TRY
	declare @result XML;
    --  given
    drop table if exists [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnTrueIfTableEquals-1];
    drop table if exists [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnTrueIfTableEquals-2];

    create partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnTrueIfTableEquals-1](int)
    as range right 
    for values(1,2);
    create partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnTrueIfTableEquals-1]
    as partition [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnTrueIfTableEquals-1]
    all to ([primary]);

    create partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnTrueIfTableEquals-2](int)
    as range right 
    for values(1,2);
    create partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnTrueIfTableEquals-2]
    as partition [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnTrueIfTableEquals-2]
    all to ([primary]);

    create table [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnTrueIfTableEquals-1](
        PARTITION_ID int NOT NULL
        ,pk_id int       NOT NULL
        ,str_data varchar(32) default '' check(len(str_data) > 1) 
        ,primary key nonclustered (
            PARTITION_ID,pk_id desc
        )
        ,check(PARTITION_ID + pk_id > 0 )
		,check(PARTITION_ID + pk_id + 1 > 1 )
    )ON[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnTrueIfTableEquals-1](PARTITION_ID)
    ;
    create table [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnTrueIfTableEquals-2](
        PARTITION_ID int NOT NULL
        ,pk_id int       NOT NULL
        ,str_data varchar(32) default '' check(len(str_data) > 1)
        ,primary key nonclustered (
            PARTITION_ID,pk_id desc
        )
        ,check(PARTITION_ID + pk_id > 0 )
		,check(PARTITION_ID + pk_id + 1 > 1 )
    )ON[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnTrueIfTableEquals-2](PARTITION_ID)
    ;

    --	when
    set @result = [dbo].[IS_TABLE_STRUCTURE_EQUALS](
        '[dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnTrueIfTableEquals-1]'
        ,'[dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnTrueIfTableEquals-2]'
		,''
    )

    --  then
    select 'test_scnario：' test_case,'ReturnTrueIfTableEquals' result
    union all
    select 'check_if_return_true_if_table_structure_is_equals.' test_case
        ,iif(
            'true' = @result.value('(/Result/Value)[1]','nvarchar(8)')
        ,'pass','failed') result
    ;
	if 'true' <> @result.value('(/Result/Value)[1]','nvarchar(8)')
		select @result.query('/Result/DetailMessage')

    rollback
END TRY
BEGIN CATCH
    exec [dbo].[PRINT_ERROR_MSG];
    rollback
END CATCH
GO

-- 	################################## [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnDefaultField] ############################
BEGIN TRAN
BEGIN TRY
	declare @result XML;
    --  given
    drop table if exists [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnDefaultField-1];
    drop table if exists [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnDefaultField-2];

	if exists (select 1 from sys.partition_schemes where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnDefaultField-1')
		drop partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnDefaultField-1]
	if exists (select 1 from sys.partition_schemes where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnDefaultField-2')
		drop partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnDefaultField-2]
	if exists (select 1 from sys.partition_functions where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnDefaultField-1')
		drop partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnDefaultField-1]
	if exists (select 1 from sys.partition_functions where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnDefaultField-2')
		drop partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnDefaultField-2]

    create partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnDefaultField-1](int)
    as range right 
    for values(1,2);
    create partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnDefaultField-1]
    as partition [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnDefaultField-1]
    all to ([primary]);

    create partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnDefaultField-2](int)
    as range right 
    for values(1,2);
    create partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnDefaultField-2]
    as partition [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnDefaultField-2]
    all to ([primary]);
	
    create table [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnDefaultField-1](
        PARTITION_ID int NOT NULL
        ,pk_id int       NOT NULL
        ,str_data varchar(32) default '' check(len(str_data) > 1) 
        ,primary key nonclustered (
            PARTITION_ID,pk_id desc
        )
        ,check(PARTITION_ID + pk_id > 0 )
		,check(PARTITION_ID + pk_id + 1 > 1 )
    )ON[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnDefaultField-1](PARTITION_ID)
    ;
    create table [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnDefaultField-2](
        PARTITION_ID int NOT NULL
        ,pk_id int       NOT NULL
        ,str_data varchar(32) check(len(str_data) > 1)
        ,primary key nonclustered (
            PARTITION_ID,pk_id desc
        )
        ,check(PARTITION_ID + pk_id > 0 )
		,check(PARTITION_ID + pk_id + 1 > 1 )
    )ON[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnDefaultField-2](PARTITION_ID)
    ;

    --	when
    set @result = [dbo].[IS_TABLE_STRUCTURE_EQUALS](
        '[dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnDefaultField-1]'
        ,'[dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnDefaultField-2]'
		,''
    )

    --  then
    select 'test_scnario：' test_case,'ReturnFalseIfTableNotEqualsOnDefaultField' result
    union all
    select 'check_if_return_false_if_table_structure_is_not_equals.' test_case
        ,iif(
            'false' = @result.value('(/Result/Value)[1]','nvarchar(8)')
        ,'pass','failed') result
    union all 
	select 'check_if_return_the_correct_error_message.' test_case
        ,iif(
            1 = @result.query('/Result/DetailMessage/FieldComparation/Field[Name=''str_data'']').exist('/Field/FailedReason/FieldDefaultDefinitionNotEqual')
        ,'pass','failed') result
    ;
	if 'false' <> @result.value('(/Result/Value)[1]','nvarchar(8)')
		select @result.query('/Result/DetailMessage')

    rollback
END TRY
BEGIN CATCH
    exec [dbo].[PRINT_ERROR_MSG];
    rollback
END CATCH
GO


-- 	################################## [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckField] ############################
BEGIN TRAN
BEGIN TRY
	declare @result XML;
    --  given
    drop table if exists [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckField-1];
    drop table if exists [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckField-2];

	if exists (select 1 from sys.partition_schemes where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckField-1')
		drop partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckField-1]
	if exists (select 1 from sys.partition_schemes where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckField-2')
		drop partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckField-2]
	if exists (select 1 from sys.partition_functions where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckField-1')
		drop partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckField-1]
	if exists (select 1 from sys.partition_functions where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckField-2')
		drop partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckField-2]

    create partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckField-1](int)
    as range right 
    for values(1,2);
    create partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckField-1]
    as partition [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckField-1]
    all to ([primary]);

    create partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckField-2](int)
    as range right 
    for values(1,2);
    create partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckField-2]
    as partition [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckField-2]
    all to ([primary]);
	
    create table [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckField-1](
        PARTITION_ID int NOT NULL
        ,pk_id int       NOT NULL
        ,str_data varchar(32) check(len(str_data) > 1) 
        ,primary key nonclustered (
            PARTITION_ID,pk_id desc
        )
        ,check(PARTITION_ID + pk_id > 0 )
		,check(PARTITION_ID + pk_id + 1 > 1 )
    )ON[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckField-1](PARTITION_ID)
    ;
    create table [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckField-2](
        PARTITION_ID int NOT NULL
        ,pk_id int       NOT NULL
        ,str_data varchar(32)
        ,primary key nonclustered (
            PARTITION_ID,pk_id desc
        )
        ,check(PARTITION_ID + pk_id > 0 )
		,check(PARTITION_ID + pk_id + 1 > 1 )
    )ON[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckField-2](PARTITION_ID)
    ;

    --	when
    set @result = [dbo].[IS_TABLE_STRUCTURE_EQUALS](
        '[dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckField-1]'
        ,'[dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckField-2]'
		,''
    )

    --  then
    select 'test_scnario：' test_case,'ReturnFalseIfTableNotEqualsOnCheckField' result
    union all
    select 'check_if_return_false_if_table_structure_is_not_equals.' test_case
        ,iif(
            'false' = @result.value('(/Result/Value)[1]','nvarchar(8)')
        ,'pass','failed') result
    union all 
	select 'check_if_return_the_correct_error_message.' test_case
        ,iif(
            1 = @result.query('/Result/DetailMessage/FieldComparation/Field[Name=''str_data'']').exist('/Field/FailedReason/FieldCheckDefinitionNotEqual')
        ,'pass','failed') result
    ;
	if 'false' <> @result.value('(/Result/Value)[1]','nvarchar(8)')
		select @result.query('/Result/DetailMessage')

    rollback
END TRY
BEGIN CATCH
    exec [dbo].[PRINT_ERROR_MSG];
    rollback
END CATCH
GO


-- 	################################## [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckFields] ############################
BEGIN TRAN
BEGIN TRY
	declare @result XML;
    --  given
    drop table if exists [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckFields-1];
    drop table if exists [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckFields-2];

	if exists (select 1 from sys.partition_schemes where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckFields-1')
		drop partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckFields-1]
	if exists (select 1 from sys.partition_schemes where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckFields-2')
		drop partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckFields-2]
	if exists (select 1 from sys.partition_functions where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckFields-1')
		drop partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckFields-1]
	if exists (select 1 from sys.partition_functions where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckFields-2')
		drop partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckFields-2]

    create partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckFields-1](int)
    as range right 
    for values(1,2);
    create partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckFields-1]
    as partition [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckFields-1]
    all to ([primary]);

    create partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckFields-2](int)
    as range right 
    for values(1,2);
    create partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckFields-2]
    as partition [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckFields-2]
    all to ([primary]);
	
    create table [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckFields-1](
        PARTITION_ID int NOT NULL
        ,pk_id int       NOT NULL
        ,str_data varchar(32) check(len(str_data) > 1) 
        ,primary key nonclustered (
            PARTITION_ID,pk_id desc
        )
        ,check(PARTITION_ID + pk_id > 0 )
		,check(PARTITION_ID + pk_id + 1 > 1 )
    )ON[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckFields-1](PARTITION_ID)
    ;
    create table [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckFields-2](
        PARTITION_ID int NOT NULL
        ,pk_id int       NOT NULL
        ,str_data varchar(32)
        ,primary key nonclustered (
            PARTITION_ID,pk_id desc
        )
        ,check(PARTITION_ID + pk_id > 0 )
    )ON[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckFields-2](PARTITION_ID)
    ;

    --	when
    set @result = [dbo].[IS_TABLE_STRUCTURE_EQUALS](
        '[dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckFields-1]'
        ,'[dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnCheckFields-2]'
		,''
    )

    --  then
    select 'test_scnario：' test_case,'ReturnFalseIfTableNotEqualsOnCheckFields' result
    union all
    select 'check_if_return_false_if_table_structure_is_not_equals.' test_case
        ,iif(
            'false' = @result.value('(/Result/Value)[1]','nvarchar(8)')
        ,'pass','failed') result
    union all 
	select 'check_if_return_the_correct_error_message.' test_case
        ,iif(
            1 = @result.exist('/Result/DetailMessage/ConstraintComparation/TableLevelCheckConstraintIsNotEqual')
        ,'pass','failed') result
    ;
	if 'false' <> @result.value('(/Result/Value)[1]','nvarchar(8)')
		select @result.query('/Result/DetailMessage')

    rollback
END TRY
BEGIN CATCH
    exec [dbo].[PRINT_ERROR_MSG];
    rollback
END CATCH
GO

-- 	################################## [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnNotNullField] ############################
BEGIN TRAN
BEGIN TRY
	declare @result XML;
    --  given
    drop table if exists [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnNotNullField-1];
    drop table if exists [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnNotNullField-2];

	if exists (select 1 from sys.partition_schemes where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnNotNullField-1')
		drop partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnNotNullField-1]
	if exists (select 1 from sys.partition_schemes where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnNotNullField-2')
		drop partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnNotNullField-2]
	if exists (select 1 from sys.partition_functions where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnNotNullField-1')
		drop partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnNotNullField-1]
	if exists (select 1 from sys.partition_functions where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnNotNullField-2')
		drop partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnNotNullField-2]

    create partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnNotNullField-1](int)
    as range right 
    for values(1,2);
    create partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnNotNullField-1]
    as partition [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnNotNullField-1]
    all to ([primary]);

    create partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnNotNullField-2](int)
    as range right 
    for values(1,2);
    create partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnNotNullField-2]
    as partition [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnNotNullField-2]
    all to ([primary]);
	
    create table [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnNotNullField-1](
        PARTITION_ID int NOT NULL
        ,pk_id int       NOT NULL
        ,str_data varchar(32) not null
        ,primary key nonclustered (
            PARTITION_ID,pk_id desc
        )
        ,check(PARTITION_ID + pk_id > 0 )
		,check(PARTITION_ID + pk_id + 1 > 1 )
    )ON[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnNotNullField-1](PARTITION_ID)
    ;
    create table [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnNotNullField-2](
        PARTITION_ID int NOT NULL
        ,pk_id int       NOT NULL
        ,str_data varchar(32)
        ,primary key nonclustered (
            PARTITION_ID,pk_id desc
        )
        ,check(PARTITION_ID + pk_id > 0 )
		,check(PARTITION_ID + pk_id + 1 > 1 )
    )ON[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnNotNullField-2](PARTITION_ID)
    ;

    --	when
    set @result = [dbo].[IS_TABLE_STRUCTURE_EQUALS](
        '[dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnNotNullField-1]'
        ,'[dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnNotNullField-2]'
		,''
    )

    --  then
    select 'test_scnario：' test_case,'ReturnFalseIfTableNotEqualsOnNotNullField' result
    union all
    select 'check_if_return_false_if_table_structure_is_not_equals.' test_case
        ,iif(
            'false' = @result.value('(/Result/Value)[1]','nvarchar(8)')
        ,'pass','failed') result
    union all 
	select 'check_if_return_the_correct_error_message.' test_case
        ,iif(
            1 = @result.query('/Result/DetailMessage/FieldComparation/Field[Name=''str_data'']').exist('/Field/FailedReason/FieldDataTypeNotEqual')
        ,'pass','failed') result
    ;
	if 'false' <> @result.value('(/Result/Value)[1]','nvarchar(8)')
		select @result.query('/Result/DetailMessage')

    rollback
END TRY
BEGIN CATCH
    exec [dbo].[PRINT_ERROR_MSG];
    rollback
END CATCH
GO


-- 	################################## [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueField] ############################
BEGIN TRAN
BEGIN TRY
	declare @result XML;
    --  given
    drop table if exists [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueField-1];
    drop table if exists [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueField-2];

	if exists (select 1 from sys.partition_schemes where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueField-1')
		drop partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueField-1]
	if exists (select 1 from sys.partition_schemes where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueField-2')
		drop partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueField-2]
	if exists (select 1 from sys.partition_functions where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueField-1')
		drop partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueField-1]
	if exists (select 1 from sys.partition_functions where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueField-2')
		drop partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueField-2]

    create partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueField-1](int)
    as range right 
    for values(1,2);
    create partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueField-1]
    as partition [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueField-1]
    all to ([primary]);

    create partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueField-2](int)
    as range right 
    for values(1,2);
    create partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueField-2]
    as partition [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueField-2]
    all to ([primary]);
	
    create table [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueField-1](
        PARTITION_ID int NOT NULL unique
        ,pk_id int       NOT NULL
        ,str_data varchar(32) 
        ,primary key nonclustered (
            PARTITION_ID,pk_id desc
        )
        ,check(PARTITION_ID + pk_id > 0 )
		,check(PARTITION_ID + pk_id + 1 > 1 )
    )ON[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueField-1](PARTITION_ID)
    ;
    create table [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueField-2](
        PARTITION_ID int NOT NULL
        ,pk_id int       NOT NULL
        ,str_data varchar(32)
        ,primary key nonclustered (
            PARTITION_ID,pk_id desc
        )
        ,check(PARTITION_ID + pk_id > 0 )
		,check(PARTITION_ID + pk_id + 1 > 1 )
    )ON[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueField-2](PARTITION_ID)
    ;

    --	when
    set @result = [dbo].[IS_TABLE_STRUCTURE_EQUALS](
        '[dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueField-1]'
        ,'[dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueField-2]'
		,''
    )

    --  then
    select 'test_scnario：' test_case,'ReturnFalseIfTableNotEqualsOnUniqueField' result
    union all
    select 'check_if_return_false_if_table_structure_is_not_equals.' test_case
        ,iif(
            'false' = @result.value('(/Result/Value)[1]','nvarchar(8)')
        ,'pass','failed') result
    union all 
	select 'check_if_return_the_correct_error_message.' test_case
        ,iif(
            1 = @result.exist('/Result/DetailMessage/ConstraintComparation/KeyDefinitionIsNotEqual')
        ,'pass','failed') result
    ;
	if 'false' <> @result.value('(/Result/Value)[1]','nvarchar(8)')
		select @result.query('/Result/DetailMessage')

    rollback
END TRY
BEGIN CATCH
    exec [dbo].[PRINT_ERROR_MSG];
    rollback
END CATCH
GO

-- 	################################## [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueFields]: Can distinguish the difference on table unique key.  ############################
BEGIN TRAN
BEGIN TRY
	declare @result XML;
    --  given
    drop table if exists [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueFields-1];
    drop table if exists [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueFields-2];

	if exists (select 1 from sys.partition_schemes where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueFields-1')
		drop partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueFields-1]
	if exists (select 1 from sys.partition_schemes where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueFields-2')
		drop partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueFields-2]
	if exists (select 1 from sys.partition_functions where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueFields-1')
		drop partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueFields-1]
	if exists (select 1 from sys.partition_functions where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueFields-2')
		drop partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueFields-2]

    create partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueFields-1](int)
    as range right 
    for values(1,2);
    create partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueFields-1]
    as partition [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueFields-1]
    all to ([primary]);

    create partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueFields-2](int)
    as range right 
    for values(1,2);
    create partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueFields-2]
    as partition [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueFields-2]
    all to ([primary]);
	
    create table [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueFields-1](
        PARTITION_ID int NOT NULL
        ,pk_id int       NOT NULL
        ,str_data varchar(32) 
        ,primary key nonclustered (
            PARTITION_ID,pk_id desc
        )
        ,check(PARTITION_ID + pk_id > 0 )
		,check(PARTITION_ID + pk_id + 1 > 1 )
		,unique(PARTITION_ID,str_data)
    )ON[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueFields-1](PARTITION_ID)
    ;
    create table [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueFields-2](
        PARTITION_ID int NOT NULL
        ,pk_id int       NOT NULL
        ,str_data varchar(32)
        ,primary key nonclustered (
            PARTITION_ID,pk_id desc
        )
        ,check(PARTITION_ID + pk_id > 0 )
		,check(PARTITION_ID + pk_id + 1 > 1 )
    )ON[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueFields-2](PARTITION_ID)
    ;

    --	when
    set @result = [dbo].[IS_TABLE_STRUCTURE_EQUALS](
        '[dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueFields-1]'
        ,'[dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnUniqueFields-2]'
		,''
    )

    --  then
    select 'test_scnario：' test_case,'ReturnFalseIfTableNotEqualsOnUniqueFields' result
    union all
    select 'check_if_return_false_if_table_structure_is_not_equals.' test_case
        ,iif(
            'false' = @result.value('(/Result/Value)[1]','nvarchar(8)')
        ,'pass','failed') result
    union all 
	select 'check_if_return_the_correct_error_message.' test_case
        ,iif(
            1 = @result.exist('/Result/DetailMessage/ConstraintComparation/KeyDefinitionIsNotEqual')
        ,'pass','failed') result
    ;
	if 'false' <> @result.value('(/Result/Value)[1]','nvarchar(8)')
		select @result.query('/Result/DetailMessage')

    rollback
END TRY
BEGIN CATCH
    exec [dbo].[PRINT_ERROR_MSG];
    rollback
END CATCH
GO


-- 	################################## [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFields]: Can distinguish the difference on table primary key.  ############################
BEGIN TRAN
BEGIN TRY
	declare @result XML;
    --  given
    drop table if exists [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFields-1];
    drop table if exists [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFields-2];

	if exists (select 1 from sys.partition_schemes where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFields-1')
		drop partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFields-1]
	if exists (select 1 from sys.partition_schemes where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFields-2')
		drop partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFields-2]
	if exists (select 1 from sys.partition_functions where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFields-1')
		drop partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFields-1]
	if exists (select 1 from sys.partition_functions where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFields-2')
		drop partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFields-2]

    create partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFields-1](int)
    as range right 
    for values(1,2);
    create partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFields-1]
    as partition [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFields-1]
    all to ([primary]);

    create partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFields-2](int)
    as range right 
    for values(1,2);
    create partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFields-2]
    as partition [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFields-2]
    all to ([primary]);
	
    create table [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFields-1](
        PARTITION_ID int NOT NULL
        ,pk_id int       NOT NULL
        ,str_data varchar(32) 
        ,primary key nonclustered (
            PARTITION_ID,pk_id desc,str_data
        )
        ,check(PARTITION_ID + pk_id > 0 )
		,check(PARTITION_ID + pk_id + 1 > 1 )
    )ON[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFields-1](PARTITION_ID)
    ;
    create table [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFields-2](
        PARTITION_ID int NOT NULL
        ,pk_id int       NOT NULL
        ,str_data varchar(32)
        ,primary key nonclustered (
            PARTITION_ID,pk_id desc
        )
        ,check(PARTITION_ID + pk_id > 0 )
		,check(PARTITION_ID + pk_id + 1 > 1 )
    )ON[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFields-2](PARTITION_ID)
    ;

    --	when
    set @result = [dbo].[IS_TABLE_STRUCTURE_EQUALS](
        '[dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFields-1]'
        ,'[dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFields-2]'
		,''
    )

    --  then
    select 'test_scnario：' test_case,'ReturnFalseIfTableNotEqualsOnPKFields' result
    union all
    select 'check_if_return_false_if_table_structure_is_not_equals.' test_case
        ,iif(
            'false' = @result.value('(/Result/Value)[1]','nvarchar(8)')
        ,'pass','failed') result
    union all 
	select 'check_if_return_the_correct_error_message.' test_case
        ,iif(
            1 = @result.exist('/Result/DetailMessage/ConstraintComparation/KeyDefinitionIsNotEqual')
        ,'pass','failed') result
    ;
	if 'false' <> @result.value('(/Result/Value)[1]','nvarchar(8)')
		select @result.query('/Result/DetailMessage')

    rollback
END TRY
BEGIN CATCH
    exec [dbo].[PRINT_ERROR_MSG];
    rollback
END CATCH
GO


-- 	################################## [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrder]: Can distinguish the difference on the order of table primary key.  ############################
BEGIN TRAN
BEGIN TRY
	declare @result XML;
    --  given
    drop table if exists [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrder-1];
    drop table if exists [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrder-2];

	if exists (select 1 from sys.partition_schemes where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrder-1')
		drop partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrder-1]
	if exists (select 1 from sys.partition_schemes where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrder-2')
		drop partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrder-2]
	if exists (select 1 from sys.partition_functions where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrder-1')
		drop partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrder-1]
	if exists (select 1 from sys.partition_functions where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrder-2')
		drop partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrder-2]

    create partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrder-1](int)
    as range right 
    for values(1,2);
    create partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrder-1]
    as partition [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrder-1]
    all to ([primary]);

    create partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrder-2](int)
    as range right 
    for values(1,2);
    create partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrder-2]
    as partition [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrder-2]
    all to ([primary]);
	
    create table [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrder-1](
        PARTITION_ID int NOT NULL
        ,pk_id int       NOT NULL
        ,str_data varchar(32) 
        ,primary key nonclustered (
            pk_id desc,PARTITION_ID
        )
        ,check(PARTITION_ID + pk_id > 0 )
		,check(PARTITION_ID + pk_id + 1 > 1 )
    )ON[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrder-1](PARTITION_ID)
    ;
    create table [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrder-2](
        PARTITION_ID int NOT NULL
        ,pk_id int       NOT NULL
        ,str_data varchar(32)
        ,primary key nonclustered (
            PARTITION_ID,pk_id desc
        )
        ,check(PARTITION_ID + pk_id > 0 )
		,check(PARTITION_ID + pk_id + 1 > 1 )
    )ON[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrder-2](PARTITION_ID)
    ;

    --	when
    set @result = [dbo].[IS_TABLE_STRUCTURE_EQUALS](
        '[dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrder-1]'
        ,'[dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrder-2]'
		,''
    )

    --  then
    select 'test_scnario：' test_case,'ReturnFalseIfTableNotEqualsOnPKFieldOrder' result
    union all
    select 'check_if_return_false_if_table_structure_is_not_equals.' test_case
        ,iif(
            'false' = @result.value('(/Result/Value)[1]','nvarchar(8)')
        ,'pass','failed') result
    union all 
	select 'check_if_return_the_correct_error_message.' test_case
        ,iif(
            1 = @result.exist('/Result/DetailMessage/ConstraintComparation/KeyDefinitionIsNotEqual')
        ,'pass','failed') result
    ;
	if 'false' <> @result.value('(/Result/Value)[1]','nvarchar(8)')
		select @result.query('/Result/DetailMessage')

    rollback
END TRY
BEGIN CATCH
    exec [dbo].[PRINT_ERROR_MSG];
    rollback
END CATCH
GO


-- 	################################## [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrderApproach]: Can distinguish the difference on the approach of ordering the table primary key columns.  ############################
BEGIN TRAN
BEGIN TRY
	declare @result XML;
    --  given
    drop table if exists [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrderApproach-1];
    drop table if exists [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrderApproach-2];

	if exists (select 1 from sys.partition_schemes where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrderApproach-1')
		drop partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrderApproach-1]
	if exists (select 1 from sys.partition_schemes where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrderApproach-2')
		drop partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrderApproach-2]
	if exists (select 1 from sys.partition_functions where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrderApproach-1')
		drop partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrderApproach-1]
	if exists (select 1 from sys.partition_functions where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrderApproach-2')
		drop partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrderApproach-2]

    create partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrderApproach-1](int)
    as range right 
    for values(1,2);
    create partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrderApproach-1]
    as partition [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrderApproach-1]
    all to ([primary]);

    create partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrderApproach-2](int)
    as range right 
    for values(1,2);
    create partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrderApproach-2]
    as partition [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrderApproach-2]
    all to ([primary]);
	
    create table [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrderApproach-1](
        PARTITION_ID int NOT NULL
        ,pk_id int       NOT NULL
        ,str_data varchar(32) 
        ,primary key nonclustered (
            PARTITION_ID,pk_id
        )
        ,check(PARTITION_ID + pk_id > 0 )
		,check(PARTITION_ID + pk_id + 1 > 1 )
    )ON[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrderApproach-1](PARTITION_ID)
    ;
    create table [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrderApproach-2](
        PARTITION_ID int NOT NULL
        ,pk_id int       NOT NULL
        ,str_data varchar(32)
        ,primary key nonclustered (
            PARTITION_ID,pk_id desc
        )
        ,check(PARTITION_ID + pk_id > 0 )
		,check(PARTITION_ID + pk_id + 1 > 1 )
    )ON[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrderApproach-2](PARTITION_ID)
    ;

    --	when
    set @result = [dbo].[IS_TABLE_STRUCTURE_EQUALS](
        '[dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrderApproach-1]'
        ,'[dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPKFieldOrderApproach-2]'
		,''
    )

    --  then
    select 'test_scnario：' test_case,'ReturnFalseIfTableNotEqualsOnPKFieldOrderApproach' result
    union all
    select 'check_if_return_false_if_table_structure_is_not_equals.' test_case
        ,iif(
            'false' = @result.value('(/Result/Value)[1]','nvarchar(8)')
        ,'pass','failed') result
    union all 
	select 'check_if_return_the_correct_error_message.' test_case
        ,iif(
            1 = @result.exist('/Result/DetailMessage/ConstraintComparation/KeyDefinitionIsNotEqual')
        ,'pass','failed') result
    ;
	if 'false' <> @result.value('(/Result/Value)[1]','nvarchar(8)')
		select @result.query('/Result/DetailMessage')

    rollback
END TRY
BEGIN CATCH
    exec [dbo].[PRINT_ERROR_MSG];
    rollback
END CATCH
GO


-- 	################################## [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionSplitPoints]: Can distinguish the difference on the approach of ordering the table primary key columns.  ############################
BEGIN TRAN
BEGIN TRY
	declare @result XML;
    --  given
    drop table if exists [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionSplitPoints-1];
    drop table if exists [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionSplitPoints-2];

	if exists (select 1 from sys.partition_schemes where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionSplitPoints-1')
		drop partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionSplitPoints-1]
	if exists (select 1 from sys.partition_schemes where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionSplitPoints-2')
		drop partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionSplitPoints-2]
	if exists (select 1 from sys.partition_functions where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionSplitPoints-1')
		drop partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionSplitPoints-1]
	if exists (select 1 from sys.partition_functions where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionSplitPoints-2')
		drop partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionSplitPoints-2]

    create partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionSplitPoints-1](int)
    as range right 
    for values(1,2,3);
    create partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionSplitPoints-1]
    as partition [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionSplitPoints-1]
    all to ([primary]);

    create partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionSplitPoints-2](int)
    as range right 
    for values(1,2);
    create partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionSplitPoints-2]
    as partition [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionSplitPoints-2]
    all to ([primary]);
	
    create table [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionSplitPoints-1](
        PARTITION_ID int NOT NULL
        ,pk_id int       NOT NULL
        ,str_data varchar(32) 
        ,primary key nonclustered (
            PARTITION_ID,pk_id desc
        )
        ,check(PARTITION_ID + pk_id > 0 )
		,check(PARTITION_ID + pk_id + 1 > 1 )
    )ON[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionSplitPoints-1](PARTITION_ID)
    ;
    create table [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionSplitPoints-2](
        PARTITION_ID int NOT NULL
        ,pk_id int       NOT NULL
        ,str_data varchar(32)
        ,primary key nonclustered (
            PARTITION_ID,pk_id desc
        )
        ,check(PARTITION_ID + pk_id > 0 )
		,check(PARTITION_ID + pk_id + 1 > 1 )
    )ON[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionSplitPoints-2](PARTITION_ID)
    ;

    --	when
    set @result = [dbo].[IS_TABLE_STRUCTURE_EQUALS](
        '[dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionSplitPoints-1]'
        ,'[dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionSplitPoints-2]'
		,''
    )

    --  then
    select 'test_scnario：' test_case,'ReturnFalseIfTableNotEqualsOnPartitionSplitPoints' result
    union all
    select 'check_if_return_false_if_table_structure_is_not_equals.' test_case
        ,iif(
            'false' = @result.value('(/Result/Value)[1]','nvarchar(8)')
        ,'pass','failed') result
    union all 
	select 'check_if_return_the_correct_error_message.' test_case
        ,iif(
            1 = @result.exist('/Result/DetailMessage/PartitionBoundaryComparation/PartitionBoundaryValueListIsNotEqual')
        ,'pass','failed') result
    ;
	if 'false' <> @result.value('(/Result/Value)[1]','nvarchar(8)')
		select @result.query('/Result/DetailMessage')

    rollback
END TRY
BEGIN CATCH
    exec [dbo].[PRINT_ERROR_MSG];
    rollback
END CATCH
GO


-- 	################################## [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionColumn]: Can distinguish the difference on the approach of ordering the table primary key columns.  ############################
BEGIN TRAN
BEGIN TRY
	declare @result XML;
    --  given
    drop table if exists [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionColumn-1];
    drop table if exists [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionColumn-2];

	if exists (select 1 from sys.partition_schemes where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionColumn-1')
		drop partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionColumn-1]
	if exists (select 1 from sys.partition_schemes where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionColumn-2')
		drop partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionColumn-2]
	if exists (select 1 from sys.partition_functions where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionColumn-1')
		drop partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionColumn-1]
	if exists (select 1 from sys.partition_functions where name ='TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionColumn-2')
		drop partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionColumn-2]

    create partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionColumn-1](int)
    as range right 
    for values(1,2,3);
    create partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionColumn-1]
    as partition [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionColumn-1]
    all to ([primary]);

    create partition function [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionColumn-2](int)
    as range right 
    for values(1,2);
    create partition scheme [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionColumn-2]
    as partition [TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionColumn-2]
    all to ([primary]);
	
    create table [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionColumn-1](
        PARTITION_ID int NOT NULL
        ,PARTITION_ID_1 int NOT NULL
		,pk_id int       NOT NULL
        ,str_data varchar(32) 
        ,primary key nonclustered (
            PARTITION_ID,pk_id desc,PARTITION_ID_1
        )
        ,check(PARTITION_ID + pk_id > 0 )
		,check(PARTITION_ID + pk_id + 1 > 1 )
    )ON[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionColumn-1](PARTITION_ID)
    ;
    create table [dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionColumn-2](
        PARTITION_ID int NOT NULL
		,PARTITION_ID_1 int NOT NULL
        ,pk_id int       NOT NULL
        ,str_data varchar(32)
        ,primary key nonclustered (
            PARTITION_ID,pk_id desc,PARTITION_ID_1
        )
        ,check(PARTITION_ID + pk_id > 0 )
		,check(PARTITION_ID + pk_id + 1 > 1 )
    )ON[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionColumn-2](PARTITION_ID_1)
    ;

    --	when
    set @result = [dbo].[IS_TABLE_STRUCTURE_EQUALS](
        '[dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionColumn-1]'
        ,'[dbo].[TC-IS_TABLE_STRUCTURE_EQUALS-ReturnFalseIfTableNotEqualsOnPartitionColumn-2]'
		,''
    )

    --  then
    select 'test_scnario：' test_case,'ReturnFalseIfTableNotEqualsOnPartitionColumn' result
    union all
    select 'check_if_return_false_if_table_structure_is_not_equals.' test_case
        ,iif(
            'false' = @result.value('(/Result/Value)[1]','nvarchar(8)')
        ,'pass','failed') result
    union all 
	select 'check_if_return_the_correct_error_message.' test_case
        ,iif(
            1 = @result.exist('/Result/DetailMessage/PartitionBoundaryComparation/PartitionBoundaryValueListIsNotEqual')
        ,'pass','failed') result
    ;
	if 'false' <> @result.value('(/Result/Value)[1]','nvarchar(8)')
		select @result.query('/Result/DetailMessage')

    rollback
END TRY
BEGIN CATCH
    exec [dbo].[PRINT_ERROR_MSG];
    rollback
END CATCH
GO