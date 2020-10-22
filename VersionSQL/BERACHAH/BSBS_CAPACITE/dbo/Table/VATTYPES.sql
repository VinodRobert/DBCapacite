/****** Object:  Table [dbo].[VATTYPES]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[VATTYPES](
	[VATID] [char](2) NOT NULL,
	[VATNAME] [nvarchar](50) NULL,
	[VATPERC] [numeric](18, 4) NOT NULL,
	[VATIN] [bit] NOT NULL,
	[TOJOINV] [int] NOT NULL,
	[BORGID] [int] NOT NULL,
	[POC] [char](10) NOT NULL,
	[ISREIMB] [bit] NOT NULL,
	[VATGC] [nvarchar](3) NOT NULL,
	[STATUS] [int] NOT NULL,
	[NCPERC] [nvarchar](50) NULL,
	[IVA1] [nvarchar](10) NOT NULL,
	[IVA2] [nvarchar](10) NOT NULL,
	[IVA3] [nvarchar](10) NOT NULL,
	[POSDEF] [bit] NOT NULL,
	[USERCM] [bit] NOT NULL,
	[RCMLEDGERCODE] [nvarchar](10) NOT NULL,
	[DEFLEDGERCODE] [nvarchar](10) NOT NULL,
 CONSTRAINT [PK_VATTYPES_2] PRIMARY KEY CLUSTERED 
(
	[VATID] ASC,
	[BORGID] ASC,
	[VATGC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[VATTYPES] ADD  CONSTRAINT [DF_VATTYPES_TOJOINV]  DEFAULT ((3)) FOR [TOJOINV]
ALTER TABLE [dbo].[VATTYPES] ADD  CONSTRAINT [DF_VATTYPES_BORGID]  DEFAULT ((-1)) FOR [BORGID]
ALTER TABLE [dbo].[VATTYPES] ADD  CONSTRAINT [DF__VATTYPES__POC__2EDBC1A8]  DEFAULT ('') FOR [POC]
ALTER TABLE [dbo].[VATTYPES] ADD  CONSTRAINT [DF_VATTYPES_ISREIMB]  DEFAULT ((1)) FOR [ISREIMB]
ALTER TABLE [dbo].[VATTYPES] ADD  CONSTRAINT [DF_VATTYPES_VATGC]  DEFAULT ('') FOR [VATGC]
ALTER TABLE [dbo].[VATTYPES] ADD  CONSTRAINT [DF_VATTYPES_STATUS]  DEFAULT ((0)) FOR [STATUS]
ALTER TABLE [dbo].[VATTYPES] ADD  CONSTRAINT [DF_VATTYPES_IVA1]  DEFAULT ('') FOR [IVA1]
ALTER TABLE [dbo].[VATTYPES] ADD  CONSTRAINT [DF_VATTYPES_IVA2]  DEFAULT ('') FOR [IVA2]
ALTER TABLE [dbo].[VATTYPES] ADD  CONSTRAINT [DF_VATTYPES_IVA3]  DEFAULT ('') FOR [IVA3]
ALTER TABLE [dbo].[VATTYPES] ADD  CONSTRAINT [DF_VATTYPES_POSDEF]  DEFAULT ('0') FOR [POSDEF]
ALTER TABLE [dbo].[VATTYPES] ADD  CONSTRAINT [DF_VATTYPES_USERCM]  DEFAULT (N'0') FOR [USERCM]
ALTER TABLE [dbo].[VATTYPES] ADD  CONSTRAINT [DF_VATTYPES_RCMLEDGERCODE]  DEFAULT ('') FOR [RCMLEDGERCODE]
ALTER TABLE [dbo].[VATTYPES] ADD  CONSTRAINT [DF_VATTYPES_DEFLEDGERCODE]  DEFAULT ('') FOR [DEFLEDGERCODE]
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE TRIGGER LOGMASTERVATTYPES ON VATTYPES
AFTER UPDATE, DELETE, INSERT
AS 

SET NOCOUNT ON

declare @tableName varChar(25)
declare @primaryKey varChar(25)
declare @ignoreList varChar(500)

set @tableName = 'VATTYPES'
set @primaryKey = 'BORGID,VATGC,VATID'
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

	set @sql = 'select ''' + cast(@logUserID as varChar(10)) + ''', ''' + cast(@borgid as varChar(10)) + ''', ''' + @application + ''', ''' + @tableName + ''', ''' + @action + ''', ''' + @page + ''', ''' + @info + ''', ''' + @version + ''', ''BORGID = '' + cast(i.BORGID as varChar(10)) + '' AND VATID = ''  + cast(i.VATID as varChar(10)) + '' AND VATGC = ''  + cast(i.VATGC as varChar(10)), Substring(' + @sqlTblCols + ', 1 , len(' + @sqlTblCols + ') - 1) '
	set @sql = @sql + 'From #inserted i inner join #deleted d on i.BORGID = d.BORGID and i.VATID = d.VATID and i.VATGC = d.VATGC where isnull(' + @sqlTblCols + ', '''') <> '''' ' 

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
	
	set @sql = 'select ''' + cast(@logUserID as varChar(10)) + ''', ''' + cast(@borgid as varChar(10)) + ''', ''' + @application + ''', ''' + @tableName + ''', ''' + @action + ''', ''' + @page + ''', ''' + @info + ''', ''' + @version + ''', ''BORGID = '' + cast(d.BORGID as varChar(10)) + '' AND VATID = ''  + cast(d.VATID as varChar(10)) + '' AND VATGC = ''  + cast(d.VATGC as varChar(10)), ' + @sqlTblCols + ' '
	set @sql = @sql + 'From '+ case when @action = 'DELETE' then '#deleted' else '#inserted' end +' d ' 
 
	insert into LOGMASTER (USERID, BORGID, APPLICATION, TABLENAME, ACTION, PAGE, INFO, VERSION, PRIMARYKEY, DETAILS)
	exec sp_executesql @sql
END

DROP TABLE #inserted
DROP TABLE #deleted

		
ALTER TABLE [dbo].[VATTYPES] ENABLE TRIGGER [LOGMASTERVATTYPES]