/****** Object:  Table [dbo].[CONTRACTS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CONTRACTS](
	[CONTRNUMBER] [nvarchar](10) NOT NULL,
	[CONTRNAME] [nvarchar](50) NOT NULL,
	[CONTRTYPE] [nvarchar](50) NOT NULL,
	[STARTDATE] [datetime] NOT NULL,
	[ENDDATE] [datetime] NOT NULL,
	[BUDGET] [money] NOT NULL,
	[CONTACTID] [char](35) NOT NULL,
	[PROJID] [char](10) NOT NULL,
	[RETENTION] [money] NOT NULL,
	[CUTOFF] [money] NOT NULL,
	[CLIENTID] [int] NOT NULL,
	[ToJoinCONT] [int] NOT NULL,
	[CONTRID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[MARKETSITEID] [int] NOT NULL,
	[MPID] [nvarchar](36) NOT NULL,
	[TPSHORTNAME] [nvarchar](50) NOT NULL,
	[TPNAME] [nvarchar](50) NOT NULL,
	[BUYERUSERID] [nvarchar](25) NOT NULL,
	[BUYERPASSWORD] [nvarchar](50) NOT NULL,
	[BORGID] [int] NOT NULL,
	[INVTOID] [int] NOT NULL,
	[DELTOID] [int] NOT NULL,
	[EID] [char](10) NOT NULL,
	[FOREXID1] [char](3) NOT NULL,
	[FOREXVAL1] [money] NOT NULL,
	[FOREXID2] [char](3) NOT NULL,
	[FOREXVAL2] [money] NOT NULL,
	[FOREXID3] [char](3) NOT NULL,
	[FOREXVAL3] [money] NOT NULL,
	[FOREXID4] [char](3) NOT NULL,
	[FOREXVAL4] [money] NOT NULL,
	[FOREXID5] [char](3) NOT NULL,
	[FOREXVAL5] [money] NOT NULL,
	[STKHIREPRC] [decimal](18, 2) NOT NULL,
	[ConStatus] [int] NOT NULL,
	[ESTCOST] [money] NOT NULL,
	[ESTREV] [money] NOT NULL,
	[CONDESC] [nvarchar](250) NOT NULL,
	[JDECODE] [nchar](100) NULL,
	[BASEINDEX] [numeric](18, 4) NOT NULL,
	[CURRENTINDEX] [numeric](18, 4) NOT NULL,
	[ESCPERC] [numeric](18, 4) NOT NULL,
	[USEGLOBALESC] [bit] NOT NULL,
	[USEESCPERC] [bit] NOT NULL,
	[CANDYFOREXID1] [int] NOT NULL,
	[CANDYFOREXVAL1] [decimal](23, 10) NOT NULL,
	[CANDYFOREXCODE1] [nvarchar](3) NOT NULL,
	[CANDYFOREXID2] [int] NOT NULL,
	[CANDYFOREXVAL2] [decimal](23, 10) NOT NULL,
	[CANDYFOREXCODE2] [nvarchar](3) NOT NULL,
	[ENDDATEACTUAL] [datetime] NULL,
	[PHDAYSINWEEK] [decimal](8, 4) NOT NULL,
 CONSTRAINT [PK_CONTRACTS] PRIMARY KEY CLUSTERED 
(
	[CONTRID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [IX_CONTRACTS] UNIQUE NONCLUSTERED 
(
	[CONTRNUMBER] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CONTRACTS] ADD  CONSTRAINT [DF_CONTRACTS_ToJoinCONT]  DEFAULT (8) FOR [ToJoinCONT]
ALTER TABLE [dbo].[CONTRACTS] ADD  CONSTRAINT [DF_CONTRACTS_MARKETSITEID]  DEFAULT ((-1)) FOR [MARKETSITEID]
ALTER TABLE [dbo].[CONTRACTS] ADD  CONSTRAINT [DF_CONTRACTS_MPID]  DEFAULT ('') FOR [MPID]
ALTER TABLE [dbo].[CONTRACTS] ADD  CONSTRAINT [DF_CONTRACTS_TPSHORTNAME]  DEFAULT ('') FOR [TPSHORTNAME]
ALTER TABLE [dbo].[CONTRACTS] ADD  CONSTRAINT [DF_CONTRACTS_TPNAME]  DEFAULT ('') FOR [TPNAME]
ALTER TABLE [dbo].[CONTRACTS] ADD  CONSTRAINT [DF_CONTRACTS_BUYERUSERID]  DEFAULT ('') FOR [BUYERUSERID]
ALTER TABLE [dbo].[CONTRACTS] ADD  CONSTRAINT [DF_CONTRACTS_BUYERPASSWORD]  DEFAULT ('') FOR [BUYERPASSWORD]
ALTER TABLE [dbo].[CONTRACTS] ADD  CONSTRAINT [DF_CONTRACTS_INVTOID]  DEFAULT ((-1)) FOR [BORGID]
ALTER TABLE [dbo].[CONTRACTS] ADD  CONSTRAINT [DF_CONTRACTS_DELTOID]  DEFAULT ((-1)) FOR [INVTOID]
ALTER TABLE [dbo].[CONTRACTS] ADD  CONSTRAINT [DF_CONTRACTS_EID]  DEFAULT ((-1)) FOR [DELTOID]
ALTER TABLE [dbo].[CONTRACTS] ADD  CONSTRAINT [DF_CONTRACTS_EID_1]  DEFAULT ('') FOR [EID]
ALTER TABLE [dbo].[CONTRACTS] ADD  CONSTRAINT [DF_CONTRACTS_FOREXID1]  DEFAULT ('') FOR [FOREXID1]
ALTER TABLE [dbo].[CONTRACTS] ADD  CONSTRAINT [DF_CONTRACTS_FOREXVAL1]  DEFAULT (1) FOR [FOREXVAL1]
ALTER TABLE [dbo].[CONTRACTS] ADD  CONSTRAINT [DF_CONTRACTS_FOREXID2]  DEFAULT ('') FOR [FOREXID2]
ALTER TABLE [dbo].[CONTRACTS] ADD  CONSTRAINT [DF_CONTRACTS_FOEREXVAL2]  DEFAULT (0) FOR [FOREXVAL2]
ALTER TABLE [dbo].[CONTRACTS] ADD  CONSTRAINT [DF_CONTRACTS_FOREXID]  DEFAULT ('') FOR [FOREXID3]
ALTER TABLE [dbo].[CONTRACTS] ADD  CONSTRAINT [DF_CONTRACTS_FOREXVAL3]  DEFAULT (0) FOR [FOREXVAL3]
ALTER TABLE [dbo].[CONTRACTS] ADD  CONSTRAINT [DF_CONTRACTS_FOREXID4]  DEFAULT ('') FOR [FOREXID4]
ALTER TABLE [dbo].[CONTRACTS] ADD  CONSTRAINT [DF_CONTRACTS_FOREXVAL4]  DEFAULT (0) FOR [FOREXVAL4]
ALTER TABLE [dbo].[CONTRACTS] ADD  CONSTRAINT [DF_CONTRACTS_FOREXID5]  DEFAULT ('') FOR [FOREXID5]
ALTER TABLE [dbo].[CONTRACTS] ADD  CONSTRAINT [DF_CONTRACTS_FOREXVAL5]  DEFAULT (0) FOR [FOREXVAL5]
ALTER TABLE [dbo].[CONTRACTS] ADD  CONSTRAINT [DF_CONTRACTS_STKHIREPRC]  DEFAULT (0) FOR [STKHIREPRC]
ALTER TABLE [dbo].[CONTRACTS] ADD  CONSTRAINT [DF__CONTRACTS__ConSt__1B36525C]  DEFAULT (0) FOR [ConStatus]
ALTER TABLE [dbo].[CONTRACTS] ADD  CONSTRAINT [DF__CONTRACTS__ESTCO__4714D49A]  DEFAULT (0) FOR [ESTCOST]
ALTER TABLE [dbo].[CONTRACTS] ADD  CONSTRAINT [DF__CONTRACTS__ESTRE__4808F8D3]  DEFAULT (0) FOR [ESTREV]
ALTER TABLE [dbo].[CONTRACTS] ADD  DEFAULT ('') FOR [CONDESC]
ALTER TABLE [dbo].[CONTRACTS] ADD  CONSTRAINT [DF_CONTRACTS_BASEINDEX]  DEFAULT ('0') FOR [BASEINDEX]
ALTER TABLE [dbo].[CONTRACTS] ADD  CONSTRAINT [DF_CONTRACTS_CURRENTINDEX]  DEFAULT ('0') FOR [CURRENTINDEX]
ALTER TABLE [dbo].[CONTRACTS] ADD  CONSTRAINT [DF_CONTRACTS_ESCPERC]  DEFAULT ('0') FOR [ESCPERC]
ALTER TABLE [dbo].[CONTRACTS] ADD  CONSTRAINT [DF_CONTRACTS_USEGLOBALESC]  DEFAULT ('0') FOR [USEGLOBALESC]
ALTER TABLE [dbo].[CONTRACTS] ADD  CONSTRAINT [DF_CONTRACTS_USEESCPERC]  DEFAULT ('1') FOR [USEESCPERC]
ALTER TABLE [dbo].[CONTRACTS] ADD  CONSTRAINT [DF_CONTRACTS_CANDYFOREXID1]  DEFAULT ((-1)) FOR [CANDYFOREXID1]
ALTER TABLE [dbo].[CONTRACTS] ADD  CONSTRAINT [DF_CONTRACTS_CANDYFOREXVAL1]  DEFAULT ((0)) FOR [CANDYFOREXVAL1]
ALTER TABLE [dbo].[CONTRACTS] ADD  CONSTRAINT [DF_CONTRACTS_CANDYFOREXCODE1]  DEFAULT (N'ZAR') FOR [CANDYFOREXCODE1]
ALTER TABLE [dbo].[CONTRACTS] ADD  CONSTRAINT [DF_CONTRACTS_CANDYFOREXID2]  DEFAULT ((-1)) FOR [CANDYFOREXID2]
ALTER TABLE [dbo].[CONTRACTS] ADD  CONSTRAINT [DF_CONTRACTS_CANDYFOREXVAL2]  DEFAULT ((0)) FOR [CANDYFOREXVAL2]
ALTER TABLE [dbo].[CONTRACTS] ADD  CONSTRAINT [DF_CONTRACTS_CANDYFOREXCODE2]  DEFAULT (N'ZAR') FOR [CANDYFOREXCODE2]
ALTER TABLE [dbo].[CONTRACTS] ADD  CONSTRAINT [DF_CONTRACTS_PHDAYSINWEEK]  DEFAULT ((0)) FOR [PHDAYSINWEEK]
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE TRIGGER LOGMASTERCONTRACTS ON CONTRACTS
AFTER UPDATE, DELETE, INSERT
AS 

SET NOCOUNT ON

declare @tableName varChar(25)
declare @primaryKey varChar(25)
declare @ignoreList varChar(500)

set @tableName = 'CONTRACTS'
set @primaryKey = 'CONTRID'
set @ignoreList = ''

declare @action varChar(25)
declare @logUserID int
declare @logDateTime datetime
declare @borgid int
declare @page varChar(100)
declare @info varChar(250)
declare @application varChar(3)
declare @version varChar(15)
declare @context_info int
declare @sqlTblCols nVarChar(max)
declare @sql nVarChar(max)

set @context_info = -1
set @ignoreList = ',' + replace(@ignoreList, ' ', '') + ','
set @action = ''
set @logUserID = -1
set @logDateTime = DATEADD(M, -1, getDate()) 
set @borgid = -1
set @page = ''
set @info = ''
set @application = ''
set @version = ''
set @sqlTblCols = ''
set @sql = ''

if exists(select * from INSERTED)
BEGIN
	if exists(select * from DELETED)
	BEGIN
		set @action = 'UPDATE'
	END
	ELSE
	BEGIN
		set @action = 'INSERT'
	END
END
ELSE
BEGIN
	if exists(select * from DELETED)
	BEGIN
		set @action = 'DELETE'
	END
END
 
select * into #inserted from INSERTED
select * into #deleted from DELETED

SELECT @context_info = cast(replace(cast(CONTEXT_INFO as varchar(128)), char(0) COLLATE SQL_Latin1_General_CP1_CI_AS,'') as int) FROM master.dbo.sysprocesses WHERE spid = @@SPID

select @logUserID = isnull(USERID, -1),
@logDateTime = isnull(LOGDATETIME, DATEADD(M, -1, getDate())),
@borgid = isnull(BORGID, @borgid),
@page = isnull(PAGE, @page),
@info = isnull(INFO, @info),
@application  = isnull(APPLICATION, @application),
@version = isnull(VERSION, @version)
from logcontext 
where LOGID = @context_info
	
delete FROM LOGCONTEXT where LOGID = @context_info
   
if @action = 'UPDATE'
BEGIN		
	Select @sqlTblCols = @sqlTblCols + 'Case when rtrim(cast(IsNull(i.[' + Column_Name + '],0) as varChar(100)))=rtrim(cast(IsNull(d.[' + Column_Name + '],0) as varChar(100))) then '''' else ' + '''[' + Column_Name + ']:'' + rtrim(cast(IsNull(d.[' + Column_Name + '],0) as varChar(100)) collate SQL_LATIN1_GENERAL_CP1_CI_AS) + ''' + ' -> '' + rtrim(cast(IsNull(i.[' + Column_Name + '],0) as varChar(100)) collate SQL_LATIN1_GENERAL_CP1_CI_AS) + ''' + ''' + '', ''' + ' end +'
	from information_schema.columns 
	where TABLE_NAME = @tableName
	and PATINDEX('%,' + COLUMN_NAME + ',%', @ignoreList) = 0
	and DATA_TYPE not like '%text%'
	and DATA_TYPE not like '%image%'
	and DATA_TYPE not like '%binary%' 
		
	set @sqlTblCols = Substring(@sqlTblCols, 1 , len(@sqlTblCols) - 1)

	set @sql = 'select ''' + cast(@logUserID as varChar(10)) + ''', ''' + cast(@borgid as varChar(10)) + ''', ''' + @application + ''', ''' + @tableName + ''', ''' + @action + ''', ''' + @page + ''', ''' + @info + ''', ''' + @version + ''', '''+ @primaryKey +' = '' + cast(i.'+ @primaryKey +' as varChar(10)), Substring(' + @sqlTblCols + ', 1 , len(' + @sqlTblCols + ') - 1) '
	set @sql = @sql + 'From #inserted i inner join #deleted d on i.'+ @primaryKey +' = d.'+ @primaryKey +' where isnull(' + @sqlTblCols + ', '''') <> '''' ' 

	insert into LOGMASTER (USERID, BORGID, APPLICATION, TABLENAME, ACTION, PAGE, INFO, VERSION, PRIMARYKEY, DETAILS)
	exec sp_executesql @sql
END   

if @action = 'DELETE' or @action = 'INSERT'
BEGIN
  Select @sqlTblCols = @sqlTblCols + '''[' + Column_Name + ']:'' + rtrim(cast(IsNull(d.[' + Column_Name + '],0) as varChar(100)) collate SQL_LATIN1_GENERAL_CP1_CI_AS) + '', '' + '
	from information_schema.columns 
	where TABLE_NAME = @tableName
	and PATINDEX('%,' + COLUMN_NAME + ',%', @ignoreList) = 0
	and DATA_TYPE not like '%text%'
	and DATA_TYPE not like '%image%'
	and DATA_TYPE not like '%binary%' 
		
	set @sqlTblCols = Substring(@sqlTblCols, 1, len(@sqlTblCols) - 5) + ''''
	
	set @sql = 'select ''' + cast(@logUserID as varChar(10)) + ''', ''' + cast(@borgid as varChar(10)) + ''', ''' + @application + ''', ''' + @tableName + ''', ''' + @action + ''', ''' + @page + ''', ''' + @info + ''', ''' + @version + ''', '''+ @primaryKey +' = '' + cast(d.'+ @primaryKey +' as varChar(10)), ' + @sqlTblCols + ' '
	set @sql = @sql + 'From '+ case when @action = 'DELETE' then '#deleted' else '#inserted' end +' d ' 
 
	insert into LOGMASTER (USERID, BORGID, APPLICATION, TABLENAME, ACTION, PAGE, INFO, VERSION, PRIMARYKEY, DETAILS)
	exec sp_executesql @sql
END

DROP TABLE #inserted
DROP TABLE #deleted

		
ALTER TABLE [dbo].[CONTRACTS] ENABLE TRIGGER [LOGMASTERCONTRACTS]