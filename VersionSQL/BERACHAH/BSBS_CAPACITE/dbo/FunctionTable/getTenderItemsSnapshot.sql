/****** Object:  Function [dbo].[getTenderItemsSnapshot]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Matthew Spiller
-- Create date: 09-09-2015
-- Description:	returns TenderItems rolledback to a date
-- NOTES:
--  
-- =============================================
CREATE FUNCTION getTenderItemsSnapshot (@theDate datetime)
    RETURNS @t TABLE (
    	[ITEMID] [int] NOT NULL,
	  [RESCODE] [nvarchar](20) NOT NULL,
	  [DESCR] [ntext] NOT NULL,
	  [RATE] [money] NOT NULL,
	  [UNIT] [nvarchar](15) NOT NULL,
	  [QTY] [decimal](18, 4) NOT NULL,
	  [BORG] [int] NOT NULL,
	  [PROJECT] [int] NOT NULL,
	  [CONTRACT] [int] NOT NULL,
	  [ORDEREDQTY] [decimal](18, 4) NOT NULL,
	  [EID] [char](10) NOT NULL,
	  [LEDGERCODE] [nvarchar](10) NOT NULL,
	  [CURRENCY] [nvarchar](3) NOT NULL,
	  [SUPPCODE] [nvarchar](10) NOT NULL,
	  [CATEGORY] [nvarchar](55) NOT NULL,
	  [PERIODQTY] [decimal](18, 4) NOT NULL,
	  [ORDEREDAMOUNT] [decimal](18, 4) NOT NULL,
	  [FINALWASTE] [decimal](18, 4) NOT NULL,
	  [REMARK] [nvarchar](255) NOT NULL,
	  [PERIODWASTE] [decimal](18, 4) NOT NULL,
	  [COSTRATE] [decimal](18, 4) NOT NULL,
	  [COSTQTY] [decimal](18, 4) NOT NULL,
	  [BILLQTY] [decimal](18, 4) NOT NULL,
	  [COSTWASTE] [decimal](18, 4) NOT NULL,
	  [EXCHRATE] [decimal](23, 6) NOT NULL,
	  [ACTNUMBER] [nvarchar](10) NOT NULL,
	  [ISACTDETAIL] [bit] NOT NULL,
	  [ACTUALUSAGE] [decimal](18, 4) NOT NULL,
	  [ACTUALWASTE] [decimal](18, 4) NOT NULL,
	  [SYSDATE] [datetime] NOT NULL
  )
AS
BEGIN
    insert into @t
    SELECT T.ITEMID, T.RESCODE, T.DESCR, T.RATE, T.UNIT, 
    --isnull(TS.QTY, T.QTY) QTY, 
    T.QTY QTY, 
    T.BORG, T.PROJECT, T.CONTRACT, 
    isnull(TS.ORDEREDQTY, T.ORDEREDQTY) ORDEREDQTY, T.EID, T.LEDGERCODE, T.CURRENCY, T.SUPPCODE, 
    T.CATEGORY, T.PERIODQTY, isnull(TS.ORDEREDAMOUNT, T.ORDEREDAMOUNT) ORDEREDAMOUNT, T.FINALWASTE, T.REMARK, 
    T.PERIODWASTE, T.COSTRATE, T.COSTQTY, T.BILLQTY, T.COSTWASTE, T.EXCHRATE, T.ACTNUMBER, T.ISACTDETAIL, T.ACTUALUSAGE, T.ACTUALWASTE, T.SYSDATE
    FROM TENDERITEMS AS T
    OUTER APPLY (SELECT MIN(TS.SYSDATE) SYSDATE, TS.ITEMID FROM TENDERITEMSSNAPSHOT TS WHERE TS.SYSDATE > @theDate AND TS.ITEMID = T.ITEMID GROUP BY TS.ITEMID) TSD
    LEFT OUTER JOIN TENDERITEMSSNAPSHOT TS ON T.ITEMID = TS.ITEMID AND TS.SYSDATE = TSD.SYSDATE
    WHERE T.SYSDATE <= @theDate 

	RETURN
END
		
		