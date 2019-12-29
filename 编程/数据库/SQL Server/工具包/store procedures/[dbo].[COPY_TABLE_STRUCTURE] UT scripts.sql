-- 	################################## [TC-CopyTableStructure-CanCopyColumnStoreTable]: Test can clean up target partition ############################
BEGIN TRAN
BEGIN TRY
	--  given
	drop table if exists [dbo].[TC-CopyTableStructure-CanCopyColumnStoreTable-TBL];
	drop table if exists [dbo].[TC-CopyTableStructure-CanCopyColumnStoreTable-TBL1];

	create table [dbo].[TC-CopyTableStructure-CanCopyColumnStoreTable-TBL](
		PARTITION_ID int
		,str_data varchar(32)
	)
	;

	exec [dbo].[CONVERT_TO_PARTITION_TABLE] '[dbo].[TC-CopyTableStructure-CanCopyColumnStoreTable-TBL]';
	insert into [dbo].[TC-CopyTableStructure-CanCopyColumnStoreTable-TBL] values (1,'abc');

	--	when
	exec [dbo].[COPY_TABLE_STRUCTURE]
		'[dbo].[TC-CopyTableStructure-CanCopyColumnStoreTable-TBL]'
		,'[dbo].[TC-CopyTableStructure-CanCopyColumnStoreTable-TBL1]',1
		;

	--  then
	insert into [dbo].[TC-CopyTableStructure-CanCopyColumnStoreTable-TBL1] 
	select * from [dbo].[TC-CopyTableStructure-CanCopyColumnStoreTable-TBL];

	declare @result xml=[dbo].[IS_TABLE_STRUCTURE_EQUALS](
		'[dbo].[TC-CopyTableStructure-CanCopyColumnStoreTable-TBL]'
		,'[dbo].[TC-CopyTableStructure-CanCopyColumnStoreTable-TBL1]'
		,'SKIP_PARTITIONS'
	)
	;
    select 'test_scnario£º' test_case,'CanCopyColumnStoreTable' result
    union all
    select 'CanCopyColumnStoreTable.' test_case, 'pass' result
	union all
	select 
		'TheTableAfterCopyEqualToOriginalTable.' test_case
		, iif(
			'true'=@result.value('(/Result/Value)[1]','nvarchar(8)')
			,'pass','failed'
		) result
	;
	if 'true' <> @result.value('(/Result/Value)[1]','nvarchar(8)')
		select @result.query('/Result/DetailMessage')
	rollback
END TRY
BEGIN CATCH
    exec [dbo].[PRINT_ERROR_MSG];
    rollback
END CATCH
go

-- 	################################## [TC-CopyTableStructure-CanCopyTableWithIndex]: Test can clean up target partition ############################
BEGIN TRAN
BEGIN TRY
	--  given
	drop table if exists [dbo].[TC-CopyTableStructure-CanCopyTableWithIndex-TBL];
	drop table if exists [dbo].[TC-CopyTableStructure-CanCopyTableWithIndex-TBL1];

	create table [dbo].[TC-CopyTableStructure-CanCopyTableWithIndex-TBL](
		PARTITION_ID int
		,str_data varchar(32)
		,idx_field int 
		,idx_field_2 varchar(32)
	)
	;
	create unique nonclustered index idx_1 on [dbo].[TC-CopyTableStructure-CanCopyTableWithIndex-TBL](idx_field desc,idx_field_2);

	--	when
	exec [dbo].[COPY_TABLE_STRUCTURE]
		'[dbo].[TC-CopyTableStructure-CanCopyTableWithIndex-TBL]'
		,'[dbo].[TC-CopyTableStructure-CanCopyTableWithIndex-TBL1]',1
		;

	--  then
	declare @result xml=[dbo].[IS_TABLE_STRUCTURE_EQUALS](
		'[dbo].[TC-CopyTableStructure-CanCopyTableWithIndex-TBL]'
		,'[dbo].[TC-CopyTableStructure-CanCopyTableWithIndex-TBL1]'
		,'SKIP_PARTITIONS'
	)
	;
    select 'test_scnario£º' test_case,'CanCopyTableWithIndex' result
    union all
    select 'CanCopyTableWithIndex.' test_case, 'pass' result
	union all
	select 
		'TheTableAfterCopyEqualToOriginalTable.' test_case
		, iif(
			'true'=@result.value('(/Result/Value)[1]','nvarchar(8)')
			,'pass','failed'
		) result
	;
	if 'true' <> @result.value('(/Result/Value)[1]','nvarchar(8)')
		select @result.query('/Result/DetailMessage')
	rollback
END TRY
BEGIN CATCH
    exec [dbo].[PRINT_ERROR_MSG];
    rollback
END CATCH
go


-- 	################################## [TC-CopyTableStructure-CanCopyWideTable]: Test can clean up target partition ############################
BEGIN TRAN
BEGIN TRY
	--  given
	drop table if exists [dbo].[TC-CopyTableStructure-CanCopyWideTable-TBL];
	drop table if exists [dbo].[TC-CopyTableStructure-CanCopyWideTable-TBL1];

	create table [dbo].[TC-CopyTableStructure-CanCopyWideTable-TBL](
		[PARTITION_ID] [int] NULL,
		[COUNTRY_CD] [varchar](2) NULL,
		[CYCLE_MONTH] [varchar](6) NULL,
		[RESULT_FILE_LOCATION] [varchar](255) NULL,
		[RESULT_FILE_NAME] [varchar](255) NULL,
		[SP_CD] [varchar](10) NULL,
		[MODEL_POINT] [varchar](10) NULL,
		[ANNUAL_PREM_TOTAL] [decimal](28, 6) NULL,
		[BASIC_RIDER_CD] [varchar](1) NULL,
		[CLAIM_INCURRED_DT] [date] NULL,
		[CURRENCY_CD] [varchar](3) NULL,
		[FUT_PREM_DEP] [decimal](28, 6) NULL,
		[GAAP_CDAC_IF_1_1] [decimal](28, 6) NULL,
		[GAAP_FY_DUE_COMM_IF] [decimal](28, 6) NULL,
		[GAAP_FY_DUE_PREM_IF] [decimal](28, 6) NULL,
		[GAAP_LIAB_IF] [decimal](28, 6) NULL,
		[GAAP_RY_DUE_COMM_IF] [decimal](28, 6) NULL,
		[GAAP_RY_DUE_PREM_IF] [decimal](28, 6) NULL,
		[I17_BEL_CADA_IF] [decimal](28, 6) NULL,
		[I17_BEL_CADA_IF_M_1] [decimal](28, 6) NULL,
		[I17_BEL_CADA_IF_M_10] [decimal](28, 6) NULL,
		[I17_BEL_CADA_IF_M_11] [decimal](28, 6) NULL,
		[I17_BEL_CADA_IF_M_12] [decimal](28, 6) NULL,
		[I17_BEL_CADA_IF_M_2] [decimal](28, 6) NULL,
		[I17_BEL_CADA_IF_M_3] [decimal](28, 6) NULL,
		[I17_BEL_CADA_IF_M_4] [decimal](28, 6) NULL,
		[I17_BEL_CADA_IF_M_5] [decimal](28, 6) NULL,
		[I17_BEL_CADA_IF_M_6] [decimal](28, 6) NULL,
		[I17_BEL_CADA_IF_M_7] [decimal](28, 6) NULL,
		[I17_BEL_CADA_IF_M_8] [decimal](28, 6) NULL,
		[I17_BEL_CADA_IF_M_9] [decimal](28, 6) NULL,
		[I17_BEL_CADA_LKIN_IF] [decimal](28, 6) NULL,
		[I17_BEL_CADA_LKIN_IF_M_1] [decimal](28, 6) NULL,
		[I17_BEL_CADA_LKIN_IF_M_10] [decimal](28, 6) NULL,
		[I17_BEL_CADA_LKIN_IF_M_11] [decimal](28, 6) NULL,
		[I17_BEL_CADA_LKIN_IF_M_12] [decimal](28, 6) NULL,
		[I17_BEL_CADA_LKIN_IF_M_2] [decimal](28, 6) NULL,
		[I17_BEL_CADA_LKIN_IF_M_3] [decimal](28, 6) NULL,
		[I17_BEL_CADA_LKIN_IF_M_4] [decimal](28, 6) NULL,
		[I17_BEL_CADA_LKIN_IF_M_5] [decimal](28, 6) NULL,
		[I17_BEL_CADA_LKIN_IF_M_6] [decimal](28, 6) NULL,
		[I17_BEL_CADA_LKIN_IF_M_7] [decimal](28, 6) NULL,
		[I17_BEL_CADA_LKIN_IF_M_8] [decimal](28, 6) NULL,
		[I17_BEL_CADA_LKIN_IF_M_9] [decimal](28, 6) NULL,
		[I17_BEL_IF] [decimal](28, 6) NULL,
		[I17_BEL_IF_M_1] [decimal](28, 6) NULL,
		[I17_BEL_IF_M_10] [decimal](28, 6) NULL,
		[I17_BEL_IF_M_11] [decimal](28, 6) NULL,
		[I17_BEL_IF_M_12] [decimal](28, 6) NULL,
		[I17_BEL_IF_M_2] [decimal](28, 6) NULL,
		[I17_BEL_IF_M_3] [decimal](28, 6) NULL,
		[I17_BEL_IF_M_4] [decimal](28, 6) NULL,
		[I17_BEL_IF_M_5] [decimal](28, 6) NULL,
		[I17_BEL_IF_M_6] [decimal](28, 6) NULL,
		[I17_BEL_IF_M_7] [decimal](28, 6) NULL,
		[I17_BEL_IF_M_8] [decimal](28, 6) NULL,
		[I17_BEL_IF_M_9] [decimal](28, 6) NULL,
		[I17_BEL_LKIN_IF] [decimal](28, 6) NULL,
		[I17_BEL_LKIN_IF_M_1] [decimal](28, 6) NULL,
		[I17_BEL_LKIN_IF_M_10] [decimal](28, 6) NULL,
		[I17_BEL_LKIN_IF_M_11] [decimal](28, 6) NULL,
		[I17_BEL_LKIN_IF_M_12] [decimal](28, 6) NULL,
		[I17_BEL_LKIN_IF_M_2] [decimal](28, 6) NULL,
		[I17_BEL_LKIN_IF_M_3] [decimal](28, 6) NULL,
		[I17_BEL_LKIN_IF_M_4] [decimal](28, 6) NULL,
		[I17_BEL_LKIN_IF_M_5] [decimal](28, 6) NULL,
		[I17_BEL_LKIN_IF_M_6] [decimal](28, 6) NULL,
		[I17_BEL_LKIN_IF_M_7] [decimal](28, 6) NULL,
		[I17_BEL_LKIN_IF_M_8] [decimal](28, 6) NULL,
		[I17_BEL_LKIN_IF_M_9] [decimal](28, 6) NULL,
		[I17_BEL_POL_LOAN_IF] [decimal](28, 6) NULL,
		[I17_BEL_POL_LOAN_IF_M_1] [decimal](28, 6) NULL,
		[I17_BEL_POL_LOAN_IF_M_10] [decimal](28, 6) NULL,
		[I17_BEL_POL_LOAN_IF_M_11] [decimal](28, 6) NULL,
		[I17_BEL_POL_LOAN_IF_M_12] [decimal](28, 6) NULL,
		[I17_BEL_POL_LOAN_IF_M_2] [decimal](28, 6) NULL,
		[I17_BEL_POL_LOAN_IF_M_3] [decimal](28, 6) NULL,
		[I17_BEL_POL_LOAN_IF_M_4] [decimal](28, 6) NULL,
		[I17_BEL_POL_LOAN_IF_M_5] [decimal](28, 6) NULL,
		[I17_BEL_POL_LOAN_IF_M_6] [decimal](28, 6) NULL,
		[I17_BEL_POL_LOAN_IF_M_7] [decimal](28, 6) NULL,
		[I17_BEL_POL_LOAN_IF_M_8] [decimal](28, 6) NULL,
		[I17_BEL_POL_LOAN_IF_M_9] [decimal](28, 6) NULL,
		[I17_BEL_POL_LOAN_LKIN_IF] [decimal](28, 6) NULL,
		[I17_BEL_POL_LOAN_LKIN_IF_M_1] [decimal](28, 6) NULL,
		[I17_BEL_POL_LOAN_LKIN_IF_M_10] [decimal](28, 6) NULL,
		[I17_BEL_POL_LOAN_LKIN_IF_M_11] [decimal](28, 6) NULL,
		[I17_BEL_POL_LOAN_LKIN_IF_M_12] [decimal](28, 6) NULL,
		[I17_BEL_POL_LOAN_LKIN_IF_M_2] [decimal](28, 6) NULL,
		[I17_BEL_POL_LOAN_LKIN_IF_M_3] [decimal](28, 6) NULL,
		[I17_BEL_POL_LOAN_LKIN_IF_M_4] [decimal](28, 6) NULL,
		[I17_BEL_POL_LOAN_LKIN_IF_M_5] [decimal](28, 6) NULL,
		[I17_BEL_POL_LOAN_LKIN_IF_M_6] [decimal](28, 6) NULL,
		[I17_BEL_POL_LOAN_LKIN_IF_M_7] [decimal](28, 6) NULL,
		[I17_BEL_POL_LOAN_LKIN_IF_M_8] [decimal](28, 6) NULL,
		[I17_BEL_POL_LOAN_LKIN_IF_M_9] [decimal](28, 6) NULL,
		[I17_CB_DT] [date] NULL,
		[I17_COHORT] [varchar](6) NULL,
		[I17_COV_UNITS_IF] [decimal](28, 6) NULL,
		[I17_COV_UNITS_IF_M_1] [decimal](28, 6) NULL,
		[I17_COV_UNITS_IF_M_10] [decimal](28, 6) NULL,
		[I17_COV_UNITS_IF_M_11] [decimal](28, 6) NULL,
		[I17_COV_UNITS_IF_M_12] [decimal](28, 6) NULL,
		[I17_COV_UNITS_IF_M_2] [decimal](28, 6) NULL,
		[I17_COV_UNITS_IF_M_3] [decimal](28, 6) NULL,
		[I17_COV_UNITS_IF_M_4] [decimal](28, 6) NULL,
		[I17_COV_UNITS_IF_M_5] [decimal](28, 6) NULL,
		[I17_COV_UNITS_IF_M_6] [decimal](28, 6) NULL,
		[I17_COV_UNITS_IF_M_7] [decimal](28, 6) NULL,
		[I17_COV_UNITS_IF_M_8] [decimal](28, 6) NULL,
		[I17_COV_UNITS_IF_M_9] [decimal](28, 6) NULL,
		[I17_EXP_ACQ_PREM_M_1] [decimal](28, 6) NULL,
		[I17_EXP_ACQ_PREM_M_10] [decimal](28, 6) NULL,
		[I17_EXP_ACQ_PREM_M_11] [decimal](28, 6) NULL,
		[I17_EXP_ACQ_PREM_M_12] [decimal](28, 6) NULL,
		[I17_EXP_ACQ_PREM_M_2] [decimal](28, 6) NULL,
		[I17_EXP_ACQ_PREM_M_3] [decimal](28, 6) NULL,
		[I17_EXP_ACQ_PREM_M_4] [decimal](28, 6) NULL,
		[I17_EXP_ACQ_PREM_M_5] [decimal](28, 6) NULL,
		[I17_EXP_ACQ_PREM_M_6] [decimal](28, 6) NULL,
		[I17_EXP_ACQ_PREM_M_7] [decimal](28, 6) NULL,
		[I17_EXP_ACQ_PREM_M_8] [decimal](28, 6) NULL,
		[I17_EXP_ACQ_PREM_M_9] [decimal](28, 6) NULL,
		[I17_EXP_INTERCOM_NONPREM_M_1] [decimal](28, 6) NULL,
		[I17_EXP_INTERCOM_NONPREM_M_10] [decimal](28, 6) NULL,
		[I17_EXP_INTERCOM_NONPREM_M_11] [decimal](28, 6) NULL,
		[I17_EXP_INTERCOM_NONPREM_M_12] [decimal](28, 6) NULL,
		[I17_EXP_INTERCOM_NONPREM_M_2] [decimal](28, 6) NULL,
		[I17_EXP_INTERCOM_NONPREM_M_3] [decimal](28, 6) NULL,
		[I17_EXP_INTERCOM_NONPREM_M_4] [decimal](28, 6) NULL,
		[I17_EXP_INTERCOM_NONPREM_M_5] [decimal](28, 6) NULL,
		[I17_EXP_INTERCOM_NONPREM_M_6] [decimal](28, 6) NULL,
		[I17_EXP_INTERCOM_NONPREM_M_7] [decimal](28, 6) NULL,
		[I17_EXP_INTERCOM_NONPREM_M_8] [decimal](28, 6) NULL,
		[I17_EXP_INTERCOM_NONPREM_M_9] [decimal](28, 6) NULL,
		[I17_EXP_INV_NONPREM_M_1] [decimal](28, 6) NULL,
		[I17_EXP_INV_NONPREM_M_10] [decimal](28, 6) NULL,
		[I17_EXP_INV_NONPREM_M_11] [decimal](28, 6) NULL,
		[I17_EXP_INV_NONPREM_M_12] [decimal](28, 6) NULL,
		[I17_EXP_INV_NONPREM_M_2] [decimal](28, 6) NULL,
		[I17_EXP_INV_NONPREM_M_3] [decimal](28, 6) NULL,
		[I17_EXP_INV_NONPREM_M_4] [decimal](28, 6) NULL,
		[I17_EXP_INV_NONPREM_M_5] [decimal](28, 6) NULL,
		[I17_EXP_INV_NONPREM_M_6] [decimal](28, 6) NULL,
		[I17_EXP_INV_NONPREM_M_7] [decimal](28, 6) NULL,
		[I17_EXP_INV_NONPREM_M_8] [decimal](28, 6) NULL,
		[I17_EXP_INV_NONPREM_M_9] [decimal](28, 6) NULL,
		[I17_EXP_MAINT_NONPREM_M_1] [decimal](28, 6) NULL,
		[I17_EXP_MAINT_NONPREM_M_10] [decimal](28, 6) NULL,
		[I17_EXP_MAINT_NONPREM_M_11] [decimal](28, 6) NULL,
		[I17_EXP_MAINT_NONPREM_M_12] [decimal](28, 6) NULL,
		[I17_EXP_MAINT_NONPREM_M_2] [decimal](28, 6) NULL,
		[I17_EXP_MAINT_NONPREM_M_3] [decimal](28, 6) NULL,
		[I17_EXP_MAINT_NONPREM_M_4] [decimal](28, 6) NULL,
		[I17_EXP_MAINT_NONPREM_M_5] [decimal](28, 6) NULL,
		[I17_EXP_MAINT_NONPREM_M_6] [decimal](28, 6) NULL,
		[I17_EXP_MAINT_NONPREM_M_7] [decimal](28, 6) NULL,
		[I17_EXP_MAINT_NONPREM_M_8] [decimal](28, 6) NULL,
		[I17_EXP_MAINT_NONPREM_M_9] [decimal](28, 6) NULL,
		[I17_EXP_MAINT_PREM_M_1] [decimal](28, 6) NULL,
		[I17_EXP_MAINT_PREM_M_10] [decimal](28, 6) NULL,
		[I17_EXP_MAINT_PREM_M_11] [decimal](28, 6) NULL,
		[I17_EXP_MAINT_PREM_M_12] [decimal](28, 6) NULL,
		[I17_EXP_MAINT_PREM_M_2] [decimal](28, 6) NULL,
		[I17_EXP_MAINT_PREM_M_3] [decimal](28, 6) NULL,
		[I17_EXP_MAINT_PREM_M_4] [decimal](28, 6) NULL,
		[I17_EXP_MAINT_PREM_M_5] [decimal](28, 6) NULL,
		[I17_EXP_MAINT_PREM_M_6] [decimal](28, 6) NULL,
		[I17_EXP_MAINT_PREM_M_7] [decimal](28, 6) NULL,
		[I17_EXP_MAINT_PREM_M_8] [decimal](28, 6) NULL,
		[I17_EXP_MAINT_PREM_M_9] [decimal](28, 6) NULL,
		[I17_FY_DUE_COMM_IF] [decimal](28, 6) NULL,
		[I17_FY_DUE_PREM_IF] [decimal](28, 6) NULL,
		[I17_FY_PRE_COMM_IF] [decimal](28, 6) NULL,
		[I17_FY_PRE_PREM_IF] [decimal](28, 6) NULL,
		[I17_I9_MM] [varchar](4) NULL,
		[I17_INIT_COMM_M_1] [decimal](28, 6) NULL,
		[I17_INIT_COMM_M_10] [decimal](28, 6) NULL,
		[I17_INIT_COMM_M_11] [decimal](28, 6) NULL,
		[I17_INIT_COMM_M_12] [decimal](28, 6) NULL,
		[I17_INIT_COMM_M_2] [decimal](28, 6) NULL,
		[I17_INIT_COMM_M_3] [decimal](28, 6) NULL,
		[I17_INIT_COMM_M_4] [decimal](28, 6) NULL,
		[I17_INIT_COMM_M_5] [decimal](28, 6) NULL,
		[I17_INIT_COMM_M_6] [decimal](28, 6) NULL,
		[I17_INIT_COMM_M_7] [decimal](28, 6) NULL,
		[I17_INIT_COMM_M_8] [decimal](28, 6) NULL,
		[I17_INIT_COMM_M_9] [decimal](28, 6) NULL,
		[I17_INS_COMPONENT_NONUI_M_1] [decimal](28, 6) NULL,
		[I17_INS_COMPONENT_NONUI_M_10] [decimal](28, 6) NULL,
		[I17_INS_COMPONENT_NONUI_M_11] [decimal](28, 6) NULL,
		[I17_INS_COMPONENT_NONUI_M_12] [decimal](28, 6) NULL,
		[I17_INS_COMPONENT_NONUI_M_2] [decimal](28, 6) NULL,
		[I17_INS_COMPONENT_NONUI_M_3] [decimal](28, 6) NULL,
		[I17_INS_COMPONENT_NONUI_M_4] [decimal](28, 6) NULL,
		[I17_INS_COMPONENT_NONUI_M_5] [decimal](28, 6) NULL,
		[I17_INS_COMPONENT_NONUI_M_6] [decimal](28, 6) NULL,
		[I17_INS_COMPONENT_NONUI_M_7] [decimal](28, 6) NULL,
		[I17_INS_COMPONENT_NONUI_M_8] [decimal](28, 6) NULL,
		[I17_INS_COMPONENT_NONUI_M_9] [decimal](28, 6) NULL,
		[I17_INS_COMPONENT_UI_M_1] [decimal](28, 6) NULL,
		[I17_INS_COMPONENT_UI_M_10] [decimal](28, 6) NULL,
		[I17_INS_COMPONENT_UI_M_11] [decimal](28, 6) NULL,
		[I17_INS_COMPONENT_UI_M_12] [decimal](28, 6) NULL,
		[I17_INS_COMPONENT_UI_M_2] [decimal](28, 6) NULL,
		[I17_INS_COMPONENT_UI_M_3] [decimal](28, 6) NULL,
		[I17_INS_COMPONENT_UI_M_4] [decimal](28, 6) NULL,
		[I17_INS_COMPONENT_UI_M_5] [decimal](28, 6) NULL,
		[I17_INS_COMPONENT_UI_M_6] [decimal](28, 6) NULL,
		[I17_INS_COMPONENT_UI_M_7] [decimal](28, 6) NULL,
		[I17_INS_COMPONENT_UI_M_8] [decimal](28, 6) NULL,
		[I17_INS_COMPONENT_UI_M_9] [decimal](28, 6) NULL,
		[I17_INV_COMPONENT] [decimal](28, 6) NULL,
		[I17_INV_COMPONENT_M_1] [decimal](28, 6) NULL,
		[I17_INV_COMPONENT_M_10] [decimal](28, 6) NULL,
		[I17_INV_COMPONENT_M_11] [decimal](28, 6) NULL,
		[I17_INV_COMPONENT_M_12] [decimal](28, 6) NULL,
		[I17_INV_COMPONENT_M_2] [decimal](28, 6) NULL,
		[I17_INV_COMPONENT_M_3] [decimal](28, 6) NULL,
		[I17_INV_COMPONENT_M_4] [decimal](28, 6) NULL,
		[I17_INV_COMPONENT_M_5] [decimal](28, 6) NULL,
		[I17_INV_COMPONENT_M_6] [decimal](28, 6) NULL,
		[I17_INV_COMPONENT_M_7] [decimal](28, 6) NULL,
		[I17_INV_COMPONENT_M_8] [decimal](28, 6) NULL,
		[I17_INV_COMPONENT_M_9] [decimal](28, 6) NULL,
		[I17_INV_COMPONENT_NONUI_M_1] [decimal](28, 6) NULL,
		[I17_INV_COMPONENT_NONUI_M_10] [decimal](28, 6) NULL,
		[I17_INV_COMPONENT_NONUI_M_11] [decimal](28, 6) NULL,
		[I17_INV_COMPONENT_NONUI_M_12] [decimal](28, 6) NULL,
		[I17_INV_COMPONENT_NONUI_M_2] [decimal](28, 6) NULL,
		[I17_INV_COMPONENT_NONUI_M_3] [decimal](28, 6) NULL,
		[I17_INV_COMPONENT_NONUI_M_4] [decimal](28, 6) NULL,
		[I17_INV_COMPONENT_NONUI_M_5] [decimal](28, 6) NULL,
		[I17_INV_COMPONENT_NONUI_M_6] [decimal](28, 6) NULL,
		[I17_INV_COMPONENT_NONUI_M_7] [decimal](28, 6) NULL,
		[I17_INV_COMPONENT_NONUI_M_8] [decimal](28, 6) NULL,
		[I17_INV_COMPONENT_NONUI_M_9] [decimal](28, 6) NULL,
		[I17_INV_COMPONENT_UI_M_1] [decimal](28, 6) NULL,
		[I17_INV_COMPONENT_UI_M_10] [decimal](28, 6) NULL,
		[I17_INV_COMPONENT_UI_M_11] [decimal](28, 6) NULL,
		[I17_INV_COMPONENT_UI_M_12] [decimal](28, 6) NULL,
		[I17_INV_COMPONENT_UI_M_2] [decimal](28, 6) NULL,
		[I17_INV_COMPONENT_UI_M_3] [decimal](28, 6) NULL,
		[I17_INV_COMPONENT_UI_M_4] [decimal](28, 6) NULL,
		[I17_INV_COMPONENT_UI_M_5] [decimal](28, 6) NULL,
		[I17_INV_COMPONENT_UI_M_6] [decimal](28, 6) NULL,
		[I17_INV_COMPONENT_UI_M_7] [decimal](28, 6) NULL,
		[I17_INV_COMPONENT_UI_M_8] [decimal](28, 6) NULL,
		[I17_INV_COMPONENT_UI_M_9] [decimal](28, 6) NULL,
		[I17_INV_TAX_NONPREM_M_1] [decimal](28, 6) NULL,
		[I17_INV_TAX_NONPREM_M_10] [decimal](28, 6) NULL,
		[I17_INV_TAX_NONPREM_M_11] [decimal](28, 6) NULL,
		[I17_INV_TAX_NONPREM_M_12] [decimal](28, 6) NULL,
		[I17_INV_TAX_NONPREM_M_2] [decimal](28, 6) NULL,
		[I17_INV_TAX_NONPREM_M_3] [decimal](28, 6) NULL,
		[I17_INV_TAX_NONPREM_M_4] [decimal](28, 6) NULL,
		[I17_INV_TAX_NONPREM_M_5] [decimal](28, 6) NULL,
		[I17_INV_TAX_NONPREM_M_6] [decimal](28, 6) NULL,
		[I17_INV_TAX_NONPREM_M_7] [decimal](28, 6) NULL,
		[I17_INV_TAX_NONPREM_M_8] [decimal](28, 6) NULL,
		[I17_INV_TAX_NONPREM_M_9] [decimal](28, 6) NULL,
		[I17_LIC_FUT_CF_IF] [decimal](28, 6) NULL,
		[I17_LIC_FUT_CF_IF_M_1] [decimal](28, 6) NULL,
		[I17_LIC_FUT_CF_IF_M_10] [decimal](28, 6) NULL,
		[I17_LIC_FUT_CF_IF_M_11] [decimal](28, 6) NULL,
		[I17_LIC_FUT_CF_IF_M_12] [decimal](28, 6) NULL,
		[I17_LIC_FUT_CF_IF_M_2] [decimal](28, 6) NULL,
		[I17_LIC_FUT_CF_IF_M_3] [decimal](28, 6) NULL,
		[I17_LIC_FUT_CF_IF_M_4] [decimal](28, 6) NULL,
		[I17_LIC_FUT_CF_IF_M_5] [decimal](28, 6) NULL,
		[I17_LIC_FUT_CF_IF_M_6] [decimal](28, 6) NULL,
		[I17_LIC_FUT_CF_IF_M_7] [decimal](28, 6) NULL,
		[I17_LIC_FUT_CF_IF_M_8] [decimal](28, 6) NULL,
		[I17_LIC_FUT_CF_IF_M_9] [decimal](28, 6) NULL,
		[I17_LIC_PV_CF_IF] [decimal](28, 6) NULL,
		[I17_LIQ_DIS_0_1] [decimal](28, 6) NULL,
		[I17_LIQ_DIS_10_PLUS] [decimal](28, 6) NULL,
		[I17_LIQ_DIS_1_5] [decimal](28, 6) NULL,
		[I17_LIQ_DIS_5_10] [decimal](28, 6) NULL,
		[I17_MUTULIZATION_CD] [varchar](10) NULL,
		[I17_MUTULIZATION_CD_PARENT] [varchar](10) NULL,
		[I17_NCF_M_1] [decimal](28, 6) NULL,
		[I17_NCF_M_10] [decimal](28, 6) NULL,
		[I17_NCF_M_11] [decimal](28, 6) NULL,
		[I17_NCF_M_12] [decimal](28, 6) NULL,
		[I17_NCF_M_2] [decimal](28, 6) NULL,
		[I17_NCF_M_3] [decimal](28, 6) NULL,
		[I17_NCF_M_4] [decimal](28, 6) NULL,
		[I17_NCF_M_5] [decimal](28, 6) NULL,
		[I17_NCF_M_6] [decimal](28, 6) NULL,
		[I17_NCF_M_7] [decimal](28, 6) NULL,
		[I17_NCF_M_8] [decimal](28, 6) NULL,
		[I17_NCF_M_9] [decimal](28, 6) NULL,
		[I17_PLAN_CD] [varchar](20) NULL,
		[I17_PORTFOLIO] [varchar](30) NULL,
		[I17_PREM_INC_M_1] [decimal](28, 6) NULL,
		[I17_PREM_INC_M_10] [decimal](28, 6) NULL,
		[I17_PREM_INC_M_11] [decimal](28, 6) NULL,
		[I17_PREM_INC_M_12] [decimal](28, 6) NULL,
		[I17_PREM_INC_M_2] [decimal](28, 6) NULL,
		[I17_PREM_INC_M_3] [decimal](28, 6) NULL,
		[I17_PREM_INC_M_4] [decimal](28, 6) NULL,
		[I17_PREM_INC_M_5] [decimal](28, 6) NULL,
		[I17_PREM_INC_M_6] [decimal](28, 6) NULL,
		[I17_PREM_INC_M_7] [decimal](28, 6) NULL,
		[I17_PREM_INC_M_8] [decimal](28, 6) NULL,
		[I17_PREM_INC_M_9] [decimal](28, 6) NULL,
		[I17_PROFITABILITY] [varchar](30) NULL,
		[I17_PV_CADA_INFLOW_CURR] [decimal](28, 6) NULL,
		[I17_PV_CADA_OUTGO_CURR] [decimal](28, 6) NULL,
		[I17_PV_CADA_OUTGO_CURR_M_1] [decimal](28, 6) NULL,
		[I17_PV_CADA_OUTGO_CURR_M_10] [decimal](28, 6) NULL,
		[I17_PV_CADA_OUTGO_CURR_M_11] [decimal](28, 6) NULL,
		[I17_PV_CADA_OUTGO_CURR_M_12] [decimal](28, 6) NULL,
		[I17_PV_CADA_OUTGO_CURR_M_2] [decimal](28, 6) NULL,
		[I17_PV_CADA_OUTGO_CURR_M_3] [decimal](28, 6) NULL,
		[I17_PV_CADA_OUTGO_CURR_M_4] [decimal](28, 6) NULL,
		[I17_PV_CADA_OUTGO_CURR_M_5] [decimal](28, 6) NULL,
		[I17_PV_CADA_OUTGO_CURR_M_6] [decimal](28, 6) NULL,
		[I17_PV_CADA_OUTGO_CURR_M_7] [decimal](28, 6) NULL,
		[I17_PV_CADA_OUTGO_CURR_M_8] [decimal](28, 6) NULL,
		[I17_PV_CADA_OUTGO_CURR_M_9] [decimal](28, 6) NULL,
		[I17_PV_CADA_OUTGO_LKIN] [decimal](28, 6) NULL,
		[I17_PV_CADA_OUTGO_LKIN_M_1] [decimal](28, 6) NULL,
		[I17_PV_CADA_OUTGO_LKIN_M_10] [decimal](28, 6) NULL,
		[I17_PV_CADA_OUTGO_LKIN_M_11] [decimal](28, 6) NULL,
		[I17_PV_CADA_OUTGO_LKIN_M_12] [decimal](28, 6) NULL,
		[I17_PV_CADA_OUTGO_LKIN_M_2] [decimal](28, 6) NULL,
		[I17_PV_CADA_OUTGO_LKIN_M_3] [decimal](28, 6) NULL,
		[I17_PV_CADA_OUTGO_LKIN_M_4] [decimal](28, 6) NULL,
		[I17_PV_CADA_OUTGO_LKIN_M_5] [decimal](28, 6) NULL,
		[I17_PV_CADA_OUTGO_LKIN_M_6] [decimal](28, 6) NULL,
		[I17_PV_CADA_OUTGO_LKIN_M_7] [decimal](28, 6) NULL,
		[I17_PV_CADA_OUTGO_LKIN_M_8] [decimal](28, 6) NULL,
		[I17_PV_CADA_OUTGO_LKIN_M_9] [decimal](28, 6) NULL,
		[I17_PV_COV_UNITS] [decimal](28, 6) NULL,
		[I17_PV_INS_CLAIM_CURR] [decimal](28, 6) NULL,
		[I17_PV_INV_CLAIM_CURR] [decimal](28, 6) NULL,
		[I17_PV_OVERLAY_ADJ_CURR] [decimal](28, 6) NULL,
		[I17_PV_PREM_INC_CURR] [decimal](28, 6) NULL,
		[I17_PV_TOT_ACQ_CURR] [decimal](28, 6) NULL,
		[I17_PV_TOT_EXP_ATTRI_EXCL_ACQ_CURR] [decimal](28, 6) NULL,
		[I17_PV_TOT_INFLOW_CURR] [decimal](28, 6) NULL,
		[I17_PV_TOT_OUTGO_CURR] [decimal](28, 6) NULL,
		[I17_PV_TOT_OUTGO_CURR_M_1] [decimal](28, 6) NULL,
		[I17_PV_TOT_OUTGO_CURR_M_10] [decimal](28, 6) NULL,
		[I17_PV_TOT_OUTGO_CURR_M_11] [decimal](28, 6) NULL,
		[I17_PV_TOT_OUTGO_CURR_M_12] [decimal](28, 6) NULL,
		[I17_PV_TOT_OUTGO_CURR_M_2] [decimal](28, 6) NULL,
		[I17_PV_TOT_OUTGO_CURR_M_3] [decimal](28, 6) NULL,
		[I17_PV_TOT_OUTGO_CURR_M_4] [decimal](28, 6) NULL,
		[I17_PV_TOT_OUTGO_CURR_M_5] [decimal](28, 6) NULL,
		[I17_PV_TOT_OUTGO_CURR_M_6] [decimal](28, 6) NULL,
		[I17_PV_TOT_OUTGO_CURR_M_7] [decimal](28, 6) NULL,
		[I17_PV_TOT_OUTGO_CURR_M_8] [decimal](28, 6) NULL,
		[I17_PV_TOT_OUTGO_CURR_M_9] [decimal](28, 6) NULL,
		[I17_PV_TOT_OUTGO_LKIN] [decimal](28, 6) NULL,
		[I17_PV_TOT_OUTGO_LKIN_M_1] [decimal](28, 6) NULL,
		[I17_PV_TOT_OUTGO_LKIN_M_10] [decimal](28, 6) NULL,
		[I17_PV_TOT_OUTGO_LKIN_M_11] [decimal](28, 6) NULL,
		[I17_PV_TOT_OUTGO_LKIN_M_12] [decimal](28, 6) NULL,
		[I17_PV_TOT_OUTGO_LKIN_M_2] [decimal](28, 6) NULL,
		[I17_PV_TOT_OUTGO_LKIN_M_3] [decimal](28, 6) NULL,
		[I17_PV_TOT_OUTGO_LKIN_M_4] [decimal](28, 6) NULL,
		[I17_PV_TOT_OUTGO_LKIN_M_5] [decimal](28, 6) NULL,
		[I17_PV_TOT_OUTGO_LKIN_M_6] [decimal](28, 6) NULL,
		[I17_PV_TOT_OUTGO_LKIN_M_7] [decimal](28, 6) NULL,
		[I17_PV_TOT_OUTGO_LKIN_M_8] [decimal](28, 6) NULL,
		[I17_PV_TOT_OUTGO_LKIN_M_9] [decimal](28, 6) NULL,
		[I17_RA_CADA_CURR_IF] [decimal](28, 6) NULL,
		[I17_RA_CADA_CURR_IF_M_1] [decimal](28, 6) NULL,
		[I17_RA_CADA_CURR_IF_M_10] [decimal](28, 6) NULL,
		[I17_RA_CADA_CURR_IF_M_11] [decimal](28, 6) NULL,
		[I17_RA_CADA_CURR_IF_M_12] [decimal](28, 6) NULL,
		[I17_RA_CADA_CURR_IF_M_2] [decimal](28, 6) NULL,
		[I17_RA_CADA_CURR_IF_M_3] [decimal](28, 6) NULL,
		[I17_RA_CADA_CURR_IF_M_4] [decimal](28, 6) NULL,
		[I17_RA_CADA_CURR_IF_M_5] [decimal](28, 6) NULL,
		[I17_RA_CADA_CURR_IF_M_6] [decimal](28, 6) NULL,
		[I17_RA_CADA_CURR_IF_M_7] [decimal](28, 6) NULL,
		[I17_RA_CADA_CURR_IF_M_8] [decimal](28, 6) NULL,
		[I17_RA_CADA_CURR_IF_M_9] [decimal](28, 6) NULL,
		[I17_RA_CURR_IF] [decimal](28, 6) NULL,
		[I17_RA_CURR_IF_M_1] [decimal](28, 6) NULL,
		[I17_RA_CURR_IF_M_10] [decimal](28, 6) NULL,
		[I17_RA_CURR_IF_M_11] [decimal](28, 6) NULL,
		[I17_RA_CURR_IF_M_12] [decimal](28, 6) NULL,
		[I17_RA_CURR_IF_M_2] [decimal](28, 6) NULL,
		[I17_RA_CURR_IF_M_3] [decimal](28, 6) NULL,
		[I17_RA_CURR_IF_M_4] [decimal](28, 6) NULL,
		[I17_RA_CURR_IF_M_5] [decimal](28, 6) NULL,
		[I17_RA_CURR_IF_M_6] [decimal](28, 6) NULL,
		[I17_RA_CURR_IF_M_7] [decimal](28, 6) NULL,
		[I17_RA_CURR_IF_M_8] [decimal](28, 6) NULL,
		[I17_RA_CURR_IF_M_9] [decimal](28, 6) NULL,
		[I17_RA_POL_LOAN_CURR_IF] [decimal](28, 6) NULL,
		[I17_RA_POL_LOAN_CURR_IF_M_1] [decimal](28, 6) NULL,
		[I17_RA_POL_LOAN_CURR_IF_M_10] [decimal](28, 6) NULL,
		[I17_RA_POL_LOAN_CURR_IF_M_11] [decimal](28, 6) NULL,
		[I17_RA_POL_LOAN_CURR_IF_M_12] [decimal](28, 6) NULL,
		[I17_RA_POL_LOAN_CURR_IF_M_2] [decimal](28, 6) NULL,
		[I17_RA_POL_LOAN_CURR_IF_M_3] [decimal](28, 6) NULL,
		[I17_RA_POL_LOAN_CURR_IF_M_4] [decimal](28, 6) NULL,
		[I17_RA_POL_LOAN_CURR_IF_M_5] [decimal](28, 6) NULL,
		[I17_RA_POL_LOAN_CURR_IF_M_6] [decimal](28, 6) NULL,
		[I17_RA_POL_LOAN_CURR_IF_M_7] [decimal](28, 6) NULL,
		[I17_RA_POL_LOAN_CURR_IF_M_8] [decimal](28, 6) NULL,
		[I17_RA_POL_LOAN_CURR_IF_M_9] [decimal](28, 6) NULL,
		[I17_RA_WOP_CURR_IF] [decimal](28, 6) NULL,
		[I17_REN_COMM_M_1] [decimal](28, 6) NULL,
		[I17_REN_COMM_M_10] [decimal](28, 6) NULL,
		[I17_REN_COMM_M_11] [decimal](28, 6) NULL,
		[I17_REN_COMM_M_12] [decimal](28, 6) NULL,
		[I17_REN_COMM_M_2] [decimal](28, 6) NULL,
		[I17_REN_COMM_M_3] [decimal](28, 6) NULL,
		[I17_REN_COMM_M_4] [decimal](28, 6) NULL,
		[I17_REN_COMM_M_5] [decimal](28, 6) NULL,
		[I17_REN_COMM_M_6] [decimal](28, 6) NULL,
		[I17_REN_COMM_M_7] [decimal](28, 6) NULL,
		[I17_REN_COMM_M_8] [decimal](28, 6) NULL,
		[I17_REN_COMM_M_9] [decimal](28, 6) NULL,
		[I17_RY_DUE_COMM_IF] [decimal](28, 6) NULL,
		[I17_RY_DUE_PREM_IF] [decimal](28, 6) NULL,
		[I17_RY_PRE_COMM_IF] [decimal](28, 6) NULL,
		[I17_RY_PRE_PREM_IF] [decimal](28, 6) NULL,
		[I17_STP_DUTY_IF_M_1] [decimal](28, 6) NULL,
		[I17_STP_DUTY_IF_M_10] [decimal](28, 6) NULL,
		[I17_STP_DUTY_IF_M_11] [decimal](28, 6) NULL,
		[I17_STP_DUTY_IF_M_12] [decimal](28, 6) NULL,
		[I17_STP_DUTY_IF_M_2] [decimal](28, 6) NULL,
		[I17_STP_DUTY_IF_M_3] [decimal](28, 6) NULL,
		[I17_STP_DUTY_IF_M_4] [decimal](28, 6) NULL,
		[I17_STP_DUTY_IF_M_5] [decimal](28, 6) NULL,
		[I17_STP_DUTY_IF_M_6] [decimal](28, 6) NULL,
		[I17_STP_DUTY_IF_M_7] [decimal](28, 6) NULL,
		[I17_STP_DUTY_IF_M_8] [decimal](28, 6) NULL,
		[I17_STP_DUTY_IF_M_9] [decimal](28, 6) NULL,
		[I17_TOT_EXP_NONPREM_NONUI_M_1] [decimal](28, 6) NULL,
		[I17_TOT_EXP_NONPREM_NONUI_M_10] [decimal](28, 6) NULL,
		[I17_TOT_EXP_NONPREM_NONUI_M_11] [decimal](28, 6) NULL,
		[I17_TOT_EXP_NONPREM_NONUI_M_12] [decimal](28, 6) NULL,
		[I17_TOT_EXP_NONPREM_NONUI_M_2] [decimal](28, 6) NULL,
		[I17_TOT_EXP_NONPREM_NONUI_M_3] [decimal](28, 6) NULL,
		[I17_TOT_EXP_NONPREM_NONUI_M_4] [decimal](28, 6) NULL,
		[I17_TOT_EXP_NONPREM_NONUI_M_5] [decimal](28, 6) NULL,
		[I17_TOT_EXP_NONPREM_NONUI_M_6] [decimal](28, 6) NULL,
		[I17_TOT_EXP_NONPREM_NONUI_M_7] [decimal](28, 6) NULL,
		[I17_TOT_EXP_NONPREM_NONUI_M_8] [decimal](28, 6) NULL,
		[I17_TOT_EXP_NONPREM_NONUI_M_9] [decimal](28, 6) NULL,
		[I17_TOT_EXP_NONPREM_UI_M_1] [decimal](28, 6) NULL,
		[I17_TOT_EXP_NONPREM_UI_M_10] [decimal](28, 6) NULL,
		[I17_TOT_EXP_NONPREM_UI_M_11] [decimal](28, 6) NULL,
		[I17_TOT_EXP_NONPREM_UI_M_12] [decimal](28, 6) NULL,
		[I17_TOT_EXP_NONPREM_UI_M_2] [decimal](28, 6) NULL,
		[I17_TOT_EXP_NONPREM_UI_M_3] [decimal](28, 6) NULL,
		[I17_TOT_EXP_NONPREM_UI_M_4] [decimal](28, 6) NULL,
		[I17_TOT_EXP_NONPREM_UI_M_5] [decimal](28, 6) NULL,
		[I17_TOT_EXP_NONPREM_UI_M_6] [decimal](28, 6) NULL,
		[I17_TOT_EXP_NONPREM_UI_M_7] [decimal](28, 6) NULL,
		[I17_TOT_EXP_NONPREM_UI_M_8] [decimal](28, 6) NULL,
		[I17_TOT_EXP_NONPREM_UI_M_9] [decimal](28, 6) NULL,
		[I17_TOT_FUT_ACQ_EXP] [decimal](28, 6) NULL,
		[I17_TOT_TAX_NONPREM_M_1] [decimal](28, 6) NULL,
		[I17_TOT_TAX_NONPREM_M_10] [decimal](28, 6) NULL,
		[I17_TOT_TAX_NONPREM_M_11] [decimal](28, 6) NULL,
		[I17_TOT_TAX_NONPREM_M_12] [decimal](28, 6) NULL,
		[I17_TOT_TAX_NONPREM_M_2] [decimal](28, 6) NULL,
		[I17_TOT_TAX_NONPREM_M_3] [decimal](28, 6) NULL,
		[I17_TOT_TAX_NONPREM_M_4] [decimal](28, 6) NULL,
		[I17_TOT_TAX_NONPREM_M_5] [decimal](28, 6) NULL,
		[I17_TOT_TAX_NONPREM_M_6] [decimal](28, 6) NULL,
		[I17_TOT_TAX_NONPREM_M_7] [decimal](28, 6) NULL,
		[I17_TOT_TAX_NONPREM_M_8] [decimal](28, 6) NULL,
		[I17_TOT_TAX_NONPREM_M_9] [decimal](28, 6) NULL,
		[I17_TOT_TAX_PREM_M_1] [decimal](28, 6) NULL,
		[I17_TOT_TAX_PREM_M_10] [decimal](28, 6) NULL,
		[I17_TOT_TAX_PREM_M_11] [decimal](28, 6) NULL,
		[I17_TOT_TAX_PREM_M_12] [decimal](28, 6) NULL,
		[I17_TOT_TAX_PREM_M_2] [decimal](28, 6) NULL,
		[I17_TOT_TAX_PREM_M_3] [decimal](28, 6) NULL,
		[I17_TOT_TAX_PREM_M_4] [decimal](28, 6) NULL,
		[I17_TOT_TAX_PREM_M_5] [decimal](28, 6) NULL,
		[I17_TOT_TAX_PREM_M_6] [decimal](28, 6) NULL,
		[I17_TOT_TAX_PREM_M_7] [decimal](28, 6) NULL,
		[I17_TOT_TAX_PREM_M_8] [decimal](28, 6) NULL,
		[I17_TOT_TAX_PREM_M_9] [decimal](28, 6) NULL,
		[I17_TVOG_IF] [decimal](28, 6) NULL,
		[IFRS_METHOD] [varchar](5) NULL,
		[COV_NUM] [varchar](6) NULL,
		[POLICY_LOAN] [decimal](28, 6) NULL,
		[POLICY_NUM] [varchar](10) NULL,
		[POLICY_YEAR] [varchar](4) NULL,
		[RUN_IDENTIFIER] [varchar](10) NULL,
		[RUN_NUM] [varchar](10) NULL,
		[RUN_STEP] [varchar](10) NULL,
		[SUM_ASSURED_TOTAL] [decimal](28, 6) NULL,
		[TERR_CD] [varchar](4) NULL,
		[VALUATION_DAY] [varchar](2) NULL,
		[VALUATION_MONTH] [varchar](2) NULL,
		[VALUATION_YEAR] [varchar](4) NULL
	)
	;

	exec [dbo].[CONVERT_TO_PARTITION_TABLE] '[dbo].[TC-CopyTableStructure-CanCopyWideTable-TBL]';
	insert into [dbo].[TC-CopyTableStructure-CanCopyWideTable-TBL](PARTITION_ID) values (1);

	--	when
	exec [dbo].[COPY_TABLE_STRUCTURE]
		'[dbo].[TC-CopyTableStructure-CanCopyWideTable-TBL]'
		,'[dbo].[TC-CopyTableStructure-CanCopyWideTable-TBL1]',1
		;

	--  then
	declare @result xml=[dbo].[IS_TABLE_STRUCTURE_EQUALS](
		'[dbo].[TC-CopyTableStructure-CanCopyWideTable-TBL]'
		,'[dbo].[TC-CopyTableStructure-CanCopyWideTable-TBL1]'
		,'SKIP_PARTITIONS'
	)
	;
    select 'test_scnario£º' test_case,'CanCopyWideTable' result
    union all
    select 'CanCopyWideTable.' test_case, 'pass' result
	union all
	select 
		'TheTableAfterCopyEqualToOriginalTable.' test_case
		, iif(
			'true'=@result.value('(/Result/Value)[1]','nvarchar(8)')
			,'pass','failed'
		) result
	;
	if 'true' <> @result.value('(/Result/Value)[1]','nvarchar(8)')
		select @result.query('/Result/DetailMessage')
	rollback
END TRY
BEGIN CATCH
    exec [dbo].[PRINT_ERROR_MSG];
    rollback
END CATCH
go


-- 	################################## [TC-CopyTableStructure-CanCopyTableWithConstraint]: Test can clean up target partition ############################
BEGIN TRAN
BEGIN TRY
	--  given
	drop table if exists [dbo].[TC-CopyTableStructure-CanCopyTableWithConstraint-TBL];
	drop table if exists [dbo].[TC-CopyTableStructure-CanCopyTableWithConstraint-TBL1];

	create table [dbo].[TC-CopyTableStructure-CanCopyTableWithConstraint-TBL](
		PARTITION_ID int NOT NULL
        ,pk_id int       NOT NULL
        ,str_data varchar(32) default '' check(len(str_data) > 1) 
        ,primary key nonclustered (
            PARTITION_ID,pk_id desc
        )
        ,check(PARTITION_ID + pk_id > 0 )
		,check(PARTITION_ID + pk_id + 1 > 1 )
	)
	;

	--	when
	exec [dbo].[COPY_TABLE_STRUCTURE]
		'[dbo].[TC-CopyTableStructure-CanCopyTableWithConstraint-TBL]'
		,'[dbo].[TC-CopyTableStructure-CanCopyTableWithConstraint-TBL1]',1
		,'WITH_CONSTRAINTS'
		;

	--  then
	declare @result xml=[dbo].[IS_TABLE_STRUCTURE_EQUALS](
		'[dbo].[TC-CopyTableStructure-CanCopyTableWithConstraint-TBL]'
		,'[dbo].[TC-CopyTableStructure-CanCopyTableWithConstraint-TBL1]'
		,'SKIP_PARTITIONS'
	)
	;
    select 'test_scnario£º' test_case,'CanCopyTableWithConstraint' result
    union all
    select 'CanCopyTableWithConstraint.' test_case, 'pass' result
	union all
	select 
		'TheTableAfterCopyEqualToOriginalTable.' test_case
		, iif(
			'true'=@result.value('(/Result/Value)[1]','nvarchar(8)')
			,'pass','failed'
		) result
	;

	if 'true' <> @result.value('(/Result/Value)[1]','nvarchar(8)')
		select @result.query('/Result/DetailMessage')
	rollback
END TRY
BEGIN CATCH
    exec [dbo].[PRINT_ERROR_MSG];
    rollback
END CATCH
go



-- 	################################## [TC-CopyTableStructure-CanCopyTableWithPartition]: Test can copy partition table and the target table will reuse the partition scheme. ############################
BEGIN TRAN
BEGIN TRY
	--  given
	drop table if exists [dbo].[TC-CopyTableStructure-CanCopyTableWithPartition-TBL];
	drop table if exists [dbo].[TC-CopyTableStructure-CanCopyTableWithPartition-TBL1];

	create table [dbo].[TC-CopyTableStructure-CanCopyTableWithPartition-TBL](
		PARTITION_ID int
		,str_data varchar(32)
	)
	;

	exec [dbo].[CONVERT_TO_PARTITION_TABLE] '[dbo].[TC-CopyTableStructure-CanCopyTableWithPartition-TBL]';
	insert into [dbo].[TC-CopyTableStructure-CanCopyTableWithPartition-TBL] values (1,'abc');

	--	when
	exec [dbo].[COPY_TABLE_STRUCTURE]
		'[dbo].[TC-CopyTableStructure-CanCopyTableWithPartition-TBL]'
		,'[dbo].[TC-CopyTableStructure-CanCopyTableWithPartition-TBL1]',1
		,'WITH_PARTITIONS_AND_REUSE_PARTITION_FUNCTION_AND_SCHEME'
		;

	--  then
	insert into [dbo].[TC-CopyTableStructure-CanCopyTableWithPartition-TBL1] 
	select * from [dbo].[TC-CopyTableStructure-CanCopyTableWithPartition-TBL];

	declare @result xml=[dbo].[IS_TABLE_STRUCTURE_EQUALS](
		'[dbo].[TC-CopyTableStructure-CanCopyTableWithPartition-TBL]'
		,'[dbo].[TC-CopyTableStructure-CanCopyTableWithPartition-TBL1]'
		,''
	)
	;
    select 'test_scnario£º' test_case,'CanCopyTableWithPartition' result
    union all
    select 'CanCopyTableWithPartition.' test_case, 'pass' result
	union all
	select 
		'TheTableAfterCopyEqualToOriginalTable.' test_case
		, iif(
			'true'=@result.value('(/Result/Value)[1]','nvarchar(8)')
			,'pass','failed'
		) result
	union all 
	select 
		'TheTableAfterCopyWillReusePartitionFunctionAndScheme.' test_case
		, iif(
			(select PARTITION_FUNCTION from [dbo].[TABLE_PARTITION_INFO_SIMPLE] where TABLE_OBJECT_ID = object_id('[dbo].[TC-CopyTableStructure-CanCopyTableWithPartition-TBL]'))
				=(select PARTITION_FUNCTION from [dbo].[TABLE_PARTITION_INFO_SIMPLE] where TABLE_OBJECT_ID = object_id('[dbo].[TC-CopyTableStructure-CanCopyTableWithPartition-TBL1]'))
			and (select PARTITION_SCHEME from [dbo].[TABLE_PARTITION_INFO_SIMPLE] where TABLE_OBJECT_ID = object_id('[dbo].[TC-CopyTableStructure-CanCopyTableWithPartition-TBL]'))
				=(select PARTITION_SCHEME from [dbo].[TABLE_PARTITION_INFO_SIMPLE] where TABLE_OBJECT_ID = object_id('[dbo].[TC-CopyTableStructure-CanCopyTableWithPartition-TBL1]'))
			,'pass','failed'
		) result
	;
	if 'true' <> @result.value('(/Result/Value)[1]','nvarchar(8)')
		select @result.query('/Result/DetailMessage')
	rollback
END TRY
BEGIN CATCH
    exec [dbo].[PRINT_ERROR_MSG];
    rollback
END CATCH
go



-- 	################################## [TC-CopyTableStructure-CanCopyTableWithCreateNewPartition]: Test can copy partition table and the target table will reuse the partition scheme. ############################
BEGIN TRAN
BEGIN TRY
	--  given
	drop table if exists [dbo].[TC-CopyTableStructure-CanCopyTableWithCreateNewPartition-TBL];
	drop table if exists [dbo].[TC-CopyTableStructure-CanCopyTableWithCreateNewPartition-TBL1];

	create table [dbo].[TC-CopyTableStructure-CanCopyTableWithCreateNewPartition-TBL](
		PARTITION_ID int
		,str_data varchar(32)
	)
	;

	exec [dbo].[CONVERT_TO_PARTITION_TABLE] '[dbo].[TC-CopyTableStructure-CanCopyTableWithCreateNewPartition-TBL]';
	insert into [dbo].[TC-CopyTableStructure-CanCopyTableWithCreateNewPartition-TBL] values (1,'abc');

	--	when
	exec [dbo].[COPY_TABLE_STRUCTURE]
		'[dbo].[TC-CopyTableStructure-CanCopyTableWithCreateNewPartition-TBL]'
		,'[dbo].[TC-CopyTableStructure-CanCopyTableWithCreateNewPartition-TBL1]',1
		,'WITH_PARTITIONS_AND_CREATE_NEW_PARTITION_FUNCTION_AND_SCHEME'
		;

	--  then
	insert into [dbo].[TC-CopyTableStructure-CanCopyTableWithCreateNewPartition-TBL1] 
	select * from [dbo].[TC-CopyTableStructure-CanCopyTableWithCreateNewPartition-TBL];

	declare @result xml=[dbo].[IS_TABLE_STRUCTURE_EQUALS](
		'[dbo].[TC-CopyTableStructure-CanCopyTableWithCreateNewPartition-TBL]'
		,'[dbo].[TC-CopyTableStructure-CanCopyTableWithCreateNewPartition-TBL1]'
		,''
	)
	;
    select 'test_scnario£º' test_case,'CanCopyTableWithCreateNewPartition' result
    union all
    select 'CanCopyTableWithCreateNewPartition.' test_case, 'pass' result
	union all
	select 
		'TheTableAfterCopyEqualToOriginalTable.' test_case
		, iif(
			'true'=@result.value('(/Result/Value)[1]','nvarchar(8)')
			,'pass','failed'
		) result
	union all 
	select 
		'TheTableAfterCopyWillReusePartitionFunctionAndScheme.' test_case
		, iif(
			(select PARTITION_FUNCTION from [dbo].[TABLE_PARTITION_INFO_SIMPLE] where TABLE_OBJECT_ID = object_id('[dbo].[TC-CopyTableStructure-CanCopyTableWithCreateNewPartition-TBL]'))
				<>(select PARTITION_FUNCTION from [dbo].[TABLE_PARTITION_INFO_SIMPLE] where TABLE_OBJECT_ID = object_id('[dbo].[TC-CopyTableStructure-CanCopyTableWithCreateNewPartition-TBL1]'))
			and (select PARTITION_SCHEME from [dbo].[TABLE_PARTITION_INFO_SIMPLE] where TABLE_OBJECT_ID = object_id('[dbo].[TC-CopyTableStructure-CanCopyTableWithCreateNewPartition-TBL]'))
				<>(select PARTITION_SCHEME from [dbo].[TABLE_PARTITION_INFO_SIMPLE] where TABLE_OBJECT_ID = object_id('[dbo].[TC-CopyTableStructure-CanCopyTableWithCreateNewPartition-TBL1]'))
			,'pass','failed'
		) result
	;
	if 'true' <> @result.value('(/Result/Value)[1]','nvarchar(8)')
		select @result.query('/Result/DetailMessage')
	rollback
END TRY
BEGIN CATCH
    exec [dbo].[PRINT_ERROR_MSG];
    rollback
END CATCH
go