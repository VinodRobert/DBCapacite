/****** Object:  Table [dbo].[SUBCONTRACTORSBANK]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[SUBCONTRACTORSBANK](
	[CredBankOrgID] [int] NOT NULL,
	[CredNumber] [char](10) NOT NULL,
	[CredBank] [int] NOT NULL,
	[CredBranch] [nvarchar](10) NOT NULL,
	[CredAccNumber] [nvarchar](50) NOT NULL,
	[CredAccType] [nchar](1) NOT NULL,
	[CredBankID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CredAccName] [nvarchar](30) NOT NULL,
	[CredRef] [char](30) NOT NULL,
	[STANDARDBANK_PROFILE] [nvarchar](16) NOT NULL,
	[SWIFT] [nvarchar](12) NOT NULL,
	[IFSC] [nvarchar](30) NOT NULL,
	[SYSDATE] [datetime] NOT NULL,
	[USERID] [int] NOT NULL,
	[COUNTRY] [nvarchar](55) NOT NULL,
	[STATUS] [int] NOT NULL,
	[APPROVALCOMMENT] [nvarchar](250) NOT NULL,
	[SUSPEND] [bit] NOT NULL,
	[ISNEW] [int] NOT NULL,
 CONSTRAINT [PK_SUBCONTRACTORSBANK] PRIMARY KEY CLUSTERED 
(
	[CredBankOrgID] ASC,
	[CredNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[SUBCONTRACTORSBANK] ADD  CONSTRAINT [DF_SUBCONTRACTORSBANK_CredBank]  DEFAULT ((-1)) FOR [CredBank]
ALTER TABLE [dbo].[SUBCONTRACTORSBANK] ADD  CONSTRAINT [DF_SUBCONTRACTORSBANK_CREDBRANCH]  DEFAULT ('') FOR [CredBranch]
ALTER TABLE [dbo].[SUBCONTRACTORSBANK] ADD  CONSTRAINT [DF_SUBCONTRACTORSBANK_CREDACCNUMBER]  DEFAULT ('') FOR [CredAccNumber]
ALTER TABLE [dbo].[SUBCONTRACTORSBANK] ADD  CONSTRAINT [DF_SUBCONTRACTORSBANK_CREDACCNAME]  DEFAULT ('') FOR [CredAccName]
ALTER TABLE [dbo].[SUBCONTRACTORSBANK] ADD  CONSTRAINT [DF_SUBCONTRACTORSBANK_CredRef]  DEFAULT ('') FOR [CredRef]
ALTER TABLE [dbo].[SUBCONTRACTORSBANK] ADD  DEFAULT ('') FOR [STANDARDBANK_PROFILE]
ALTER TABLE [dbo].[SUBCONTRACTORSBANK] ADD  CONSTRAINT [DF_SUBCONTRACTORSBANK_SWIFT]  DEFAULT ('') FOR [SWIFT]
ALTER TABLE [dbo].[SUBCONTRACTORSBANK] ADD  CONSTRAINT [DF_SUBCONTRACTORSBANK_IFSC]  DEFAULT ('') FOR [IFSC]
ALTER TABLE [dbo].[SUBCONTRACTORSBANK] ADD  CONSTRAINT [DF_SUBCONTRACTORSBANK_SYSDATE]  DEFAULT (getdate()) FOR [SYSDATE]
ALTER TABLE [dbo].[SUBCONTRACTORSBANK] ADD  CONSTRAINT [DF_SUBCONTRACTORSBANK_USERID]  DEFAULT ((-1)) FOR [USERID]
ALTER TABLE [dbo].[SUBCONTRACTORSBANK] ADD  CONSTRAINT [DF_SUBCONTRACTORSBANK_COUNTRY]  DEFAULT ('') FOR [COUNTRY]
ALTER TABLE [dbo].[SUBCONTRACTORSBANK] ADD  CONSTRAINT [DF_SUBCONTRACTORSBANK_STATUS]  DEFAULT ((0)) FOR [STATUS]
ALTER TABLE [dbo].[SUBCONTRACTORSBANK] ADD  CONSTRAINT [DF_SUBCONTRACTORSBANK_APPROVALCOMMENT]  DEFAULT ('') FOR [APPROVALCOMMENT]
ALTER TABLE [dbo].[SUBCONTRACTORSBANK] ADD  CONSTRAINT [DF_SUBCONTRACTORSBANK_SUSPEND]  DEFAULT (N'0') FOR [SUSPEND]
ALTER TABLE [dbo].[SUBCONTRACTORSBANK] ADD  CONSTRAINT [DF_SUBCONTRACTORSBANK_ISNEW]  DEFAULT ((0)) FOR [ISNEW]
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE TRIGGER LOGMASTERSUBCONTRACTORSBANK ON SUBCONTRACTORSBANK
AFTER UPDATE, DELETE, INSERT
AS 

SET NOCOUNT ON

declare @tableName varChar(25)
declare @primaryKey varChar(25)
declare @ignoreList varChar(500)

set @tableName = 'SUBCONTRACTORSBANK'
set @primaryKey = 'CredBankID'
set @ignoreList = 'STATUS'

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
  
  DECLARE @Rows int
	SELECT @Rows=@@ROWCOUNT
  
  declare @newStatus int
  declare @previousStatus int
  select @newStatus = STATUS from #inserted
  select @previousStatus = STATUS from #deleted
  
  If @Rows > 0 
	Begin
    if @newStatus in (1, 2) and @previousStatus in (1, 2)
    BEGIN
		  Declare @Mess Char(300)
		  Set @Mess = 'Can not edit bank while it is pending approval.'
		  Raiserror( @Mess ,16,1)
		  RollBack Transaction
		  set @Rows = 0
    END     
	End

	if @Rows > 0 
	BEGIN
    INSERT INTO [SUBCONTRACTORSBANKAPPROVAL] (
	  CREDBANKORGID, CREDNUMBER, CREDBANK, CREDACCNAME, CREDBRANCH, CREDACCNUMBER, CREDACCTYPE,
	  CREDREF, STANDARDBANK_PROFILE, SWIFT, IFSC, COUNTRY, SUSPEND, 
    SOURCEID, REQUESTUSERID, SUBMITDATE, SUBMITCOMMENT, STATUS, STATUSDATE)
    SELECT D.CREDBANKORGID, D.CREDNUMBER, D.CREDBANK, D.CREDACCNAME, D.CREDBRANCH, D.CREDACCNUMBER, D.CREDACCTYPE,
    D.CREDREF, D.STANDARDBANK_PROFILE, D.SWIFT, D.IFSC, D.COUNTRY, D.SUSPEND, 
    D.CREDBANKID, I.USERID, getDate(), I.APPROVALCOMMENT, 2, getDate()
    FROM CREDITORSBANK 
		INNER JOIN #inserted I on CREDITORSBANK.CREDBANKID = I.CREDBANKID
		INNER JOIN #deleted D on CREDITORSBANK.CREDBANKID = D.CREDBANKID
		INNER JOIN BORGS B ON I.CREDBANKORGID = B.BORGID AND B.USEBANKAPPROVALS = 1
		WHERE I.STATUS in (0, 4)
		and D.STATUS in (0, 4)
     
		UPDATE SUBCONTRACTORSBANK 
		SET STATUS = CASE WHEN B.USEBANKAPPROVALS = 1 then 2 else SUBCONTRACTORSBANK.STATUS end,
    SYSDATE = getDate(), 
    USERID = I.USERID, 
    APPROVALCOMMENT = ''
		FROM SUBCONTRACTORSBANK 
		INNER JOIN #inserted I on SUBCONTRACTORSBANK.CREDBANKID = I.CREDBANKID
		INNER JOIN #deleted D on SUBCONTRACTORSBANK.CREDBANKID = D.CREDBANKID
		INNER JOIN BORGS B ON I.CREDBANKORGID = B.BORGID 
		WHERE I.STATUS in (0, 4)
		and D.STATUS in (0, 4)
	END
END   

if @action = 'DELETE' or @action = 'INSERT'
BEGIN
  if @action = 'INSERT'
  BEGIN  
    UPDATE SUBCONTRACTORSBANK 
    SET ISNEW = SUBCONTRACTORSBANK.STATUS
    FROM SUBCONTRACTORSBANK 
    INNER JOIN #inserted I on SUBCONTRACTORSBANK.CREDBANKID = I.CREDBANKID
    WHERE SUBCONTRACTORSBANK.STATUS = 1
  END   
  
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

BEGIN TRY			
	DROP TABLE #inserted
	DROP TABLE #deleted
END TRY
BEGIN CATCH END CATCH

		
ALTER TABLE [dbo].[SUBCONTRACTORSBANK] ENABLE TRIGGER [LOGMASTERSUBCONTRACTORSBANK]