/****** Object:  Table [dbo].[WORKFLOWDETAIL]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[WORKFLOWDETAIL](
	[WDID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[WHID] [int] NOT NULL,
	[DESCR] [nvarchar](250) NOT NULL,
	[USERID] [int] NOT NULL,
	[USERID2] [int] NOT NULL,
	[ROLEID] [int] NOT NULL,
	[LINELIMIT] [decimal](18, 4) NOT NULL,
	[APPROVALLIMIT] [decimal](18, 4) NOT NULL,
	[SEQ] [int] NOT NULL,
	[SKIPCONDITION] [nvarchar](250) NOT NULL,
	[JUMPSEQ] [int] NOT NULL,
	[DOBRANCH] [bit] NOT NULL,
	[CONFIRMMESSAGE] [nvarchar](max) NOT NULL,
	[EMAILTO] [nvarchar](max) NOT NULL,
	[EMAILHEADER] [nvarchar](max) NOT NULL,
	[EMAILDETAIL] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_WORKFLOWDETAIL] PRIMARY KEY CLUSTERED 
(
	[WDID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[WORKFLOWDETAIL] ADD  CONSTRAINT [DF_WORKFLOWDETAIL_WHID]  DEFAULT ((-1)) FOR [WHID]
ALTER TABLE [dbo].[WORKFLOWDETAIL] ADD  CONSTRAINT [DF_WORKFLOWDETAIL_DESCR]  DEFAULT ('') FOR [DESCR]
ALTER TABLE [dbo].[WORKFLOWDETAIL] ADD  CONSTRAINT [DF_WORKFLOWDETAIL_USERID]  DEFAULT ((-1)) FOR [USERID]
ALTER TABLE [dbo].[WORKFLOWDETAIL] ADD  CONSTRAINT [DF_WORKFLOWDETAIL_USERID2]  DEFAULT ((-1)) FOR [USERID2]
ALTER TABLE [dbo].[WORKFLOWDETAIL] ADD  CONSTRAINT [DF_WORKFLOWDETAIL_ROLEID]  DEFAULT ((-1)) FOR [ROLEID]
ALTER TABLE [dbo].[WORKFLOWDETAIL] ADD  CONSTRAINT [DF_WORKFLOWDETAIL_LINELIMIT]  DEFAULT ((-1)) FOR [LINELIMIT]
ALTER TABLE [dbo].[WORKFLOWDETAIL] ADD  CONSTRAINT [DF_WORKFLOWDETAIL_APPROVALLIMIT]  DEFAULT ((-1)) FOR [APPROVALLIMIT]
ALTER TABLE [dbo].[WORKFLOWDETAIL] ADD  CONSTRAINT [DF_WORKFLOWDETAIL_SEQ]  DEFAULT ((-1)) FOR [SEQ]
ALTER TABLE [dbo].[WORKFLOWDETAIL] ADD  CONSTRAINT [DF_WORKFLOWDETAIL_SKIPCONDITION]  DEFAULT ('') FOR [SKIPCONDITION]
ALTER TABLE [dbo].[WORKFLOWDETAIL] ADD  CONSTRAINT [DF_WORKFLOWDETAIL_JUMPSEQ]  DEFAULT ((-1)) FOR [JUMPSEQ]
ALTER TABLE [dbo].[WORKFLOWDETAIL] ADD  CONSTRAINT [DF_WORKFLOWDETAIL_DOBRANCH]  DEFAULT (N'0') FOR [DOBRANCH]
ALTER TABLE [dbo].[WORKFLOWDETAIL] ADD  CONSTRAINT [DF_WORKFLOWDETAIL_CONFIRMMESSAGE]  DEFAULT ('') FOR [CONFIRMMESSAGE]
ALTER TABLE [dbo].[WORKFLOWDETAIL] ADD  CONSTRAINT [DF_WORKFLOWDETAIL_EMAILTO]  DEFAULT ('') FOR [EMAILTO]
ALTER TABLE [dbo].[WORKFLOWDETAIL] ADD  CONSTRAINT [DF_WORKFLOWDETAIL_EMAILHEADER]  DEFAULT ('') FOR [EMAILHEADER]
ALTER TABLE [dbo].[WORKFLOWDETAIL] ADD  CONSTRAINT [DF_WORKFLOWDETAIL_EMAILDETAIL]  DEFAULT ('') FOR [EMAILDETAIL]
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE TRIGGER LOGMASTERWORKFLOWDETAIL ON WORKFLOWDETAIL
AFTER UPDATE, DELETE, INSERT
AS 

SET NOCOUNT ON

declare @tableName varChar(25)
declare @primaryKey varChar(25)
declare @ignoreList varChar(500)

set @tableName = 'WORKFLOWDETAIL'
set @primaryKey = 'WDID'
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

		
ALTER TABLE [dbo].[WORKFLOWDETAIL] ENABLE TRIGGER [LOGMASTERWORKFLOWDETAIL]