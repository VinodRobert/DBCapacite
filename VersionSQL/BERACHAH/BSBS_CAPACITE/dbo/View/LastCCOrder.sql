/****** Object:  View [dbo].[LastCCOrder]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.LastCCOrder AS SELECT     TOP 100 PERCENT dbo.empccid.CCID, dbo.empccid.PAYROLLID, dbo.empccid.EMPNUMBER, dbo.CLOCKCARDS.CONTRNUMBER AS CCContrnum,  dbo.CLOCKCARDS.ALLOCATION AS CCAllocation, dbo.CLOCKCARDS.DIVID AS CCDivid, dbo.CLOCKCARDS.LEDGERCODE AS CCLedger, dbo.CLOCKCARDS.PENUMBER AS CCPENumber, dbo.EMPLOYEES.DEFCONTRNUM AS DEFContrnum, dbo.EMPLOYEES.DEFPLANT AS DEFPENumber,  dbo.EMPLOYEES.DEFLEDGERCODE AS DEFLedger, dbo.EMPLOYEES.DEFDIVISIONID AS DEFDivid, dbo.EMPLOYEES.DEFCOSTALLOC AS DEDFAllocation , dbo.empccid.SumOT5, dbo.empccid.SumOT4, dbo.empccid.SumOT3, dbo.empccid.SumOT2, dbo.empccid.SumOT1, dbo.empccid.SumNT, dbo.empccid.Sumshifts , dbo.empccid.RUNNO, dbo.empccid.PERIODNO, dbo.empccid.YEARNO FROM         dbo.empccid INNER JOIN dbo.CLOCKCARDS ON dbo.empccid.CCID = dbo.CLOCKCARDS.CCID INNER JOIN dbo.EMPLOYEES ON dbo.empccid.EMPNUMBER = dbo.EMPLOYEES.EMPNUMBER AND dbo.empccid.PAYROLLID = dbo.EMPLOYEES.PAYROLLID ORDER BY dbo.empccid.EMPNUMBER 