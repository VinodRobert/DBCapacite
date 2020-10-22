/****** Object:  Table [dbo].[STOCKTYPES]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[STOCKTYPES](
	[TypeName] [char](10) NULL,
	[IsDebit] [bit] NOT NULL,
	[TypeOppGlCode] [char](10) NULL,
	[TypeOppCost] [char](25) NULL,
	[TypeOppDesc] [char](25) NULL,
	[TypeVAT] [char](2) NULL,
	[TypeJnl] [bit] NOT NULL,
	[TypeDesc] [char](55) NULL,
	[Isplant] [bit] NOT NULL,
	[Isnom] [bit] NOT NULL,
	[Iscred] [bit] NOT NULL,
	[Isdebt] [bit] NOT NULL,
	[Isstock] [bit] NOT NULL,
	[IsSub] [bit] NOT NULL,
	[IsContract] [bit] NOT NULL,
	[ToJoinT] [int] NOT NULL,
	[TypeDefGl] [char](10) NULL,
	[TypeDefAlloc] [char](25) NULL,
	[TypeGLAlloc] [char](25) NULL,
	[TypeGLCode] [char](10) NULL,
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[TTYPE] [nvarchar](10) NOT NULL,
 CONSTRAINT [PK_STOCKTYPES] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[STOCKTYPES] ADD  CONSTRAINT [DF_STOCKTYPES_IsDebit]  DEFAULT (0) FOR [IsDebit]
ALTER TABLE [dbo].[STOCKTYPES] ADD  CONSTRAINT [DF_STOCKTYPES_TypeJnl]  DEFAULT (0) FOR [TypeJnl]
ALTER TABLE [dbo].[STOCKTYPES] ADD  CONSTRAINT [DF_STOCKTYPES_Isplant]  DEFAULT (0) FOR [Isplant]
ALTER TABLE [dbo].[STOCKTYPES] ADD  CONSTRAINT [DF_STOCKTYPES_Isnom]  DEFAULT (0) FOR [Isnom]
ALTER TABLE [dbo].[STOCKTYPES] ADD  CONSTRAINT [DF_STOCKTYPES_Iscred]  DEFAULT (0) FOR [Iscred]
ALTER TABLE [dbo].[STOCKTYPES] ADD  CONSTRAINT [DF_STOCKTYPES_Isdebt]  DEFAULT (0) FOR [Isdebt]
ALTER TABLE [dbo].[STOCKTYPES] ADD  CONSTRAINT [DF_STOCKTYPES_Isstock]  DEFAULT (0) FOR [Isstock]
ALTER TABLE [dbo].[STOCKTYPES] ADD  CONSTRAINT [DF_STOCKTYPES_IsSub]  DEFAULT (0) FOR [IsSub]
ALTER TABLE [dbo].[STOCKTYPES] ADD  CONSTRAINT [DF_STOCKTYPES_IsContract]  DEFAULT (0) FOR [IsContract]
ALTER TABLE [dbo].[STOCKTYPES] ADD  CONSTRAINT [DF_STOCKTYPES_ToJoinT]  DEFAULT (13) FOR [ToJoinT]
ALTER TABLE [dbo].[STOCKTYPES] ADD  CONSTRAINT [DF_STOCKTYPES_TTYPE]  DEFAULT ('') FOR [TTYPE]
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE TRIGGER LOGMASTERSTOCKTYPES ON STOCKTYPES
AFTER UPDATE, DELETE, INSERT
AS 

SET NOCOUNT ON

declare @tableName varChar(25)
declare @primaryKey varChar(25)
declare @ignoreList varChar(500)

set @tableName = 'STOCKTYPES'
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

		
ALTER TABLE [dbo].[STOCKTYPES] ENABLE TRIGGER [LOGMASTERSTOCKTYPES]