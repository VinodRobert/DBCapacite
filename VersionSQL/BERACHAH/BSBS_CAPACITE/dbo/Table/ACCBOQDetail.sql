/****** Object:  Table [dbo].[ACCBOQDetail]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ACCBOQDetail](
	[DetailId] [int] IDENTITY(700,1) NOT FOR REPLICATION NOT NULL,
	[HeaderId] [int] NOT NULL,
	[Use] [bit] NOT NULL,
	[dbid] [int] NULL,
	[counter] [int] NOT NULL,
	[isc] [text] NULL,
	[section] [text] NULL,
	[bill] [text] NULL,
	[page no] [nvarchar](10) NULL,
	[item no] [int] NULL,
	[doc ref] [text] NULL,
	[pay ref] [text] NULL,
	[description] [text] NULL,
	[unit] [text] NULL,
	[quantity] [decimal](22, 8) NOT NULL,
	[prog QTY] [decimal](22, 8) NOT NULL,
	[prev QTY] [decimal](22, 8) NOT NULL,
	[final QTY] [decimal](22, 8) NOT NULL,
	[rate] [numeric](18, 4) NOT NULL,
	[amount] [numeric](18, 4) NOT NULL,
	[ACTID] [char](10) NOT NULL,
	[FILETYPE] [varchar](20) NOT NULL,
	[STATUS] [char](1) NOT NULL,
	[DUEQTY] [decimal](22, 8) NOT NULL,
	[INVQTY] [decimal](22, 8) NOT NULL,
	[Remarks] [nvarchar](255) NULL,
	[ReconHistID] [int] NOT NULL,
	[IsSysEntry] [bit] NOT NULL,
	[INVAMOUNT] [money] NOT NULL,
	[INVRATE] [decimal](22, 8) NOT NULL,
	[ChangeStatus] [int] NOT NULL,
	[ChangeUser] [int] NOT NULL,
	[ChangeDate] [datetime] NOT NULL,
	[LastDetailId] [int] NOT NULL,
	[PrevDetailId] [int] NOT NULL,
 CONSTRAINT [PK_ACCBOQDetail] PRIMARY KEY CLUSTERED 
(
	[DetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[ACCBOQDetail] ADD  CONSTRAINT [DF__ACCBOQDetai__Use__32F8CD54]  DEFAULT (0) FOR [Use]
ALTER TABLE [dbo].[ACCBOQDetail] ADD  CONSTRAINT [DF_ACCBOQDetail_page no]  DEFAULT ('') FOR [page no]
ALTER TABLE [dbo].[ACCBOQDetail] ADD  CONSTRAINT [DF_ACCBOQDetail_quantity]  DEFAULT ((0)) FOR [quantity]
ALTER TABLE [dbo].[ACCBOQDetail] ADD  CONSTRAINT [DF_ACCBOQDetail_prog QTY]  DEFAULT ((0)) FOR [prog QTY]
ALTER TABLE [dbo].[ACCBOQDetail] ADD  CONSTRAINT [DF_ACCBOQDetail_prev QTY]  DEFAULT ((0)) FOR [prev QTY]
ALTER TABLE [dbo].[ACCBOQDetail] ADD  CONSTRAINT [DF_ACCBOQDetail_final QTY]  DEFAULT ((0)) FOR [final QTY]
ALTER TABLE [dbo].[ACCBOQDetail] ADD  CONSTRAINT [DF__ACCBOQDeta__rate__37BD8271]  DEFAULT (0) FOR [rate]
ALTER TABLE [dbo].[ACCBOQDetail] ADD  CONSTRAINT [DF__ACCBOQDet__amoun__38B1A6AA]  DEFAULT (0) FOR [amount]
ALTER TABLE [dbo].[ACCBOQDetail] ADD  CONSTRAINT [DF_ACCBOQDETAIL_ACTID]  DEFAULT ('') FOR [ACTID]
ALTER TABLE [dbo].[ACCBOQDetail] ADD  CONSTRAINT [DF_ACCBOQDETAIL_FILETYPE]  DEFAULT ('') FOR [FILETYPE]
ALTER TABLE [dbo].[ACCBOQDetail] ADD  CONSTRAINT [DF_ACCBOQDETAIL_STATUS]  DEFAULT ('') FOR [STATUS]
ALTER TABLE [dbo].[ACCBOQDetail] ADD  CONSTRAINT [DF_ACCBOQDetail_DUEQTY]  DEFAULT ((0)) FOR [DUEQTY]
ALTER TABLE [dbo].[ACCBOQDetail] ADD  CONSTRAINT [DF_ACCBOQDetail_INVQTY]  DEFAULT ((0)) FOR [INVQTY]
ALTER TABLE [dbo].[ACCBOQDetail] ADD  CONSTRAINT [DF_ACCBOQDetail_ReconHistID]  DEFAULT ((-1)) FOR [ReconHistID]
ALTER TABLE [dbo].[ACCBOQDetail] ADD  CONSTRAINT [DF_ACCBOQDetail_IsSysEntry]  DEFAULT (N'0') FOR [IsSysEntry]
ALTER TABLE [dbo].[ACCBOQDetail] ADD  CONSTRAINT [DF_ACCBOQDetail_INVAMOUNT]  DEFAULT ((0)) FOR [INVAMOUNT]
ALTER TABLE [dbo].[ACCBOQDetail] ADD  CONSTRAINT [DF_ACCBOQDetail_INVRATE]  DEFAULT ((0)) FOR [INVRATE]
ALTER TABLE [dbo].[ACCBOQDetail] ADD  CONSTRAINT [DF_ACCBOQDetail_ChangeStatus]  DEFAULT ((-1)) FOR [ChangeStatus]
ALTER TABLE [dbo].[ACCBOQDetail] ADD  CONSTRAINT [DF_ACCBOQDetail_ChangeUser]  DEFAULT ((-1)) FOR [ChangeUser]
ALTER TABLE [dbo].[ACCBOQDetail] ADD  CONSTRAINT [DF_ACCBOQDetail_ChangeDate]  DEFAULT (getdate()) FOR [ChangeDate]
ALTER TABLE [dbo].[ACCBOQDetail] ADD  CONSTRAINT [DF_ACCBOQDetail_LastDetailId]  DEFAULT ((-1)) FOR [LastDetailId]
ALTER TABLE [dbo].[ACCBOQDetail] ADD  CONSTRAINT [DF_ACCBOQDetail_PrevDetailId]  DEFAULT ((-1)) FOR [PrevDetailId]
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE TRIGGER LOGMASTERACCBOQDETAIL ON ACCBOQDETAIL
AFTER UPDATE, DELETE, INSERT
AS 

SET NOCOUNT ON

declare @tableName varChar(25)
declare @primaryKey varChar(25)
declare @ignoreList varChar(500)

set @tableName = 'ACCBOQDETAIL'
set @primaryKey = 'DetailId'
set @ignoreList = '[bill],[description],[doc ref],[isc],[pay ref],[section],[unit]'

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
 
select [ACTID],[amount],[ChangeDate],[ChangeStatus],[ChangeUser],[counter],[dbid],[DetailId],[DUEQTY],[FILETYPE],[final QTY],[HeaderId],[INVAMOUNT],[INVQTY],[INVRATE],[IsSysEntry],[item no],[LastDetailId],[page no],[prev QTY],[PrevDetailId],[prog QTY],[quantity],[rate],[ReconHistID],[REMARKS],[STATUS],[Use] into #inserted from INSERTED
select [ACTID],[amount],[ChangeDate],[ChangeStatus],[ChangeUser],[counter],[dbid],[DetailId],[DUEQTY],[FILETYPE],[final QTY],[HeaderId],[INVAMOUNT],[INVQTY],[INVRATE],[IsSysEntry],[item no],[LastDetailId],[page no],[prev QTY],[PrevDetailId],[prog QTY],[quantity],[rate],[ReconHistID],[REMARKS],[STATUS],[Use] into #deleted from DELETED

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

		
ALTER TABLE [dbo].[ACCBOQDetail] ENABLE TRIGGER [LOGMASTERACCBOQDETAIL]
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
create TRIGGER [dbo].[MonthEnd] ON [dbo].[ACCBOQDetail] FOR UPDATE
AS
 IF @@ROWCOUNT = 0
   RETURN
 DECLARE @MONTHENDID INT
 DECLARE @DETAILID   INT
 IF UPDATE ([PREV QTY]) 
 BEGIN
   SELECT @DETAILID=DETAILID FROM INSERTED
   SELECT @MONTHENDID=ISNULL(MAX(MONTHENDID),0) FROM ACCBOQDetailArchieve WHERE DETAILID=@DETAILID
   SET @MONTHENDID=@MONTHENDID+1
   INSERT INTO ACCBOQDetailArchieve SELECT @MONTHENDID,DETAILID,HEADERID,QUANTITY,[PROG QTY],[PREV QTY],[FINAL QTY],[RATE],[AMOUNT],[ACTID] 
   FROM INSERTED
 END

ALTER TABLE [dbo].[ACCBOQDetail] DISABLE TRIGGER [MonthEnd]