/****** Object:  Table [dbo].[USERSINBORGP]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[USERSINBORGP](
	[USERID] [int] NOT NULL,
	[BORGID] [int] NOT NULL,
	[SPENDINGLIMIT] [money] NOT NULL,
	[BILLTOID] [int] NOT NULL,
	[SHIPTOID] [int] NOT NULL,
	[SPENDLIMITAPPROVER] [int] NOT NULL,
	[APPROVALLIMIT] [money] NOT NULL,
	[ROLEID] [int] NOT NULL,
	[CANOVERDLVR] [bit] NOT NULL,
	[EXTPO] [bit] NOT NULL,
	[CANNEGDLVR] [bit] NOT NULL,
	[USESELAPPROVER] [int] NOT NULL,
	[OUTOFOFFICE] [bit] NOT NULL,
	[TAKEOWNERSHIP] [bit] NOT NULL,
	[LIMITSELAPPROVERS] [bit] NOT NULL,
	[BLOCKNEGDLVRRECON] [bit] NOT NULL,
	[ID] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_USERSINBORGP] PRIMARY KEY NONCLUSTERED 
(
	[USERID] ASC,
	[BORGID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[USERSINBORGP] ADD  CONSTRAINT [DF_USERSINBORGP_SPENDINGLIMIT]  DEFAULT ((0)) FOR [SPENDINGLIMIT]
ALTER TABLE [dbo].[USERSINBORGP] ADD  CONSTRAINT [DF_USERSINBORGP_BILLTOID]  DEFAULT ((-1)) FOR [BILLTOID]
ALTER TABLE [dbo].[USERSINBORGP] ADD  CONSTRAINT [DF_USERSINBORGP_SHIPTOID]  DEFAULT ((-1)) FOR [SHIPTOID]
ALTER TABLE [dbo].[USERSINBORGP] ADD  CONSTRAINT [DF_USERSINBORGP_SPENDLIMITAPPROVER]  DEFAULT ((-1)) FOR [SPENDLIMITAPPROVER]
ALTER TABLE [dbo].[USERSINBORGP] ADD  CONSTRAINT [DF_USERSINBORGP_APPROVALLIMIT]  DEFAULT ((0)) FOR [APPROVALLIMIT]
ALTER TABLE [dbo].[USERSINBORGP] ADD  CONSTRAINT [DF_USERSINBORGP_ROLEID]  DEFAULT ((-1)) FOR [ROLEID]
ALTER TABLE [dbo].[USERSINBORGP] ADD  CONSTRAINT [DF_USERSINBORGP_CANOVERDLVR]  DEFAULT ((1)) FOR [CANOVERDLVR]
ALTER TABLE [dbo].[USERSINBORGP] ADD  CONSTRAINT [DF_USERSINBORGP_EXTPO]  DEFAULT ((0)) FOR [EXTPO]
ALTER TABLE [dbo].[USERSINBORGP] ADD  CONSTRAINT [DF_USERSINBORGP_CANNEGDLVR]  DEFAULT ((1)) FOR [CANNEGDLVR]
ALTER TABLE [dbo].[USERSINBORGP] ADD  CONSTRAINT [DF_USERSINBORGP_USESELAPPROVER]  DEFAULT ((-1)) FOR [USESELAPPROVER]
ALTER TABLE [dbo].[USERSINBORGP] ADD  CONSTRAINT [DF_USERSINBORGP_OUTOFOFFICE]  DEFAULT ('0') FOR [OUTOFOFFICE]
ALTER TABLE [dbo].[USERSINBORGP] ADD  CONSTRAINT [DF_USERSINBORGP_TAKEOWNERSHIP]  DEFAULT ('0') FOR [TAKEOWNERSHIP]
ALTER TABLE [dbo].[USERSINBORGP] ADD  CONSTRAINT [DF_USERSINBORGP_LIMITSELAPPROVERS]  DEFAULT ('0') FOR [LIMITSELAPPROVERS]
ALTER TABLE [dbo].[USERSINBORGP] ADD  CONSTRAINT [DF_USERSINBORGP_BLOCKNEGDLVRRECON]  DEFAULT ('0') FOR [BLOCKNEGDLVRRECON]
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE TRIGGER LOGMASTERUSERSINBORGP ON USERSINBORGP
AFTER UPDATE, DELETE, INSERT
AS 

SET NOCOUNT ON

declare @tableName varChar(25)
declare @primaryKey varChar(25)
declare @ignoreList varChar(500)

set @tableName = 'USERSINBORGP'
set @primaryKey = 'BORGID,USERID'
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

	set @sql = 'select ''' + cast(@logUserID as varChar(10)) + ''', ''' + cast(@borgid as varChar(10)) + ''', ''' + @application + ''', ''' + @tableName + ''', ''' + @action + ''', ''' + @page + ''', ''' + @info + ''', ''' + @version + ''', ''BORGID = '' + cast(i.BORGID as varChar(10)) + '' AND USERID = ''  + cast(i.USERID as varChar(10)), Substring(' + @sqlTblCols + ', 1 , len(' + @sqlTblCols + ') - 1) '
	set @sql = @sql + 'From #inserted i inner join #deleted d on i.BORGID = d.BORGID and i.USERID = d.USERID where isnull(' + @sqlTblCols + ', '''') <> '''' ' 

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
	
	set @sql = 'select ''' + cast(@logUserID as varChar(10)) + ''', ''' + cast(@borgid as varChar(10)) + ''', ''' + @application + ''', ''' + @tableName + ''', ''' + @action + ''', ''' + @page + ''', ''' + @info + ''', ''' + @version + ''', ''BORGID = '' + cast(d.BORGID as varChar(10)) + '' AND USERID = ''  + cast(d.USERID as varChar(10)), ' + @sqlTblCols + ' '
	set @sql = @sql + 'From '+ case when @action = 'DELETE' then '#deleted' else '#inserted' end +' d ' 
 
	insert into LOGMASTER (USERID, BORGID, APPLICATION, TABLENAME, ACTION, PAGE, INFO, VERSION, PRIMARYKEY, DETAILS)
	exec sp_executesql @sql
END

DROP TABLE #inserted
DROP TABLE #deleted

		
ALTER TABLE [dbo].[USERSINBORGP] ENABLE TRIGGER [LOGMASTERUSERSINBORGP]