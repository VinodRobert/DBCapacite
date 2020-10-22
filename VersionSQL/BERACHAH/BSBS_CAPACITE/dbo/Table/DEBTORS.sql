/****** Object:  Table [dbo].[DEBTORS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DEBTORS](
	[DebtNumber] [char](10) NOT NULL,
	[DebtName] [nvarchar](127) NOT NULL,
	[DebtAddress1] [char](55) NULL,
	[DebtAddress2] [char](55) NULL,
	[DebtAddress3] [char](55) NULL,
	[DebtPCode] [char](10) NULL,
	[DebtTel] [char](25) NULL,
	[DebtFax] [char](25) NULL,
	[DebteMail] [char](55) NULL,
	[DebtURL] [char](55) NULL,
	[DebtRetention] [money] NULL,
	[DebtID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[DebtContact] [char](25) NULL,
	[ToJoinDT] [int] NOT NULL,
	[DebtGLCode] [char](10) NOT NULL,
	[DebtControl] [char](10) NOT NULL,
	[DebtVatNo] [char](15) NOT NULL,
	[DebtStatus] [int] NOT NULL,
	[DebtInvPerPltNun] [bit] NOT NULL,
	[DebtPenDesc] [char](20) NOT NULL,
	[PROVINCEID] [int] NOT NULL,
	[CUSTOMS] [nvarchar](15) NOT NULL,
	[EXCISE] [nvarchar](15) NOT NULL,
	[SERVICETAX] [nvarchar](15) NOT NULL,
	[PAN] [nvarchar](15) NOT NULL,
	[ISOCERTIFICATION] [nvarchar](15) NOT NULL,
	[DEBTBUSREG] [nvarchar](25) NOT NULL,
	[STXDEFVATID] [char](2) NOT NULL,
	[TAXCLASSIFICATION] [nvarchar](100) NOT NULL,
	[TAXCERTEXPIRY] [datetime] NULL,
	[COUNTRY] [nvarchar](55) NOT NULL,
	[TERMS] [int] NULL,
	[STKHIREPRC] [decimal](18, 2) NOT NULL,
	[InvoiceEmailAddress] [nvarchar](255) NULL,
	[InvoicePassword] [nvarchar](55) NULL,
 CONSTRAINT [PK_DEBTORS] PRIMARY KEY NONCLUSTERED 
(
	[DebtNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [IX_DEBTORS] UNIQUE NONCLUSTERED 
(
	[DebtID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_DEBTORS_DebtNumber] ON [dbo].[DEBTORS]
(
	[DebtNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
ALTER TABLE [dbo].[DEBTORS] ADD  CONSTRAINT [DF_DEBTORS_DEBTNAME]  DEFAULT ('') FOR [DebtName]
ALTER TABLE [dbo].[DEBTORS] ADD  CONSTRAINT [DF_DEBTORS_ToJoinDT]  DEFAULT ((6)) FOR [ToJoinDT]
ALTER TABLE [dbo].[DEBTORS] ADD  CONSTRAINT [DF_DEBTORS_DebtGLCode]  DEFAULT ('001') FOR [DebtGLCode]
ALTER TABLE [dbo].[DEBTORS] ADD  CONSTRAINT [DF_DEBTORS_DebtControl]  DEFAULT ('') FOR [DebtControl]
ALTER TABLE [dbo].[DEBTORS] ADD  CONSTRAINT [DF_DEBTORS_DebtVatNo]  DEFAULT ('') FOR [DebtVatNo]
ALTER TABLE [dbo].[DEBTORS] ADD  CONSTRAINT [DF__DEBTORS__DebtSta__26A80508]  DEFAULT ((0)) FOR [DebtStatus]
ALTER TABLE [dbo].[DEBTORS] ADD  CONSTRAINT [DF__DEBTORS__DebtInv__47677850]  DEFAULT ((0)) FOR [DebtInvPerPltNun]
ALTER TABLE [dbo].[DEBTORS] ADD  CONSTRAINT [DF__DEBTORS__DebtPen__485B9C89]  DEFAULT ('Penalties') FOR [DebtPenDesc]
ALTER TABLE [dbo].[DEBTORS] ADD  CONSTRAINT [DF_DEBTORS_PROVINCEID]  DEFAULT ((-1)) FOR [PROVINCEID]
ALTER TABLE [dbo].[DEBTORS] ADD  CONSTRAINT [DF_DEBTORS_CUSTOMS]  DEFAULT ('') FOR [CUSTOMS]
ALTER TABLE [dbo].[DEBTORS] ADD  CONSTRAINT [DF_DEBTORS_EXCISE]  DEFAULT ('') FOR [EXCISE]
ALTER TABLE [dbo].[DEBTORS] ADD  CONSTRAINT [DF_DEBTORS_SERVICETAX]  DEFAULT ('') FOR [SERVICETAX]
ALTER TABLE [dbo].[DEBTORS] ADD  CONSTRAINT [DF_DEBTORS_PAN]  DEFAULT ('') FOR [PAN]
ALTER TABLE [dbo].[DEBTORS] ADD  CONSTRAINT [DF_DEBTORS_ISOCERTIFICATION]  DEFAULT ('') FOR [ISOCERTIFICATION]
ALTER TABLE [dbo].[DEBTORS] ADD  CONSTRAINT [DF_DEBTORS_DEBTBUSREG]  DEFAULT ('') FOR [DEBTBUSREG]
ALTER TABLE [dbo].[DEBTORS] ADD  CONSTRAINT [DF_DEBTORS_STXDEFVATID]  DEFAULT ('') FOR [STXDEFVATID]
ALTER TABLE [dbo].[DEBTORS] ADD  CONSTRAINT [DF_DEBTORS_TAXCLASSIFICATION]  DEFAULT ('') FOR [TAXCLASSIFICATION]
ALTER TABLE [dbo].[DEBTORS] ADD  CONSTRAINT [DF_DEBTORS_COUNTRY]  DEFAULT ('') FOR [COUNTRY]
ALTER TABLE [dbo].[DEBTORS] ADD  CONSTRAINT [DF_DEBTORS_STKHIREPRC]  DEFAULT ((0)) FOR [STKHIREPRC]
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE TRIGGER LOGMASTERDEBTORS ON DEBTORS
AFTER UPDATE, DELETE, INSERT
AS 

SET NOCOUNT ON

declare @tableName varChar(25)
declare @primaryKey varChar(25)
declare @ignoreList varChar(500)

set @tableName = 'DEBTORS'
set @primaryKey = 'DebtID'
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

		
ALTER TABLE [dbo].[DEBTORS] ENABLE TRIGGER [LOGMASTERDEBTORS]