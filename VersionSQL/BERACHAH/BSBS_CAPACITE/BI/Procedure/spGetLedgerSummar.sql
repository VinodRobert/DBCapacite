/****** Object:  Procedure [BI].[spGetLedgerSummar]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BI].[spGetLedgerSummar](@LEDGERCODE VARCHAR(10),@CURRENTYEAR INT,@ORGID INT )
AS

DECLARE @LASTYEAR INT
SET @LASTYEAR = @CURRENTYEAR -1 

SELECT 
  [YEAR] FINYEAR,
  PERIOD,
  CREDNO,
  SUM(DEBIT-CREDIT) AMOUNT
FROM 
  TRANSACTIONS 
WHERE
  [YEAR] IN (@CURRENTYEAR)
GROUP BY
  [YEAR],PERIOD,CREDNO 