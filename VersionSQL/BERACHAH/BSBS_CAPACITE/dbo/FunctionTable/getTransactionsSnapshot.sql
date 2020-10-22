/****** Object:  Function [dbo].[getTransactionsSnapshot]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Matthew Spiller
-- Create date: 09-08-2015
-- Description:	returns transactions rolledback to a date
-- NOTES:
--  
-- =============================================
CREATE FUNCTION getTransactionsSnapshot (@theDate datetime, @OrgId int, @year int, @alloc nvarchar(15))
    RETURNS @t TABLE (
    [OrgID] [int] NOT NULL,
    [Year] [nvarchar](10) NOT NULL,
    [Period] [int] NOT NULL,
    [PDate] [datetime] NULL,
    [BatchRef] [nvarchar](10) NOT NULL,
    [TransRef] [nvarchar](10) NOT NULL,
    [MatchRef] [nvarchar](10) NOT NULL,
    [TransType] [nvarchar](10) NOT NULL,
    [LedgerCode] [nvarchar](10) NOT NULL,
    [Contract] [nvarchar](10) NOT NULL,
    [Activity] [nvarchar](10) NOT NULL,
    [Description] [nvarchar](255) NOT NULL,
    [Currency] [nvarchar](3) NOT NULL,
    [Debit] [money] NOT NULL,
    [Credit] [money] NOT NULL,
    [VatDebit] [money] NOT NULL,
    [VatCredit] [money] NOT NULL,
    [Credno] [nvarchar](10) NOT NULL,
    [Store] [nvarchar](20) NOT NULL,
    [Plantno] [nvarchar](10) NOT NULL,
    [Stockno] [nvarchar](20) NOT NULL,
    [Quantity] [numeric](23, 4) NOT NULL,
    [Rate] [money] NOT NULL,
    [Age] [int] NOT NULL,
    [TransID] [int] NOT NULL,
    [VATType] [char](2) NOT NULL,
    [HomeCurrAmount] [money] NULL,
    [ConversionDate] [datetime] NULL,
    [ConversionRate] [money] NOT NULL,
    [PaidFor] [bit] NOT NULL,
    [PaidToDate] [money] NOT NULL,
    [PaidThisPeriod] [money] NOT NULL,
    [WhtThisPeriod] [money] NOT NULL,
    [DiscThisPeriod] [money] NOT NULL,
    [ReconStatus] [int] NOT NULL,
    [UserID] [nvarchar](10) NULL,
    [DivID] [int] NOT NULL,
    [ForexVal] [money] NOT NULL,
    [HeadID] [char](10) NULL,
    [WHTID] [int] NULL,
    [FBID] [int] NULL,
    [TERM] [int] NULL,
    [SYSDATE] [datetime] NULL,
    [RECEIVEDDATE] [datetime] NULL,
    [ORIGTRANSID] [int] NULL,
    [HCTODATE] [numeric](18, 4) NULL,
    [TRANGRP] [int] NULL,
    [REQNO] [varchar](55) NOT NULL,
    [ORDERNO] [varchar](55) NOT NULL,
    [FOREIGNDESCRIPTION] [varchar](255) NOT NULL,
    [ALLOCATION] [varchar](15) NOT NULL,
    [DOCNUMBER] [varchar](50) NULL,
    [UNIT] [varchar](10) NOT NULL,
    [SUBCONTRAN] [varchar](20) NOT NULL,
    [XGLCODE] [nvarchar](10) NOT NULL,
    [XVATA] [money] NOT NULL,
    [XVATT] [char](2) NOT NULL,
    [ROLLEDFWD] [int] NULL,
    [TRANSREFEXT] [nvarchar](55) NULL, 
    [HOMECURRAMOUNTALT] [money] NULL
  )
AS
BEGIN
    insert into @t
    SELECT T.OrgID, T.Year, T.Period, T.PDate, T.BatchRef, T.TransRef, T.MatchRef, T.TransType, T.LedgerCode, T.Contract, T.Activity, T.Description, T.Currency, T.Debit, T.Credit, T.VatDebit, T.VatCredit, 
    T.Credno, T.Store, T.Plantno, T.Stockno, T.Quantity, T.Rate, T.Age, T.TransID, T.VATType, T.HomeCurrAmount, T.ConversionDate, T.ConversionRate, 
    isnull(TS.PaidFor, T.PaidFor) PaidFor, isnull(TS.PaidToDate, T.PaidToDate) PaidToDate, isnull(TS.PaidThisPeriod, T.PaidThisPeriod) PaidThisPeriod, T.WhtThisPeriod, T.DiscThisPeriod, 
    isnull(TS.ReconStatus, T.ReconStatus) ReconStatus, T.UserID, T.DivID, T.ForexVal, T.HeadID, T.WHTID, T.FBID, T.TERM,
    T.SYSDATE, T.RECEIVEDDATE, T.ORIGTRANSID, T.HCTODATE, T.TRANGRP, T.REQNO, T.ORDERNO, T.FOREIGNDESCRIPTION, T.ALLOCATION, 
    T.DOCNUMBER, T.UNIT, T.SUBCONTRAN, T.XGLCODE, T.XVATA, T.XVATT, T.ROLLEDFWD,
    T.TRANSREFEXT, T.HOMECURRAMOUNTALT
    FROM TRANSACTIONS AS T
    OUTER APPLY (SELECT MIN(TS.SYSDATE) SYSDATE, TS.TRANSID FROM TRANSACTIONSSNAPSHOT TS WHERE TS.SYSDATE > @theDate AND TS.TRANSID = T.TRANSID GROUP BY TS.TRANSID) TSD
    LEFT OUTER JOIN TRANSACTIONSSNAPSHOT TS ON T.TRANSID = TS.TRANSID AND TS.SYSDATE = TSD.SYSDATE
    WHERE T.SYSDATE <= @theDate 
    AND T.OrgID = @OrgId
	  AND T.[Year] = cast(@year as char(10))
	  AND T.Allocation = CASE WHEN @alloc = '' THEN T.Allocation ELSE cast(@alloc as char(25)) END

	RETURN
END
		
		