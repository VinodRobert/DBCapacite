/****** Object:  Table [dbo].[LEDGERCODES]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LEDGERCODES](
	[LedgerCode] [char](10) NOT NULL,
	[LedgerName] [char](35) NULL,
	[LedgerAlloc] [char](35) NOT NULL,
	[LedgerMemo] [text] NULL,
	[LedgerValue] [money] NULL,
	[LedgerDisplay] [bit] NOT NULL,
	[LedgerCurrency] [char](10) NULL,
	[LedgerSummary] [bit] NOT NULL,
	[LedgerControl] [bit] NOT NULL,
	[LedgerControlCode] [int] NULL,
	[LedgerID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[LedgerDesc] [char](55) NULL,
	[ToJoinL] [int] NOT NULL,
	[MozLedgerCode] [char](10) NOT NULL,
	[MozName] [char](80) NOT NULL,
	[LedgerStatus] [int] NOT NULL,
	[FISCALCODE] [char](10) NOT NULL,
	[CONTROLTYPE] [nvarchar](55) NOT NULL,
	[BSHEET] [char](10) NOT NULL,
	[ISOHRECOVERY] [bit] NOT NULL,
	[ICCODE] [nvarchar](10) NOT NULL,
 CONSTRAINT [PK_LEDGERCODES] PRIMARY KEY CLUSTERED 
(
	[LedgerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [IX_LEDGERCODES] UNIQUE NONCLUSTERED 
(
	[LedgerCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_LEDGERCODES_LEDGERALLOC] ON [dbo].[LEDGERCODES]
(
	[LedgerAlloc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_LEDGERCODES_LedgerCode_LedgerName_LedgerID] ON [dbo].[LEDGERCODES]
(
	[LedgerCode] ASC,
	[LedgerName] ASC,
	[LedgerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_LEDGERCODES_LedgerID_LedgerCode_LedgerSummary_LedgerName] ON [dbo].[LEDGERCODES]
(
	[LedgerID] ASC,
	[LedgerCode] ASC,
	[LedgerSummary] ASC,
	[LedgerName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_LEDGERCODES_LedgerSummary_LedgerCode_LedgerID_LedgerName] ON [dbo].[LEDGERCODES]
(
	[LedgerSummary] ASC,
	[LedgerCode] ASC,
	[LedgerID] ASC,
	[LedgerName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_LEDGERCODES_LEDGERSUMMARY_LEDGERCONTROL_LEDGERSTATUS] ON [dbo].[LEDGERCODES]
(
	[LedgerSummary] ASC,
	[LedgerControl] ASC,
	[LedgerStatus] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
ALTER TABLE [dbo].[LEDGERCODES] ADD  CONSTRAINT [DF_LEDGERCODES_LedgerDisplay]  DEFAULT (1) FOR [LedgerDisplay]
ALTER TABLE [dbo].[LEDGERCODES] ADD  CONSTRAINT [DF_LEDGERCODES_LedgerSummary]  DEFAULT (0) FOR [LedgerSummary]
ALTER TABLE [dbo].[LEDGERCODES] ADD  CONSTRAINT [DF_LEDGERCODES_LedgerControl]  DEFAULT (0) FOR [LedgerControl]
ALTER TABLE [dbo].[LEDGERCODES] ADD  CONSTRAINT [DF_LEDGERCODES_ToJoin]  DEFAULT (1) FOR [ToJoinL]
ALTER TABLE [dbo].[LEDGERCODES] ADD  CONSTRAINT [DF_LEDGERCODES_MozLedgerCode]  DEFAULT ('') FOR [MozLedgerCode]
ALTER TABLE [dbo].[LEDGERCODES] ADD  CONSTRAINT [DF_LEDGERCODES_MozName]  DEFAULT ('') FOR [MozName]
ALTER TABLE [dbo].[LEDGERCODES] ADD  CONSTRAINT [DF__LEDGERCOD__Ledge__1C2A7695]  DEFAULT (0) FOR [LedgerStatus]
ALTER TABLE [dbo].[LEDGERCODES] ADD  DEFAULT ('') FOR [FISCALCODE]
ALTER TABLE [dbo].[LEDGERCODES] ADD  CONSTRAINT [DF_LEDGERCODES_CONTROLTYPE]  DEFAULT ('') FOR [CONTROLTYPE]
ALTER TABLE [dbo].[LEDGERCODES] ADD  CONSTRAINT [DF_LEDGERCODES_BSHEET]  DEFAULT ('') FOR [BSHEET]
ALTER TABLE [dbo].[LEDGERCODES] ADD  CONSTRAINT [DF_LEDGERCODES_ISOHRECOVERY]  DEFAULT ('0') FOR [ISOHRECOVERY]
ALTER TABLE [dbo].[LEDGERCODES] ADD  CONSTRAINT [DF_LEDGERCODES_ICCODE]  DEFAULT ('') FOR [ICCODE]
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE TRIGGER LOGMASTERLEDGERCODES ON LEDGERCODES
AFTER UPDATE, DELETE, INSERT
AS 

SET NOCOUNT ON

declare @tableName varChar(25)
declare @primaryKey varChar(25)
declare @ignoreList varChar(500)

set @tableName = 'LEDGERCODES'
set @primaryKey = 'LedgerID'
set @ignoreList = 'LEDGERMEMO,CFMARKERID'

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
 
select LedgerCode,LedgerName,LedgerAlloc,LedgerValue,LedgerDisplay,LedgerCurrency,LedgerSummary,LedgerControl,LedgerControlCode,LedgerID,LedgerDesc,ToJoinL,MozLedgerCode,MozName,LedgerStatus,FISCALCODE,CONTROLTYPE,BSHEET,ISOHRECOVERY, ICCODE into #inserted from INSERTED
select LedgerCode,LedgerName,LedgerAlloc,LedgerValue,LedgerDisplay,LedgerCurrency,LedgerSummary,LedgerControl,LedgerControlCode,LedgerID,LedgerDesc,ToJoinL,MozLedgerCode,MozName,LedgerStatus,FISCALCODE,CONTROLTYPE,BSHEET,ISOHRECOVERY, ICCODE into #deleted from DELETED

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

		
ALTER TABLE [dbo].[LEDGERCODES] ENABLE TRIGGER [LOGMASTERLEDGERCODES]