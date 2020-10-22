/****** Object:  Table [dbo].[DEBTRECONDEF]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DEBTRECONDEF](
	[ACCSPEC] [int] NOT NULL,
	[ACCSPECNAME] [nvarchar](50) NOT NULL,
	[ORGID] [int] NOT NULL,
	[USECURR] [bit] NOT NULL,
	[USEADV] [bit] NOT NULL,
	[USEVAL] [bit] NOT NULL,
	[USEVARTAB] [bit] NOT NULL,
	[USEINT] [bit] NOT NULL,
	[USENIG] [bit] NOT NULL,
	[USERET] [bit] NOT NULL,
	[USEVAT] [bit] NOT NULL,
	[USEWHT] [bit] NOT NULL,
	[USECONTRA] [bit] NOT NULL,
	[RETADV] [bit] NOT NULL,
	[RETMOS] [bit] NOT NULL,
	[RETADJ] [bit] NOT NULL,
	[RETDIS] [bit] NOT NULL,
	[TAXTM] [char](1) NOT NULL,
	[TAXDD] [bit] NOT NULL,
	[TAXCD] [char](4) NOT NULL,
	[TAXADV] [bit] NOT NULL,
	[TAXRET] [bit] NOT NULL,
	[TAXWHT] [bit] NOT NULL,
	[TAXCONTRA] [bit] NOT NULL,
	[WHTTP] [char](1) NOT NULL,
	[WHTDD] [bit] NOT NULL,
	[WHTSIGN] [int] NOT NULL,
	[WHTID] [int] NOT NULL,
	[WHTADV] [bit] NOT NULL,
	[WHTADJ] [bit] NOT NULL,
	[WHTVAT] [bit] NOT NULL,
	[WHTCONTRA] [bit] NOT NULL,
	[CONTRATP] [char](1) NOT NULL,
	[CONTRATAB] [bit] NOT NULL,
	[CONTRALEDGER] [nvarchar](10) NOT NULL,
	[LAYOUT] [int] NOT NULL,
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[TRANSREFCOL] [nvarchar](10) NOT NULL,
 CONSTRAINT [PK_DEBTRECONDEF] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[DEBTRECONDEF] ADD  CONSTRAINT [DF_DEBTRECONDEF_ACCSPEC]  DEFAULT ('0') FOR [ACCSPEC]
ALTER TABLE [dbo].[DEBTRECONDEF] ADD  CONSTRAINT [DF_DEBTRECONDEF_ACCSPECNAME]  DEFAULT ('') FOR [ACCSPECNAME]
ALTER TABLE [dbo].[DEBTRECONDEF] ADD  CONSTRAINT [DF_DEBTRECONDEF_ORGID]  DEFAULT ('-1') FOR [ORGID]
ALTER TABLE [dbo].[DEBTRECONDEF] ADD  CONSTRAINT [DF_DEBTRECONDEF_USECURR]  DEFAULT ('1') FOR [USECURR]
ALTER TABLE [dbo].[DEBTRECONDEF] ADD  CONSTRAINT [DF_DEBTRECONDEF_USEADV]  DEFAULT ('1') FOR [USEADV]
ALTER TABLE [dbo].[DEBTRECONDEF] ADD  CONSTRAINT [DF_DEBTRECONDEF_USEVAL]  DEFAULT ('1') FOR [USEVAL]
ALTER TABLE [dbo].[DEBTRECONDEF] ADD  CONSTRAINT [DF_DEBTRECONDEF_USEVARTAB]  DEFAULT ('0') FOR [USEVARTAB]
ALTER TABLE [dbo].[DEBTRECONDEF] ADD  CONSTRAINT [DF_DEBTRECONDEF_USEINT]  DEFAULT ('1') FOR [USEINT]
ALTER TABLE [dbo].[DEBTRECONDEF] ADD  CONSTRAINT [DF_DEBTRECONDEF_USENIG]  DEFAULT ('1') FOR [USENIG]
ALTER TABLE [dbo].[DEBTRECONDEF] ADD  CONSTRAINT [DF_DEBTRECONDEF_USERET]  DEFAULT ('1') FOR [USERET]
ALTER TABLE [dbo].[DEBTRECONDEF] ADD  CONSTRAINT [DF_DEBTRECONDEF_USEVAT]  DEFAULT ('1') FOR [USEVAT]
ALTER TABLE [dbo].[DEBTRECONDEF] ADD  CONSTRAINT [DF_DEBTRECONDEF_USEWHT]  DEFAULT ('1') FOR [USEWHT]
ALTER TABLE [dbo].[DEBTRECONDEF] ADD  CONSTRAINT [DF_DEBTRECONDEF_USECONTRA]  DEFAULT ('1') FOR [USECONTRA]
ALTER TABLE [dbo].[DEBTRECONDEF] ADD  CONSTRAINT [DF_DEBTRECONDEF_RETADV]  DEFAULT ('1') FOR [RETADV]
ALTER TABLE [dbo].[DEBTRECONDEF] ADD  CONSTRAINT [DF_DEBTRECONDEF_RETMOS]  DEFAULT ('1') FOR [RETMOS]
ALTER TABLE [dbo].[DEBTRECONDEF] ADD  CONSTRAINT [DF_DEBTRECONDEF_RETADJ]  DEFAULT ('1') FOR [RETADJ]
ALTER TABLE [dbo].[DEBTRECONDEF] ADD  CONSTRAINT [DF_DEBTRECONDEF_RETDIS]  DEFAULT ('1') FOR [RETDIS]
ALTER TABLE [dbo].[DEBTRECONDEF] ADD  CONSTRAINT [DF_DEBTRECONDEF_TAXTM]  DEFAULT ('T') FOR [TAXTM]
ALTER TABLE [dbo].[DEBTRECONDEF] ADD  CONSTRAINT [DF_DEBTRECONDEF_TAXDD]  DEFAULT ('1') FOR [TAXDD]
ALTER TABLE [dbo].[DEBTRECONDEF] ADD  CONSTRAINT [DF_DEBTRECONDEF_TAXCD]  DEFAULT ('') FOR [TAXCD]
ALTER TABLE [dbo].[DEBTRECONDEF] ADD  CONSTRAINT [DF_DEBTRECONDEF_TAXADV]  DEFAULT ('1') FOR [TAXADV]
ALTER TABLE [dbo].[DEBTRECONDEF] ADD  CONSTRAINT [DF_DEBTRECONDEF_TAXRET]  DEFAULT ('1') FOR [TAXRET]
ALTER TABLE [dbo].[DEBTRECONDEF] ADD  CONSTRAINT [DF_DEBTRECONDEF_TAXWHT]  DEFAULT ('1') FOR [TAXWHT]
ALTER TABLE [dbo].[DEBTRECONDEF] ADD  CONSTRAINT [DF_DEBTRECONDEF_TAXCONTRA]  DEFAULT ('1') FOR [TAXCONTRA]
ALTER TABLE [dbo].[DEBTRECONDEF] ADD  CONSTRAINT [DF_DEBTRECONDEF_WHTTP]  DEFAULT ('T') FOR [WHTTP]
ALTER TABLE [dbo].[DEBTRECONDEF] ADD  CONSTRAINT [DF_DEBTRECONDEF_WHTDD]  DEFAULT ('1') FOR [WHTDD]
ALTER TABLE [dbo].[DEBTRECONDEF] ADD  CONSTRAINT [DF_DEBTRECONDEF_WHTSIGN]  DEFAULT ('-1') FOR [WHTSIGN]
ALTER TABLE [dbo].[DEBTRECONDEF] ADD  CONSTRAINT [DF_DEBTRECONDEF_WHTID]  DEFAULT ('-1') FOR [WHTID]
ALTER TABLE [dbo].[DEBTRECONDEF] ADD  CONSTRAINT [DF_DEBTRECONDEF_WHTADV]  DEFAULT ('1') FOR [WHTADV]
ALTER TABLE [dbo].[DEBTRECONDEF] ADD  CONSTRAINT [DF_DEBTRECONDEF_WHTADJ]  DEFAULT ('1') FOR [WHTADJ]
ALTER TABLE [dbo].[DEBTRECONDEF] ADD  CONSTRAINT [DF_DEBTRECONDEF_WHTVAT]  DEFAULT ('1') FOR [WHTVAT]
ALTER TABLE [dbo].[DEBTRECONDEF] ADD  CONSTRAINT [DF_DEBTRECONDEF_WHTCONTRA]  DEFAULT ('1') FOR [WHTCONTRA]
ALTER TABLE [dbo].[DEBTRECONDEF] ADD  CONSTRAINT [DF_DEBTRECONDEF_CONTRATP]  DEFAULT ('T') FOR [CONTRATP]
ALTER TABLE [dbo].[DEBTRECONDEF] ADD  CONSTRAINT [DF_DEBTRECONDEF_CONTRATAB]  DEFAULT ('1') FOR [CONTRATAB]
ALTER TABLE [dbo].[DEBTRECONDEF] ADD  CONSTRAINT [DF_DEBTRECONDEF_CONTRALEDGER]  DEFAULT ('') FOR [CONTRALEDGER]
ALTER TABLE [dbo].[DEBTRECONDEF] ADD  CONSTRAINT [DF_DEBTRECONDEF_LAYOUT]  DEFAULT ('1') FOR [LAYOUT]
ALTER TABLE [dbo].[DEBTRECONDEF] ADD  CONSTRAINT [DF_DEBTRECONDEF_TRANSREFCOL]  DEFAULT (N'CERTNO') FOR [TRANSREFCOL]
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE TRIGGER LOGMASTERDEBTRECONDEF ON DEBTRECONDEF
AFTER UPDATE, DELETE, INSERT
AS 

SET NOCOUNT ON

declare @tableName varChar(25)
declare @primaryKey varChar(25)
declare @ignoreList varChar(500)

set @tableName = 'DEBTRECONDEF'
set @primaryKey = 'ID'
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

		
ALTER TABLE [dbo].[DEBTRECONDEF] ENABLE TRIGGER [LOGMASTERDEBTRECONDEF]