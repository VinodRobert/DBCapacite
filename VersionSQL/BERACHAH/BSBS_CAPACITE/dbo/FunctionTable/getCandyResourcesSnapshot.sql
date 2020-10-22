/****** Object:  Function [dbo].[getCandyResourcesSnapshot]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Riaan Engelbrecht
-- Create date: 09-02-2016
-- Description:	returns Candy Resources rolledback to a date
-- NOTES:
--  
-- =============================================
CREATE FUNCTION getCandyResourcesSnapshot (@theDate datetime)
    RETURNS @t TABLE (
  [ID] [int] NOT NULL,
	[ACTNUMBER] [nvarchar](10),
	[LEDGERCODE] [nvarchar](10),
	[BORG] [int] NOT NULL,
	[PROJECT] [int] NOT NULL,
	[CONTRACT] [int] NOT NULL,
	[CURRENCY] [nvarchar](3),
	[EXCHRATE] [decimal](23, 6),
	[SUPPCODE] [nvarchar](10),
	[CATEGORY] [nvarchar](55),
	[REMARK] [nvarchar](255),
	[RESCODE] [nvarchar](20),
	[DESCR] [ntext] NOT NULL,
	[RATE] [decimal] (18, 4),
	[UNIT] [nvarchar](15),
	[QTY] [decimal](22, 8),
	[ORDEREDAMOUNT] [decimal](18, 4),
	[ORDEREDQTY] [decimal](22, 8),
	[ORDEREDDISCOUNT] [decimal](18, 4),
	[PERIODUSAGE] [decimal](22, 8),
	[PERIODWASTE] [decimal](22, 8),
	[FINALUSAGE] [decimal](22, 8),
	[FINALWASTE] [decimal](22, 8),	
	[COSTRATE] [decimal](22, 8),
	[COSTQTY] [decimal](22, 8),
	[COSTWASTE] [decimal](22, 8),
	[BILLUSAGE] [decimal](22, 8),	
	[BILLWASTE] [decimal](22, 8),	
	[ACTUALUSAGE] [decimal](22, 8),
	[ACTUALWASTE] [decimal](22, 8),
	[CLAIMUSAGE] [decimal](22, 8),
	[PAIDUSAGE] [decimal](22, 8),
	[USERUSAGE] [decimal](22, 8),
	[USERWASTE] [decimal](22, 8),
	[VOAPPFINALUSAGE] [decimal](22, 8),
	[VOAPPACTUALUSAGE] [decimal](22, 8),
	[VOAPPCLAIMUSAGE] [decimal](22, 8),
	[VOUNAPPFINALUSAGE] [decimal](22, 8),
	[VOUNAPPACTUALUSAGE] [decimal](22, 8),
	[SYSDATE] [datetime] NOT NULL
  )
AS
BEGIN
    insert into @t
	select CR.ID, 
	CR.ACTNUMBER, 
	CR.LEDGERCODE, 
	CR.BORG, 
	CR.PROJECT, 
	CR.CONTRACT, 
	CR.CURRENCY, 
	CR.EXCHRATE, 
	CR.SUPPCODE, 
	CR.CATEGORY, 
	CR.REMARK, 
	CR.RESCODE, 
	CR.DESCR, 
	CR.RATE, 
	CR.UNIT, 
	CR.QTY, 
	CR.ORDEREDAMOUNT, 
	CR.ORDEREDQTY, 
	CR.ORDEREDDISCOUNT, 
	CR.PERIODUSAGE, 
	CR.PERIODWASTE, 
	CR.FINALUSAGE, 
	CR.FINALWASTE, 
	CR.COSTRATE, 
	CR.COSTQTY, 
	CR.COSTWASTE, 
	CR.BILLUSAGE, 
	CR.BILLWASTE, 
	CR.ACTUALUSAGE, 
	CR.ACTUALWASTE, 
	CR.CLAIMUSAGE, 
	CR.PAIDUSAGE, 
	CR.USERUSAGE, 
	CR.USERWASTE,
	CR.VOAPPFINALUSAGE, 
	CR.VOAPPACTUALUSAGE, 
	CR.VOAPPCLAIMUSAGE, 
	CR.VOUNAPPFINALUSAGE,
	CR.VOUNAPPACTUALUSAGE, 
	CR.SYSDATE
	FROM CANDY_RESOURCES AS CR
	OUTER APPLY (SELECT MIN(CRS.SYSDATE) SYSDATE, CRS.ID FROM CANDY_RESOURCESSNAPSHOT CRS WHERE CRS.SYSDATE > @theDate AND CRS.ID = CR.ID GROUP BY CRS.ID) CRSD
	LEFT OUTER JOIN CANDY_RESOURCESSNAPSHOT CRS ON CR.ID = CRSD.ID AND CR.SYSDATE = CRSD.SYSDATE
    WHERE CR.SYSDATE <= @theDate
    
	RETURN
END
		
		