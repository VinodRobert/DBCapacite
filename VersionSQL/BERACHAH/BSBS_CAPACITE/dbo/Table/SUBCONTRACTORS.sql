/****** Object:  Table [dbo].[SUBCONTRACTORS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[SUBCONTRACTORS](
	[SubNumber] [char](10) NOT NULL,
	[SubName] [nvarchar](127) NOT NULL,
	[SubAddress1] [nvarchar](55) NULL,
	[SubAddress2] [nvarchar](55) NULL,
	[SubAddress3] [nvarchar](55) NULL,
	[SubPCode] [char](10) NULL,
	[SubTel] [char](25) NULL,
	[SubFax] [char](25) NULL,
	[SubeMail] [char](255) NULL,
	[SubContact] [nvarchar](55) NOT NULL,
	[SubURL] [char](55) NULL,
	[SubContactCell] [char](25) NULL,
	[SubType] [char](25) NULL,
	[SubPayMethod] [char](25) NULL,
	[SubGLCode] [char](10) NULL,
	[SubVATNo] [char](15) NULL,
	[ToJoinSUB] [int] NOT NULL,
	[SubID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SubSelect] [char](5) NOT NULL,
	[SubStatus] [int] NOT NULL,
	[Actid] [int] NOT NULL,
	[BEStatus] [char](1) NOT NULL,
	[CATEGORY] [char](1) NOT NULL,
	[SUBTAXNO] [char](15) NOT NULL,
	[SUBBUSREG] [nvarchar](25) NOT NULL,
	[SUBNIDCN] [char](15) NOT NULL,
	[BeType] [char](1) NOT NULL,
	[BeLevel] [char](1) NOT NULL,
	[BeVav] [char](1) NOT NULL,
	[HaveSelfInvoice] [bit] NULL,
	[PROVINCEID] [int] NOT NULL,
	[CUSTOMS] [nvarchar](15) NOT NULL,
	[EXCISE] [nvarchar](15) NOT NULL,
	[SERVICETAX] [nvarchar](15) NOT NULL,
	[PAN] [nvarchar](15) NOT NULL,
	[ISOCERTIFICATION] [nvarchar](15) NOT NULL,
	[BEEXPIRYDATE] [datetime] NULL,
	[WCAINSEXPIRYDATE] [datetime] NULL,
	[RemittanceEmail] [varchar](512) NULL,
	[COUNTRY] [nvarchar](55) NOT NULL,
	[HMRCBUSINESSTYPE] [int] NULL,
	[HMRCTAXTYPE] [nvarchar](15) NOT NULL,
	[HMRCNINO] [nvarchar](9) NOT NULL,
	[HMRCUTR] [nvarchar](10) NOT NULL,
	[HMRCSVN] [nvarchar](13) NOT NULL,
	[HMRCSVNDATE] [datetime] NULL,
	[TAXCLASSIFICATION] [nvarchar](100) NOT NULL,
	[TAXCERTEXPIRY] [datetime] NULL,
	[TERMS] [int] NULL,
	[TaxReporting] [bit] NULL,
	[Type1099] [int] NULL,
	[Code1099] [int] NULL,
	[TERMSEOM] [bit] NOT NULL,
 CONSTRAINT [PK_SUBCONTRACTORS] PRIMARY KEY NONCLUSTERED 
(
	[SubNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_SUBCONTRACTORS_SubID_SubNumber] ON [dbo].[SUBCONTRACTORS]
(
	[SubID] ASC,
	[SubNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_SUBCONTRACTORS_SubNumber] ON [dbo].[SUBCONTRACTORS]
(
	[SubNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
ALTER TABLE [dbo].[SUBCONTRACTORS] ADD  CONSTRAINT [DF_SUBCONTRACTORS_SUBNAME]  DEFAULT ('') FOR [SubName]
ALTER TABLE [dbo].[SUBCONTRACTORS] ADD  CONSTRAINT [DF_SUBCONTRACTORS_SUBCONTACT]  DEFAULT ('') FOR [SubContact]
ALTER TABLE [dbo].[SUBCONTRACTORS] ADD  CONSTRAINT [DF_SUBCONTRACTORS_ToJoinSUB]  DEFAULT (7) FOR [ToJoinSUB]
ALTER TABLE [dbo].[SUBCONTRACTORS] ADD  CONSTRAINT [DF_SUBCONTRACTORS_SubSelect]  DEFAULT ('') FOR [SubSelect]
ALTER TABLE [dbo].[SUBCONTRACTORS] ADD  CONSTRAINT [DF__SUBCONTRA__SubSt__1A422E23]  DEFAULT (0) FOR [SubStatus]
ALTER TABLE [dbo].[SUBCONTRACTORS] ADD  CONSTRAINT [DF_SUBCONTRACTORS_Actid]  DEFAULT ((-1)) FOR [Actid]
ALTER TABLE [dbo].[SUBCONTRACTORS] ADD  CONSTRAINT [DF_SUBCONTRACTORS_BEStatus]  DEFAULT ('F') FOR [BEStatus]
ALTER TABLE [dbo].[SUBCONTRACTORS] ADD  CONSTRAINT [DF__SUBCONTRA__CATEG__0428CFD2]  DEFAULT ('') FOR [CATEGORY]
ALTER TABLE [dbo].[SUBCONTRACTORS] ADD  DEFAULT ('') FOR [SUBTAXNO]
ALTER TABLE [dbo].[SUBCONTRACTORS] ADD  CONSTRAINT [DF_SUBCONTRACTORS_SUBBUSREG]  DEFAULT ('') FOR [SUBBUSREG]
ALTER TABLE [dbo].[SUBCONTRACTORS] ADD  DEFAULT ('') FOR [SUBNIDCN]
ALTER TABLE [dbo].[SUBCONTRACTORS] ADD  DEFAULT ('E') FOR [BeType]
ALTER TABLE [dbo].[SUBCONTRACTORS] ADD  DEFAULT ('0') FOR [BeLevel]
ALTER TABLE [dbo].[SUBCONTRACTORS] ADD  DEFAULT ('C') FOR [BeVav]
ALTER TABLE [dbo].[SUBCONTRACTORS] ADD  DEFAULT ((0)) FOR [HaveSelfInvoice]
ALTER TABLE [dbo].[SUBCONTRACTORS] ADD  CONSTRAINT [DF_SUBCONTRACTORS_PROVINCEID]  DEFAULT ((-1)) FOR [PROVINCEID]
ALTER TABLE [dbo].[SUBCONTRACTORS] ADD  CONSTRAINT [DF_SUBCONTRACTORS_CUSTOMS]  DEFAULT ('') FOR [CUSTOMS]
ALTER TABLE [dbo].[SUBCONTRACTORS] ADD  CONSTRAINT [DF_SUBCONTRACTORS_EXCISE]  DEFAULT ('') FOR [EXCISE]
ALTER TABLE [dbo].[SUBCONTRACTORS] ADD  CONSTRAINT [DF_SUBCONTRACTORS_SERVICETAX]  DEFAULT ('') FOR [SERVICETAX]
ALTER TABLE [dbo].[SUBCONTRACTORS] ADD  CONSTRAINT [DF_SUBCONTRACTORS_PAN]  DEFAULT ('') FOR [PAN]
ALTER TABLE [dbo].[SUBCONTRACTORS] ADD  CONSTRAINT [DF_SUBCONTRACTORS_ISOCERTIFICATION]  DEFAULT ('') FOR [ISOCERTIFICATION]
ALTER TABLE [dbo].[SUBCONTRACTORS] ADD  CONSTRAINT [DF_SUBCONTRACTORS_COUNTRY]  DEFAULT ('') FOR [COUNTRY]
ALTER TABLE [dbo].[SUBCONTRACTORS] ADD  CONSTRAINT [DF_SUBCONTRACTORS_HMRCTAXTYPE]  DEFAULT ('') FOR [HMRCTAXTYPE]
ALTER TABLE [dbo].[SUBCONTRACTORS] ADD  CONSTRAINT [DF_SUBCONTRACTORS_HMRCNINO]  DEFAULT ('') FOR [HMRCNINO]
ALTER TABLE [dbo].[SUBCONTRACTORS] ADD  CONSTRAINT [DF_SUBCONTRACTORS_HMRCUTR]  DEFAULT ('') FOR [HMRCUTR]
ALTER TABLE [dbo].[SUBCONTRACTORS] ADD  CONSTRAINT [DF_SUBCONTRACTORS_HMRCSVN]  DEFAULT ('') FOR [HMRCSVN]
ALTER TABLE [dbo].[SUBCONTRACTORS] ADD  CONSTRAINT [DF_SUBCONTRACTORS_TAXCLASSIFICATION]  DEFAULT ('') FOR [TAXCLASSIFICATION]
ALTER TABLE [dbo].[SUBCONTRACTORS] ADD  CONSTRAINT [DF_SUBCONTRACTORS_TERMSEOM]  DEFAULT (N'0') FOR [TERMSEOM]
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE TRIGGER LOGMASTERSUBCONTRACTORS ON SUBCONTRACTORS
AFTER UPDATE, DELETE, INSERT
AS 

SET NOCOUNT ON

declare @tableName varChar(25)
declare @primaryKey varChar(25)
declare @ignoreList varChar(500)

set @tableName = 'SUBCONTRACTORS'
set @primaryKey = 'SubID'
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

		
ALTER TABLE [dbo].[SUBCONTRACTORS] ENABLE TRIGGER [LOGMASTERSUBCONTRACTORS]