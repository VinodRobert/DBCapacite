/****** Object:  Table [dbo].[EFTMASTER]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EFTMASTER](
	[eftCustomerID] [nvarchar](5) NOT NULL,
	[eftBatchNo] [int] NOT NULL,
	[eftDateSent] [datetime] NULL,
	[eftTimeSent] [timestamp] NULL,
	[eftActionDate] [datetime] NULL,
	[eftID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[eftService] [nvarchar](4) NOT NULL,
	[eftBank] [int] NOT NULL,
	[eftReference] [nvarchar](30) NOT NULL,
	[eftMethod] [int] NOT NULL,
	[eftOrgID] [int] NOT NULL,
	[eftBankAcc] [nvarchar](50) NOT NULL,
	[eftBranch] [nvarchar](10) NOT NULL,
	[SYSDATE] [datetime] NOT NULL,
	[USERID] [int] NOT NULL,
	[EFTKEY] [nvarchar](32) NULL,
	[EFTENTRYCLASS] [nchar](10) NULL,
	[EHID] [int] NOT NULL,
 CONSTRAINT [PK_EFTMASTER] PRIMARY KEY CLUSTERED 
(
	[eftID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[EFTMASTER] ADD  CONSTRAINT [DF_EFTMASTER_EFTCUSTOMERID]  DEFAULT ('') FOR [eftCustomerID]
ALTER TABLE [dbo].[EFTMASTER] ADD  CONSTRAINT [DF_EFTMASTER_eftBatchNo]  DEFAULT (1) FOR [eftBatchNo]
ALTER TABLE [dbo].[EFTMASTER] ADD  CONSTRAINT [DF_EFTMASTER_EFTSERVICE]  DEFAULT ('SSVS') FOR [eftService]
ALTER TABLE [dbo].[EFTMASTER] ADD  CONSTRAINT [DF_EFTMASTER_eftBank]  DEFAULT (0) FOR [eftBank]
ALTER TABLE [dbo].[EFTMASTER] ADD  CONSTRAINT [DF_EFTMASTER_EFTREFERENCE]  DEFAULT ('') FOR [eftReference]
ALTER TABLE [dbo].[EFTMASTER] ADD  CONSTRAINT [DF_EFTMASTER_eftMethod]  DEFAULT (2) FOR [eftMethod]
ALTER TABLE [dbo].[EFTMASTER] ADD  CONSTRAINT [DF_EFTMASTER_eftOrgID]  DEFAULT (1) FOR [eftOrgID]
ALTER TABLE [dbo].[EFTMASTER] ADD  CONSTRAINT [DF_EFTMASTER_EFTBANKACC]  DEFAULT ('') FOR [eftBankAcc]
ALTER TABLE [dbo].[EFTMASTER] ADD  CONSTRAINT [DF_EFTMASTER_EFTBRANCH]  DEFAULT ('') FOR [eftBranch]
ALTER TABLE [dbo].[EFTMASTER] ADD  CONSTRAINT [DF_EFTMASTER_SYSDATE]  DEFAULT (getdate()) FOR [SYSDATE]
ALTER TABLE [dbo].[EFTMASTER] ADD  CONSTRAINT [DF_EFTMASTER_USERID]  DEFAULT ((-1)) FOR [USERID]
ALTER TABLE [dbo].[EFTMASTER] ADD  CONSTRAINT [DF_EFTMASTER_EHID]  DEFAULT ((-1)) FOR [EHID]
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE TRIGGER LOGMASTEREFTMASTER ON EFTMASTER
AFTER UPDATE, DELETE, INSERT
AS 

SET NOCOUNT ON

declare @tableName varChar(25)
declare @primaryKey varChar(25)
declare @ignoreList varChar(500)

set @tableName = 'EFTMASTER'
set @primaryKey = 'eftID'
set @ignoreList = 'EFTTIMESENT'

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

		
ALTER TABLE [dbo].[EFTMASTER] ENABLE TRIGGER [LOGMASTEREFTMASTER]