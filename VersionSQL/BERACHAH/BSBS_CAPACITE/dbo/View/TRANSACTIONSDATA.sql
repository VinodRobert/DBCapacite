/****** Object:  View [dbo].[TRANSACTIONSDATA]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW TRANSACTIONSDATA as 

SELECT T.OrgID, T.Year, T.Period, case when isnull(P.ISYEAREND, -1) = -1 then 'Period undefined' else P.DESCR end PeriodName, 
T.PDate, T.BatchRef, T.TransRef, T.MatchRef, T.TransType, T.Allocation, T.LedgerCode, LEDGERCODES.CONTROLTYPE, CONTROLCODES.CONTROLNAME, T.Contract, T.Activity, T.Description, T.ForeignDescription, T.Currency, T.Debit, T.Credit, 
T.VatDebit, T.VatCredit, T.Credno, T.Store, T.Plantno, T.Stockno, T.Quantity, T.Unit, T.Rate, T.ReqNo, T.OrderNo, T.Age, T.TransID, T.SubConTran, T.VATType, A.AMOUNT HOMECURRAMOUNT, T.ConversionDate, 
T.ConversionRate, T.PaidFor, T.PaidToDate, T.PaidThisPeriod, T.WhtThisPeriod, T.DiscThisPeriod, T.ReconStatus, T.UserID, T.DivID, T.ForexVal, T.HeadID, T.XGLCODE, T.XVATA, T.XVATT, T.DOCNUMBER, 
T.WHTID, T.FBID, T.TERM, T.SYSDATE, T.RECEIVEDDATE, T.ORIGTRANSID, T.HCTODATE, T.TRANGRP, T.ROLLEDFWD
FROM TRANSACTIONS AS T 
INNER JOIN BORGS AS B ON T.OrgID = B.BORGID
INNER JOIN LEDGERCODES ON T.LEDGERCODE = LEDGERCODES.LEDGERCODE 
OUTER APPLY (SELECT TOP 1 CONTROLCODES.CONTROLNAME FROM CONTROLCODES WHERE LEDGERCODES.LEDGERCODE BETWEEN CONTROLCODES.CONTROLFROMGL AND CONTROLCODES.CONTROLTOGL ORDER BY CONTROLCODES.CONTROLFROMGL) CONTROLCODES
LEFT OUTER JOIN CONTROLCODES CR ON T.LEDGERCODE = CR.CONTROLFROMGL and CR.CONTROLNAME = 'Retained Income'
LEFT OUTER JOIN CONTROLCODES CW ON T.LEDGERCODE = CW.CONTROLFROMGL and CW.CONTROLNAME = 'Work In Progress'
LEFT OUTER JOIN PERIODSETUP P on P.ORGID = T.OrgID and P.YEAR = T.YEAR and P.PERIOD = T.PERIOD
OUTER APPLY (select CASE WHEN T.CURRENCY = B.CURRENCY THEN DEBIT - CREDIT ELSE CASE WHEN DEBIT - CREDIT > 0 THEN HOMECURRAMOUNT ELSE -1 * HOMECURRAMOUNT END END as AMOUNT) A
WHERE isnull(CR.CONTROLNAME, '') = ''
AND isnull(CW.CONTROLNAME, '') = ''

 