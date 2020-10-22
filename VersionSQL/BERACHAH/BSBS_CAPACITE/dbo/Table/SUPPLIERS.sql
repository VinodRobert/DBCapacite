/****** Object:  Table [dbo].[SUPPLIERS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[SUPPLIERS](
	[SUPPID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SUPPNAME] [nvarchar](127) NOT NULL,
	[ADDRID] [int] NOT NULL,
	[SUPPTYPE] [int] NOT NULL,
	[DESCRIPTION] [ntext] NOT NULL,
	[CONTACTID] [int] NOT NULL,
	[SHIPMETHOD] [char](55) NOT NULL,
	[REGNO] [nvarchar](25) NULL,
	[TAXTYPEID] [int] NULL,
	[SUPPCODE] [nchar](10) NOT NULL,
	[MSID] [nvarchar](35) NOT NULL,
	[DEFAULTSHIPMETHODID] [int] NOT NULL,
	[MPID] [nvarchar](36) NOT NULL,
	[TPSHORTNAME] [nvarchar](25) NOT NULL,
	[TPNAME] [nvarchar](50) NOT NULL,
	[PROVINCEID] [int] NOT NULL,
	[SUPPDBID] [int] NOT NULL,
	[EID] [char](10) NOT NULL,
	[SUPPDBEID] [char](10) NOT NULL,
	[ISORATING] [int] NOT NULL,
	[BEERating] [int] NOT NULL,
	[BUSREG] [nvarchar](25) NOT NULL,
	[SUPPSTATUS] [int] NOT NULL,
	[TAXCLASSIFICATION] [nvarchar](100) NOT NULL,
	[TAXCERTEXPIRY] [datetime] NULL,
	[COUNTRY] [nvarchar](55) NOT NULL,
 CONSTRAINT [PK_SUPPLIERS] PRIMARY KEY CLUSTERED 
(
	[SUPPID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [IX_SUPPLIERS] UNIQUE NONCLUSTERED 
(
	[SUPPCODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_SUPPLIERS_SUPPCODE_SUPPID] ON [dbo].[SUPPLIERS]
(
	[SUPPCODE] ASC,
	[SUPPID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
ALTER TABLE [dbo].[SUPPLIERS] ADD  CONSTRAINT [DF_SUPPLIERS_SUPPNAME]  DEFAULT ('') FOR [SUPPNAME]
ALTER TABLE [dbo].[SUPPLIERS] ADD  CONSTRAINT [DF_SUPPLIERS_SUPPTYPE]  DEFAULT ('') FOR [SUPPTYPE]
ALTER TABLE [dbo].[SUPPLIERS] ADD  CONSTRAINT [DF_SUPPLIERS_REGNO]  DEFAULT ('') FOR [REGNO]
ALTER TABLE [dbo].[SUPPLIERS] ADD  CONSTRAINT [DF_SUPPLIERS_TAXTYPEID]  DEFAULT (0) FOR [TAXTYPEID]
ALTER TABLE [dbo].[SUPPLIERS] ADD  CONSTRAINT [DF_SUPPLIERS_SUPPCODE]  DEFAULT ('') FOR [SUPPCODE]
ALTER TABLE [dbo].[SUPPLIERS] ADD  CONSTRAINT [DF_SUPPLIERS_MSID]  DEFAULT ('') FOR [MSID]
ALTER TABLE [dbo].[SUPPLIERS] ADD  CONSTRAINT [DF_SUPPLIERS_DEFAULTSHIPMETHODID]  DEFAULT ((-1)) FOR [DEFAULTSHIPMETHODID]
ALTER TABLE [dbo].[SUPPLIERS] ADD  CONSTRAINT [DF_SUPPLIERS_MPID]  DEFAULT ('') FOR [MPID]
ALTER TABLE [dbo].[SUPPLIERS] ADD  CONSTRAINT [DF_SUPPLIERS_TPSHORTNAME]  DEFAULT ('') FOR [TPSHORTNAME]
ALTER TABLE [dbo].[SUPPLIERS] ADD  CONSTRAINT [DF_SUPPLIERS_TPNAME]  DEFAULT ('') FOR [TPNAME]
ALTER TABLE [dbo].[SUPPLIERS] ADD  CONSTRAINT [DF_SUPPLIERS_PROVINCEID]  DEFAULT (0) FOR [PROVINCEID]
ALTER TABLE [dbo].[SUPPLIERS] ADD  CONSTRAINT [DF_SUPPLIERS_SUPPDBID]  DEFAULT ((-1)) FOR [SUPPDBID]
ALTER TABLE [dbo].[SUPPLIERS] ADD  CONSTRAINT [DF_SUPPLIERS_EID]  DEFAULT ('') FOR [EID]
ALTER TABLE [dbo].[SUPPLIERS] ADD  DEFAULT ('') FOR [SUPPDBEID]
ALTER TABLE [dbo].[SUPPLIERS] ADD  CONSTRAINT [DF_SUPPLIERS_ISORATING]  DEFAULT ((0)) FOR [ISORATING]
ALTER TABLE [dbo].[SUPPLIERS] ADD  CONSTRAINT [DF_SUPPLIERS_BEERating]  DEFAULT ((0)) FOR [BEERating]
ALTER TABLE [dbo].[SUPPLIERS] ADD  CONSTRAINT [DF_SUPPLIERS_BUSREG]  DEFAULT ('') FOR [BUSREG]
ALTER TABLE [dbo].[SUPPLIERS] ADD  CONSTRAINT [DF_SUPPLIERS_SUPPSTATUS]  DEFAULT ((0)) FOR [SUPPSTATUS]
ALTER TABLE [dbo].[SUPPLIERS] ADD  CONSTRAINT [DF_SUPPLIERS_TAXCLASSIFICATION]  DEFAULT ('') FOR [TAXCLASSIFICATION]
ALTER TABLE [dbo].[SUPPLIERS] ADD  CONSTRAINT [DF_SUPPLIERS_COUNTRY]  DEFAULT ('') FOR [COUNTRY]
ALTER TABLE [dbo].[SUPPLIERS]  WITH CHECK ADD  CONSTRAINT [FK_SUPPLIERS_PROVINCES] FOREIGN KEY([PROVINCEID])
REFERENCES [dbo].[PROVINCES] ([PROVINCEID])
ALTER TABLE [dbo].[SUPPLIERS] CHECK CONSTRAINT [FK_SUPPLIERS_PROVINCES]
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE TRIGGER LOGMASTERSUPPLIERS ON [dbo].[SUPPLIERS]
AFTER UPDATE, DELETE, INSERT
AS 

SET NOCOUNT ON

declare @tableName varChar(25)
declare @primaryKey varChar(25)
declare @ignoreList varChar(500)

set @tableName = 'SUPPLIERS'
set @primaryKey = 'SUPPID'
set @ignoreList = 'DESCRIPTION'

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
 
select SUPPID,SUPPNAME,ADDRID,SUPPTYPE,CONTACTID,SHIPMETHOD,REGNO,TAXTYPEID,SUPPCODE,MSID,DEFAULTSHIPMETHODID,MPID,TPSHORTNAME,TPNAME,PROVINCEID,SUPPDBID,EID,SUPPDBEID,ISORATING,BEERating,BUSREG,SUPPSTATUS, TAXCLASSIFICATION, TAXCERTEXPIRY, COUNTRY into #inserted from INSERTED
select SUPPID,SUPPNAME,ADDRID,SUPPTYPE,CONTACTID,SHIPMETHOD,REGNO,TAXTYPEID,SUPPCODE,MSID,DEFAULTSHIPMETHODID,MPID,TPSHORTNAME,TPNAME,PROVINCEID,SUPPDBID,EID,SUPPDBEID,ISORATING,BEERating,BUSREG,SUPPSTATUS, TAXCLASSIFICATION, TAXCERTEXPIRY, COUNTRY into #deleted from DELETED

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

		
ALTER TABLE [dbo].[SUPPLIERS] ENABLE TRIGGER [LOGMASTERSUPPLIERS]