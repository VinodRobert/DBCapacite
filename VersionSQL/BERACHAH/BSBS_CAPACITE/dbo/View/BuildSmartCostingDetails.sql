/****** Object:  View [dbo].[BuildSmartCostingDetails]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW BuildSmartCostingDetails AS SELECT  	ed.PRLID, 	ed.PERIODNO, 	ed.YEARNO, 	ped.PENDDATE, 	ed.EMPNUMBER, 	ed.THEMONEY, 	ed.MONEYTAXABLE, 	eds.TAXPERC, 	eds.EDSCODE, 	eds.IRP5CODE, 	eds.ISWCA, 	eds.ISSTAMP, 	eds.ISUIF, 	eds.ISEQUITY, 	eds.USEIT, 	eds.COSTIT FROM EDSETS eds INNER JOIN EMPED ed ON eds.PAYROLLID = ed.PRLID AND eds.EDSNUMBER = ed.EDSNUMBER AND eds.EDSHID = ed.EDSHID INNER JOIN PERIODENDDATES ped ON ed.PRLID = ped.PAYROLLID AND ed.PERIODNO = ped.PERIODNO AND ed.YEARNO = ped.YEARNO 