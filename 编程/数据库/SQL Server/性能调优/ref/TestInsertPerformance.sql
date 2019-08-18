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

GO
-- ######################################### propared test data #############################################


-- ######################################### test  #############################################
set statistics time off
drop table if exists #TestTblVarInsert;
select * into #TestTblVarInsert from TestProperties;
drop table if exists #TestTmpTblInsert;
select * into #TestTmpTblInsert from TestProperties;
drop table if exists #TestTmpTblSelectInto;
select * into #TestTmpTblSelectInto from TestProperties;
drop table if exists #TestTblInsert;
select * into #TestTblInsert from TestProperties;
drop table if exists #TestTblSelectInto;
select * into #TestTblSelectInto from TestProperties;
GO


DBCC DROPCLEANBUFFERS  --清除缓冲区
DBCC FREEPROCCACHE  --删除计划高速缓存中的元素
declare @TestTblVarTGT as table(
	P_OPID int,
	O_OPID int,
	P_NAME varchar(1024),
	P_INT_VALUE int,
	P_STR_VALUE varchar(1024),
	P_DATE_VALUE date
);
print 'TestTblVar'
set statistics time on;
insert into @TestTblVarTGT select * from #TestTblVarInsert;
set statistics time off;
GO


DBCC DROPCLEANBUFFERS  --清除缓冲区
DBCC FREEPROCCACHE  --删除计划高速缓存中的元素
drop table if exists #TestTmpTblInsertTGT;
create table #TestTmpTblInsertTGT(
	P_OPID int,
	O_OPID int,
	P_NAME varchar(1024),
	P_INT_VALUE int,
	P_STR_VALUE varchar(1024),
	P_DATE_VALUE date
);
print 'TestTmpTblInsert'
set statistics time on;
insert into #TestTmpTblInsertTGT select * from #TestTmpTblInsert;
set statistics time off;
GO


DBCC DROPCLEANBUFFERS  --清除缓冲区
DBCC FREEPROCCACHE  --删除计划高速缓存中的元素
drop table if exists #TestTmpTblSelectIntoTGT;
print 'TestTmpTblSelectInto'
set statistics time on;
select * into #TestTmpTblSelectIntoTGT from #TestTmpTblSelectInto;
set statistics time off;
GO


DBCC DROPCLEANBUFFERS  --清除缓冲区
DBCC FREEPROCCACHE  --删除计划高速缓存中的元素
drop table if exists TestTblInsertTGT;
create table TestTblInsertTGT(
	P_OPID int,
	O_OPID int,
	P_NAME varchar(1024),
	P_INT_VALUE int,
	P_STR_VALUE varchar(1024),
	P_DATE_VALUE date
);
print 'TestTblInsert'
set statistics time on;
insert into TestTblInsertTGT select * from #TestTblInsert;
set statistics time off;


DBCC DROPCLEANBUFFERS  --清除缓冲区
DBCC FREEPROCCACHE  --删除计划高速缓存中的元素
drop table if exists TestTblSelectIntoTGT;
print 'TestTblSelectInto'
set statistics time on;
select * into TestTblSelectIntoTGT from #TestTblSelectInto;
set statistics time off;
GO