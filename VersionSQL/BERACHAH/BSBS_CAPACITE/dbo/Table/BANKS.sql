/****** Object:  Table [dbo].[BANKS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[BANKS](
	[BankAccount] [nvarchar](50) NOT NULL,
	[BankBranch] [nvarchar](10) NOT NULL,
	[BankName] [char](35) NULL,
	[BankAddress1] [char](35) NULL,
	[BankAddress2] [char](35) NULL,
	[BankAddress3] [char](35) NULL,
	[BankPCode] [char](10) NULL,
	[BankTel] [char](25) NULL,
	[BankFax] [char](25) NULL,
	[BankeMail] [char](35) NULL,
	[BankContact] [char](35) NULL,
	[BankManager] [char](35) NULL,
	[BankURL] [char](55) NULL,
	[BankLedger] [char](10) NOT NULL,
	[BankBalance] [money] NULL,
	[BankBalanceClose] [money] NOT NULL,
	[BankPeriod] [char](20) NULL,
	[BankID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[BankBorgID] [int] NULL,
	[SWIFT] [nvarchar](12) NOT NULL,
	[IFSC] [nvarchar](11) NOT NULL,
	[SYSDATE] [datetime] NOT NULL,
	[USERID] [int] NOT NULL,
	[CHID] [int] NOT NULL,
	[BIC] [nvarchar](12) NULL,
	[COUNTRY] [nvarchar](55) NULL,
	[ISPDCBANK] [bit] NULL,
	[PDCCONTROL] [nvarchar](10) NULL,
	[STATUS] [int] NOT NULL,
	[APPROVALCOMMENT] [nvarchar](250) NOT NULL,
	[ISNEW] [int] NOT NULL,
 CONSTRAINT [PK_BANKS] PRIMARY KEY NONCLUSTERED 
(
	[BankAccount] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[BANKS] ADD  CONSTRAINT [DF_BANKS_BANKBRANCH]  DEFAULT ('') FOR [BankBranch]
ALTER TABLE [dbo].[BANKS] ADD  CONSTRAINT [DF_BANKS_BankBalance]  DEFAULT (0) FOR [BankBalance]
ALTER TABLE [dbo].[BANKS] ADD  CONSTRAINT [DF_BANKS_BankBalanceClose]  DEFAULT (0) FOR [BankBalanceClose]
ALTER TABLE [dbo].[BANKS] ADD  CONSTRAINT [DF_BANKS_BankBorgID]  DEFAULT (0) FOR [BankBorgID]
ALTER TABLE [dbo].[BANKS] ADD  CONSTRAINT [DF_BANKS_SWIFT]  DEFAULT ('') FOR [SWIFT]
ALTER TABLE [dbo].[BANKS] ADD  CONSTRAINT [DF_BANKS_IFSC]  DEFAULT ('') FOR [IFSC]
ALTER TABLE [dbo].[BANKS] ADD  CONSTRAINT [DF_BANKS_SYSDATE]  DEFAULT (getdate()) FOR [SYSDATE]
ALTER TABLE [dbo].[BANKS] ADD  CONSTRAINT [DF_BANKS_USERID]  DEFAULT ((-1)) FOR [USERID]
ALTER TABLE [dbo].[BANKS] ADD  DEFAULT ((-1)) FOR [CHID]
ALTER TABLE [dbo].[BANKS] ADD  CONSTRAINT [DF_BANKS_STATUS]  DEFAULT ((0)) FOR [STATUS]
ALTER TABLE [dbo].[BANKS] ADD  CONSTRAINT [DF_BANKS_APPROVALCOMMENT]  DEFAULT ('') FOR [APPROVALCOMMENT]
ALTER TABLE [dbo].[BANKS] ADD  CONSTRAINT [DF_BANKS_ISNEW]  DEFAULT ((0)) FOR [ISNEW]
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE TRIGGER LOGMASTERBANKS ON BANKS
AFTER UPDATE, DELETE, INSERT
AS

SET NOCOUNT ON

declare @tableName varChar(25)
declare @primaryKey varChar(25)
declare @ignoreList varChar(500)

set @tableName = 'BANKS'
set @primaryKey = 'BankID'
set @ignoreList = 'STATUS,BANKBALANCE,BANKBALANCECLOSE'

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
    INSERT INTO [BANKSAPPROVAL] 
    (BANKACCOUNT, BANKBRANCH, BANKNAME, BANKADDRESS1, BANKADDRESS2,
    BANKADDRESS3, BANKPCODE, BANKTEL, BANKFAX, BANKEMAIL, BANKCONTACT, BANKMANAGER,
    BANKURL, BANKBALANCE, BANKBORGID, BANKLEDGER,
    SWIFT, IFSC, CHID, COUNTRY, BIC, ISPDCBANK, PDCCONTROL,
    SOURCEID, REQUESTUSERID, SUBMITDATE, SUBMITCOMMENT, STATUS, STATUSDATE
    )
    SELECT D.BANKACCOUNT, D.BANKBRANCH, D.BANKNAME, D.BANKADDRESS1, D.BANKADDRESS2,
    D.BANKADDRESS3, D.BANKPCODE, D.BANKTEL, D.BANKFAX, D.BANKEMAIL, D.BANKCONTACT, D.BANKMANAGER,
    D.BANKURL, D.BANKBALANCE, D.BANKBORGID, D.BANKLEDGER,
    D.SWIFT, D.IFSC, D.CHID, D.COUNTRY, D.BIC, D.ISPDCBANK, D.PDCCONTROL,
    D.BANKID, I.USERID, getDate(), I.APPROVALCOMMENT, 2, getDate()
		FROM BANKS 
		INNER JOIN #inserted I on BANKS.BANKID = I.BANKID
		INNER JOIN #deleted D on BANKS.BANKID = D.BANKID
		INNER JOIN BORGS B ON I.BANKBORGID = B.BORGID AND B.USEBANKAPPROVALS = 1
		WHERE I.STATUS in (0, 4)
		and D.STATUS in (0, 4)
      
		UPDATE BANKS 
		SET STATUS = CASE WHEN B.USEBANKAPPROVALS = 1 then 2 else BANKS.STATUS end,
    SYSDATE = getDate(), 
    USERID = I.USERID, 
    APPROVALCOMMENT = ''
		FROM BANKS 
		INNER JOIN #inserted I on BANKS.BANKID = I.BANKID
		INNER JOIN #deleted D on BANKS.BANKID = D.BANKID
		INNER JOIN BORGS B ON I.BANKBORGID = B.BORGID
		WHERE I.STATUS in (0, 4)
		and D.STATUS in (0, 4)
	END
END   

if @action = 'DELETE' or @action = 'INSERT'
BEGIN
  if @action = 'INSERT'
  BEGIN  
    UPDATE BANKS 
    SET ISNEW = BANKS.STATUS
    FROM BANKS 
    INNER JOIN #inserted I on BANKS.BANKID = I.BANKID
    WHERE BANKS.STATUS = 1
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

		
ALTER TABLE [dbo].[BANKS] ENABLE TRIGGER [LOGMASTERBANKS]