/****** Object:  Table [dbo].[SUBCRECONRULES]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[SUBCRECONRULES](
	[TEMPLATEID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ACCSPEC] [int] NOT NULL,
	[SEQUENCE] [int] NOT NULL,
	[VARCODE] [nvarchar](20) NOT NULL,
	[PRINTDESC] [nvarchar](50) NOT NULL,
	[EDITDESC] [nvarchar](50) NOT NULL,
	[POSTDESC] [nvarchar](50) NOT NULL,
	[SUBCONTRAN] [nvarchar](50) NOT NULL,
	[PPRINTMASK] [nvarchar](20) NOT NULL,
	[MPRINTMASK] [nvarchar](20) NOT NULL,
	[VPRINTMASK] [nvarchar](20) NOT NULL,
	[PEDITMASK] [nvarchar](20) NOT NULL,
	[MEDITMASK] [nvarchar](20) NOT NULL,
	[VEDITMASK] [nvarchar](20) NOT NULL,
	[ISPRINT] [int] NOT NULL,
	[ISEDIT] [int] NOT NULL,
	[ISPOST] [int] NOT NULL,
	[ISLINE] [int] NOT NULL,
	[ISBREAK] [int] NOT NULL,
	[OVERRIDEALLOC] [nvarchar](1) NOT NULL,
	[DEFAULTALLOC] [nvarchar](10) NOT NULL,
	[CONTROLCODE] [nvarchar](50) NOT NULL,
	[LINK] [nvarchar](50) NOT NULL,
	[LINKCODE] [nvarchar](50) NOT NULL,
	[PFORMULA] [nvarchar](250) NOT NULL,
	[MFORMULA] [nvarchar](250) NOT NULL,
	[VFORMULA] [nvarchar](250) NOT NULL,
	[PERCPRINTMASK] [nvarchar](20) NOT NULL,
	[PERCEDITMASK] [nvarchar](20) NOT NULL,
	[TAXFORMULA] [nvarchar](250) NOT NULL,
	[PERCFORMULA] [nvarchar](250) NOT NULL,
	[ALTCCODE] [nvarchar](50) NOT NULL,
	[TAXCODELINK] [nvarchar](50) NOT NULL,
	[WHTIDLINK] [nvarchar](50) NOT NULL,
	[WHTTHISPLINK] [nvarchar](250) NOT NULL,
	[CODE] [nvarchar](10) NOT NULL,
	[MAPPING] [nvarchar](100) NOT NULL,
	[ACTION] [int] NOT NULL,
 CONSTRAINT [PK_SUBCRECONRULES] PRIMARY KEY CLUSTERED 
(
	[TEMPLATEID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[SUBCRECONRULES] ADD  CONSTRAINT [DF_SUBCRECONRULES_ACCSPEC]  DEFAULT ('') FOR [ACCSPEC]
ALTER TABLE [dbo].[SUBCRECONRULES] ADD  CONSTRAINT [DF_SUBCRECONRULES_SEQUENCE]  DEFAULT ('0') FOR [SEQUENCE]
ALTER TABLE [dbo].[SUBCRECONRULES] ADD  CONSTRAINT [DF_SUBCRECONRULES_VARCODE]  DEFAULT ('') FOR [VARCODE]
ALTER TABLE [dbo].[SUBCRECONRULES] ADD  CONSTRAINT [DF_SUBCRECONRULES_PRINTDESC]  DEFAULT ('') FOR [PRINTDESC]
ALTER TABLE [dbo].[SUBCRECONRULES] ADD  CONSTRAINT [DF_SUBCRECONRULES_EDITDESC]  DEFAULT ('') FOR [EDITDESC]
ALTER TABLE [dbo].[SUBCRECONRULES] ADD  CONSTRAINT [DF_SUBCRECONRULES_POSTDESC]  DEFAULT ('') FOR [POSTDESC]
ALTER TABLE [dbo].[SUBCRECONRULES] ADD  CONSTRAINT [DF_SUBCRECONRULES_SUBCONTRAN]  DEFAULT ('') FOR [SUBCONTRAN]
ALTER TABLE [dbo].[SUBCRECONRULES] ADD  CONSTRAINT [DF_SUBCRECONRULES_PPRINTMASK]  DEFAULT ('B') FOR [PPRINTMASK]
ALTER TABLE [dbo].[SUBCRECONRULES] ADD  CONSTRAINT [DF_SUBCRECONRULES_MPRINTMASK]  DEFAULT ('B') FOR [MPRINTMASK]
ALTER TABLE [dbo].[SUBCRECONRULES] ADD  CONSTRAINT [DF_SUBCRECONRULES_VPRINTMASK]  DEFAULT ('B') FOR [VPRINTMASK]
ALTER TABLE [dbo].[SUBCRECONRULES] ADD  CONSTRAINT [DF_SUBCRECONRULES_PEDITMASK]  DEFAULT ('B') FOR [PEDITMASK]
ALTER TABLE [dbo].[SUBCRECONRULES] ADD  CONSTRAINT [DF_SUBCRECONRULES_MEDITMASK]  DEFAULT ('B') FOR [MEDITMASK]
ALTER TABLE [dbo].[SUBCRECONRULES] ADD  CONSTRAINT [DF_SUBCRECONRULES_VEDITMASK]  DEFAULT ('B') FOR [VEDITMASK]
ALTER TABLE [dbo].[SUBCRECONRULES] ADD  CONSTRAINT [DF_SUBCRECONRULES_ISPRINT]  DEFAULT ('0') FOR [ISPRINT]
ALTER TABLE [dbo].[SUBCRECONRULES] ADD  CONSTRAINT [DF_SUBCRECONRULES_ISEDIT]  DEFAULT ('0') FOR [ISEDIT]
ALTER TABLE [dbo].[SUBCRECONRULES] ADD  CONSTRAINT [DF_SUBCRECONRULES_ISPOST]  DEFAULT ('0') FOR [ISPOST]
ALTER TABLE [dbo].[SUBCRECONRULES] ADD  CONSTRAINT [DF_SUBCRECONRULES_ISLINE]  DEFAULT ('0') FOR [ISLINE]
ALTER TABLE [dbo].[SUBCRECONRULES] ADD  CONSTRAINT [DF_SUBCRECONRULES_ISBREAK]  DEFAULT ('0') FOR [ISBREAK]
ALTER TABLE [dbo].[SUBCRECONRULES] ADD  CONSTRAINT [DF_SUBCRECONRULES_OVERRIDEALLOC]  DEFAULT ('') FOR [OVERRIDEALLOC]
ALTER TABLE [dbo].[SUBCRECONRULES] ADD  CONSTRAINT [DF_SUBCRECONRULES_DEFAULTALLOC]  DEFAULT ('') FOR [DEFAULTALLOC]
ALTER TABLE [dbo].[SUBCRECONRULES] ADD  CONSTRAINT [DF_SUBCRECONRULES_CONTROLCODE]  DEFAULT ('') FOR [CONTROLCODE]
ALTER TABLE [dbo].[SUBCRECONRULES] ADD  CONSTRAINT [DF_SUBCRECONRULES_LINK]  DEFAULT ('') FOR [LINK]
ALTER TABLE [dbo].[SUBCRECONRULES] ADD  CONSTRAINT [DF_SUBCRECONRULES_LINKCODE]  DEFAULT ('') FOR [LINKCODE]
ALTER TABLE [dbo].[SUBCRECONRULES] ADD  CONSTRAINT [DF_SUBCRECONRULES_PFORMULA]  DEFAULT ('') FOR [PFORMULA]
ALTER TABLE [dbo].[SUBCRECONRULES] ADD  CONSTRAINT [DF_SUBCRECONRULES_MFORMULA]  DEFAULT ('') FOR [MFORMULA]
ALTER TABLE [dbo].[SUBCRECONRULES] ADD  CONSTRAINT [DF_SUBCRECONRULES_VFORMULA]  DEFAULT ('') FOR [VFORMULA]
ALTER TABLE [dbo].[SUBCRECONRULES] ADD  CONSTRAINT [DF_SUBCRECONRULES_PERCPRINTMASK]  DEFAULT ('') FOR [PERCPRINTMASK]
ALTER TABLE [dbo].[SUBCRECONRULES] ADD  CONSTRAINT [DF_SUBCRECONRULES_PERCEDITMASK]  DEFAULT ('') FOR [PERCEDITMASK]
ALTER TABLE [dbo].[SUBCRECONRULES] ADD  CONSTRAINT [DF_SUBCRECONRULES_TAXFORMULA]  DEFAULT ('') FOR [TAXFORMULA]
ALTER TABLE [dbo].[SUBCRECONRULES] ADD  CONSTRAINT [DF_SUBCRECONRULES_PERCFORMULA]  DEFAULT ('') FOR [PERCFORMULA]
ALTER TABLE [dbo].[SUBCRECONRULES] ADD  CONSTRAINT [DF_SUBCRECONRULES_ALTCCODE]  DEFAULT ('') FOR [ALTCCODE]
ALTER TABLE [dbo].[SUBCRECONRULES] ADD  CONSTRAINT [DF_SUBCRECONRULES_TAXCODELINK]  DEFAULT ('') FOR [TAXCODELINK]
ALTER TABLE [dbo].[SUBCRECONRULES] ADD  CONSTRAINT [DF_SUBCRECONRULES_WHTIDLINK]  DEFAULT ('') FOR [WHTIDLINK]
ALTER TABLE [dbo].[SUBCRECONRULES] ADD  CONSTRAINT [DF_SUBCRECONRULES_WHTTHISPLINK]  DEFAULT ('') FOR [WHTTHISPLINK]
ALTER TABLE [dbo].[SUBCRECONRULES] ADD  CONSTRAINT [DF_SUBCRECONRULES_CODE]  DEFAULT ('') FOR [CODE]
ALTER TABLE [dbo].[SUBCRECONRULES] ADD  CONSTRAINT [DF_SUBCRECONRULES_MAPPING]  DEFAULT ('') FOR [MAPPING]
ALTER TABLE [dbo].[SUBCRECONRULES] ADD  CONSTRAINT [DF_SUBCRECONRULES_ACTION]  DEFAULT ('0') FOR [ACTION]
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE TRIGGER LOGMASTERSUBCRECONRULES ON SUBCRECONRULES
AFTER UPDATE, DELETE, INSERT
AS 

SET NOCOUNT ON

declare @tableName varChar(25)
declare @primaryKey varChar(25)
declare @ignoreList varChar(500)

set @tableName = 'SUBCRECONRULES'
set @primaryKey = 'TEMPLATEID'
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

		
ALTER TABLE [dbo].[SUBCRECONRULES] ENABLE TRIGGER [LOGMASTERSUBCRECONRULES]