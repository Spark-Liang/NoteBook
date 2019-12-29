--	############################################################################
--	This is the view to get the partition information with hight performance.
--  [TABLE_OBJECT_ID]   : object id of the table.
--  [SCHEMA_NAME]       : The database schema of the table.
--  [TABLE_NAME]        : The name of the table.
--  [PARTITION_FUNCTION]: The partition function of the table.
--  [PARTITION_SCHEME]  : The partition scheme of the table.
--  [PARTITION_NUMBER]  : The index of the table partition in the table, the index is started with 1.
--  [FILE_GROUP]        : The file group of the table partition.
--  [RANGE_BOUNDARY]    : The boundary value of the table partition.
--  [RANGE_BOUNDARY_BELONG_TO] : The boundary value is belong to left partition or right partition.
--  object_id           :                 
--  schema_id           : 
--  partition_id        : 
--  function_id         : 
--  partition_scheme_id : 
--  data_space_id       : 
--	############################################################################

DROP VIEW IF EXISTS [dbo].[TABLE_PARTITION_INFO_SIMPLE];
GO

CREATE VIEW [dbo].[TABLE_PARTITION_INFO_SIMPLE]
AS
SELECT
    i.object_id                     as [TABLE_OBJECT_ID]
    ,s.name                         as [SCHEMA_NAME]
    ,t.name                         as [TABLE_NAME]
    ,pf.name                        as [PARTITION_FUNCTION]
    ,ps.name  						as [PARTITION_SCHEME]
    ,c.name                         as [PARTITION_COLUMN]
	,lower(c_type.name)				as [PARTITION_COLUMN_TYPE]
	,c.max_length					as [PARTITION_COLUMN_MAX_LENGTH]
	,c.precision					as [PARTITION_COLUMN_PRECISION]
	,c.scale						as [PARTITION_COLUMN_SCALE]
    ,p.partition_number             as [PARTITION_NUMBER]
    ,ds2.name 						as [FILE_GROUP]
    ,convert(nvarchar(4000),v.value)as [RANGE_BOUNDARY]			-- convert to string into provide the maximum compatibility.
    ,iif(pf.boundary_value_on_right = 1,'right','left')as [RANGE_BOUNDARY_BELONG_TO]
    ,i.object_id
    ,s.schema_id
    ,p.partition_id
    ,pf.function_id
    ,dds.partition_scheme_id
    ,ps.data_space_id
from sys.indexes i
left join sys.tables t on
    i.object_id = t.object_id
left join sys.schemas s on
    t.schema_id = s.schema_id
join sys.partition_schemes ps on
    i.data_space_id = ps.data_space_id
join sys.destination_data_spaces dds on
    ps.data_space_id = dds.partition_scheme_id
join sys.data_spaces ds2 on
    dds.data_space_id = ds2.data_space_id
join sys.partitions p on
    dds.destination_id = p.partition_number
    and p.object_id = i.object_id
    and p.index_id = i.index_id
join sys.partition_functions pf on
    ps.function_id = pf.function_id
join sys.index_columns ic ON
    i.object_id = ic.object_id
    and i.index_id = ic.index_id
    and ic.partition_ordinal=1
join sys.columns c on
    i.object_id = c.object_id
    and ic.column_id = c.column_id
join sys.types c_type on c.user_type_id = c_type.user_type_id
LEFT JOIN sys.Partition_Range_values v on
    pf.function_id = v.function_id
    and v.boundary_id = p.partition_number - pf.boundary_value_on_right
where i.index_id in (0, 1)
;