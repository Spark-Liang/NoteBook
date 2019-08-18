-- ######################################### propared test data #############################################
drop table if exists TestProperties;

declare @TestPropertiesVar as table(
	P_OPID int primary key identity,
	O_OPID int index O_OPID_IDX,
	P_NAME varchar(1024),
	P_INT_VALUE int,
	P_STR_VALUE varchar(1024),
	P_DATE_VALUE date
);

declare @i as int;
declare @max_parent_oid as int;
set @i=0;
while @i < 20000
begin
	set @max_parent_oid=(select max(O_OPID) from @TestPropertiesVar);
	insert into @TestPropertiesVar(O_OPID,P_NAME,P_INT_VALUE,P_STR_VALUE,P_DATE_VALUE) values 
	 (@i,'PARENT_OID',round(rand() * @max_parent_oid,0),null,null)
	,(@i,'Property_A',null,REPLICATE(CHAR(65 + round(rand() * 26,0)),RAND() * 1024),null)
	,(@i,'Property_B',null,REPLICATE(CHAR(65 + round(rand() * 26,0)),RAND() * 1024),null)
	,(@i,'Property_C',null,REPLICATE(CHAR(65 + round(rand() * 26,0)),RAND() * 1024),null)
	,(@i,'Property_D',null,REPLICATE(CHAR(65 + round(rand() * 26,0)),RAND() * 1024),null)
	,(@i,'Property_E',null,REPLICATE(CHAR(65 + round(rand() * 26,0)),RAND() * 1024),null)
	,(@i,'Property_F',null,REPLICATE(CHAR(65 + round(rand() * 26,0)),RAND() * 1024),null)
	;
	set @i=@i+1;
end

select * into TestProperties from @TestPropertiesVar;

drop view if exists [dbo].[TestContainer];
CREATE view [dbo].[TestContainer]
(
	O_OPID
	,PARENT_OID
	,Property_A
	,Property_B
	,Property_C
	,Property_D
	,Property_E
	,Property_F
) WITH SCHEMABINDING as
select 
	t1.O_OPID
	,t1.P_VALUE PARENT_OID
	,t2.P_VALUE Property_A
	,t3.P_VALUE Property_B
	,t4.P_VALUE Property_C
	,t5.P_VALUE Property_D
	,t6.P_VALUE Property_E
	,t7.P_VALUE Property_F
from (
	select
		O_OPID ,
		P_NAME ,
		P_INT_VALUE P_VALUE 
	from dbo.TestProperties
	where P_NAME = 'PARENT_OID'
) t1
inner join (
	select
		O_OPID ,
		P_NAME ,
		P_STR_VALUE P_VALUE 
	from dbo.TestProperties
	where P_NAME = 'Property_A'
) t2
on t1.O_OPID = t2.O_OPID
inner join (
	select
		O_OPID ,
		P_NAME ,
		P_STR_VALUE P_VALUE  
	from dbo.TestProperties
	where P_NAME = 'Property_B'
) t3
on t1.O_OPID = t3.O_OPID
inner join (
	select
		O_OPID ,
		P_NAME ,
		P_STR_VALUE P_VALUE  
	from dbo.TestProperties
	where P_NAME = 'Property_C'
) t4
on t1.O_OPID = t4.O_OPID
inner join (
	select
		O_OPID ,
		P_NAME ,
		P_STR_VALUE P_VALUE  
	from dbo.TestProperties
	where P_NAME = 'Property_D'
) t5
on t1.O_OPID = t5.O_OPID
inner join (
	select
		O_OPID ,
		P_NAME ,
		P_STR_VALUE P_VALUE  
	from dbo.TestProperties
	where P_NAME = 'Property_E'
) t6
on t1.O_OPID = t6.O_OPID
inner join (
	select
		O_OPID ,
		P_NAME ,
		P_STR_VALUE P_VALUE  
	from dbo.TestProperties
	where P_NAME = 'Property_F'
) t7
on t1.O_OPID = t7.O_OPID
;

GO
-- ######################################### propared test data #############################################



-- #########################################  test  #############################################
DBCC DROPCLEANBUFFERS  --清除缓冲区
DBCC FREEPROCCACHE  --删除计划高速缓存中的元素
drop table if exists #TestContainer;
create table #TestContainer (
	O_OPID  int
	,PARENT_OID int
	,Property_A varchar(1024)
	,Property_B	varchar(1024)
	,Property_C	varchar(1024)
	,Property_D	varchar(1024)
	,Property_E	varchar(1024)
	,Property_F	varchar(1024)
);
insert into #TestContainer select * from TestContainer;
create unique clustered index OID_IDX on #TestContainer(O_OPID);
create index PARENT_OID_IDX on #TestContainer(PARENT_OID);

with tmp as (
	select 
		O_OPID
		,null PARENT_OID
		,0 as OBJECT_LEVEL
		,Property_A
		,Property_B
		,Property_C
		,Property_D
		,Property_E
		,Property_F
	from #TestContainer 
	where PARENT_OID is null
	union all
	select 
		c.O_OPID
		,c.PARENT_OID
		,p.OBJECT_LEVEL + 1 as OBJECT_LEVEL
		,c.Property_A
		,c.Property_B
		,c.Property_C
		,c.Property_D
		,c.Property_E
		,c.Property_F
	from tmp p
	inner join #TestContainer c on
		p.O_OPID = c.PARENT_OID
)
select * from tmp
;
GO 2

DBCC DROPCLEANBUFFERS  --清除缓冲区
DBCC FREEPROCCACHE  --删除计划高速缓存中的元素
declare @TestContainer as table(
	O_OPID  int primary key clustered
	,PARENT_OID int index PARENT_OID_IDX
	,Property_A varchar(1024)
	,Property_B	varchar(1024)
	,Property_C	varchar(1024)
	,Property_D	varchar(1024)
	,Property_E	varchar(1024)
	,Property_F	varchar(1024)
);
insert into @TestContainer select * from TestContainer;

with tmp as (
	select 
		O_OPID
		,null PARENT_OID
		,0 as OBJECT_LEVEL
		,Property_A
		,Property_B
		,Property_C
		,Property_D
		,Property_E
		,Property_F
	from @TestContainer 
	where PARENT_OID is null
	union all
	select 
		c.O_OPID
		,c.PARENT_OID
		,p.OBJECT_LEVEL + 1 as OBJECT_LEVEL
		,c.Property_A
		,c.Property_B
		,c.Property_C
		,c.Property_D
		,c.Property_E
		,c.Property_F
	from tmp p
	inner join @TestContainer c on
		p.O_OPID = c.PARENT_OID
)
select * from tmp
;
GO 2