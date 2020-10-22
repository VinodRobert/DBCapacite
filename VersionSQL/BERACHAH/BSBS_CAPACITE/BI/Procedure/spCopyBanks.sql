/****** Object:  Procedure [BI].[spCopyBanks]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE BI.spCopyBanks 
as
DECLARE @BORGID INT

CREATE TABLE #BANKLIST (
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
	[BankID] [int] ,
	[BankBorgID] [int] NULL,
	[SWIFT] [nvarchar](12) NOT NULL,
	[IFSC] [nvarchar](11) NOT NULL,
	[SYSDATE] [datetime] NOT NULL,
	[USERID] [int] NOT NULL,
	[CHID] [int] NOT NULL,
	[BIC] [nvarchar](12) NULL,
	[COUNTRY] [nvarchar](55) NULL,
	[ISPDCBANK] [bit] NULL,
	[PDCCONTROL] [nvarchar](10) NULL 
)



DECLARE BORGLIST CURSOR FOR SELECT BORGID FROM BORGS WHERE BORGID<>1 
OPEN BORGLIST
FETCH NEXT FROM BORGLIST INTO @BORGID 
WHILE @@FETCH_STATUS=0
BEGIN
  DELETE FROM #BANKLIST 
  INSERT INTO #BANKLIST SELECT *  FROM BANKS WHERE BANKBORGID=2 

  DELETE FROM #BANKLIST WHERE BANKNAME='Bank For WHT Payment               '

  DELETE FROM #BANKLIST WHERE BankLedger IN (SELECT BANKLEDGER FROM BANKS WHERE BANKBORGID=@BORGID)

  UPDATE #BANKLIST SET BANKBORGID = @BORGID 
  
  UPDATE #BANKLIST SET BANKBALANCE=0,BankBalanceClose=0

  UPDATE #BANKLIST SET BANKACCOUNT=LTRIM(RTRIM(BANKACCOUNT))+'-'+LTRIM(RTRIM(STR(@BORGID))) 

  INSERT INTO [dbo].[BANKS]
           ([BankAccount]
           ,[BankBranch]
           ,[BankName]
           ,[BankAddress1]
           ,[BankAddress2]
           ,[BankAddress3]
           ,[BankPCode]
           ,[BankTel]
           ,[BankFax]
           ,[BankeMail]
           ,[BankContact]
           ,[BankManager]
           ,[BankURL]
           ,[BankLedger]
           ,[BankBalance]
           ,[BankBalanceClose]
           ,[BankPeriod]
           ,[BankBorgID]
           ,[SWIFT]
           ,[IFSC]
           ,[SYSDATE]
           ,[USERID]
           ,[CHID]
           ,[BIC]
           ,[COUNTRY]
           ,[ISPDCBANK]
           ,[PDCCONTROL])
  SELECT [BankAccount]
      ,[BankBranch]
      ,[BankName]
      ,[BankAddress1]
      ,[BankAddress2]
      ,[BankAddress3]
      ,[BankPCode]
      ,[BankTel]
      ,[BankFax]
      ,[BankeMail]
      ,[BankContact]
      ,[BankManager]
      ,[BankURL]
      ,[BankLedger]
      ,[BankBalance]
      ,[BankBalanceClose]
      ,[BankPeriod]
      ,[BankBorgID]
      ,[SWIFT]
      ,[IFSC]
      ,[SYSDATE]
      ,[USERID]
      ,[CHID]
      ,[BIC]
      ,[COUNTRY]
      ,[ISPDCBANK]
      ,[PDCCONTROL]
  FROM #BANKLIST

  FETCH NEXT FROM BORGLIST INTO @BORGID 
END
CLOSE BORGLIST
DEALLOCATE BORGLIST