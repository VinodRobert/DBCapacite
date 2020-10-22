/****** Object:  Function [dbo].[getSnapshotCommittedCost]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Riaan Engelbrecht
-- Create date: 09-06-2016
-- Description:	returns Snapshot Committed Cost
-- NOTES:
--  
-- =============================================
CREATE FUNCTION [dbo].[getSnapshotCommittedCost] (@snapshotId int)
    RETURNS @t TABLE (
	  [Activity Number]	nvarchar(10),
	  [Activity Name] nvarchar(100),	
	  [Ledger Code] nvarchar(10),	
	  [Ledger Name] nvarchar(35),	
	  [Project Number] nvarchar(10),	
	  [Project Name] nvarchar(50),	
	  [Contract Number]	nvarchar(20),
	  [Contract Name] nvarchar(50),	
	  [Order Number] nvarchar(50),	
	  [PO Status] nvarchar(50),	
	  [Created Date] nvarchar(50),	
	  [Line Number] nvarchar(50),
	  [Item Description] nvarchar(255),	
	  [Unit] nvarchar(25),	
	  [Qty] numeric(23,4),	
	  [Allocation] nvarchar(50),
	  [Amount] money,
	  [Delivered Qty] numeric(23,4),
	  [CONTROLTYPE] nvarchar(50)
  )
AS
BEGIN

	declare @projName as nvarchar(50);
	declare @projNumber as nvarchar(10);
	declare @projId as int;
	declare @contrName as nvarchar(100);
	declare @accrualDate as datetime;
	declare @candyImportDate as datetime;
	declare @contrno as nvarchar(20);
	declare @currency nvarchar(3);
	declare @borgId int;	

	select @candyImportDate = CandyImportDate, @accrualDate = AccrualDate, @contrno = ContractNo, @borgId = OrgID from SNAPSHOTS where SNAPSHOTS.ID = @snapshotId;
	select @projId = PROJID, @contrName = CONTRNAME from Contracts where CONTRNUMBER = @contrno;
	select @projName = ProjName, @projNumber = ProjNumber from PROJECTS where PROJID = @projId;
	select @currency = CURRENCY from BORGS where BORGID = @borgId;
	
	declare @tempB TABLE  (
		borgid INT
		,Currency NVARCHAR(3) collate SQL_Latin1_General_CP1_CI_AS
		,conavcurr NUMERIC(18,7)
		,conperc NUMERIC(18,4)
	);

	INSERT INTO @tempB (
		BorgId
		,currency
		,conavcurr
		,conperc
		)
	SELECT BorgId
		,currency
		,1
		,100
	FROM BORGS
	LEFT OUTER JOIN PERCS ON PERCS.ParentID = @borgId
		AND PERCS.OrgID = BORGS.BorgID
	WHERE BOrgid = @borgId

	DELETE
	FROM @tempB
	WHERE conperc = 0
	OR conavcurr = 0;

	declare @tempContractYear table
	(
		TCYYEAR char(10),
		TCYCONTRACT nvarchar(10)
	);

	insert into @tempContractYear
	SELECT Min(T.Year) as TCYYEAR, T.Contract as TCYCONTRACT
	FROM Transactions T
	WHERE T.orgid = @borgId
	GROUP BY T.Contract;

    insert into @t
    SELECT rtrim(isnull(Activities.ActNumber, '')) as [Activity Number], rtrim(Activities.ActName) as [Activity Name]
	,LC.Ledgercode AS [Ledger Code], LC.Ledgername as [Ledger Name]
	,PROJECTS.Projnumber AS [Project Number]
	,PROJECTS.Projname AS [Project Name]
	,Contracts.CONTRNUMBER AS [Contract Number]
	,Contracts.Contrname AS [Contract Name]
	,ORD.ORDNUMBER AS [Order Number]
	,(CASE ORD.ORDSTATUSID WHEN 274 THEN 'PO Ready' WHEN 37 THEN 'Cancelled' WHEN 41 THEN 'Completed Only' WHEN 500 THEN 'Change Order Process' END) as [PO Status]
	,CREATEDATE AS [Created Date]
	,ORDITEMS.LINENUMBER AS [Line Number]
	,ORDITEMS.ITEMDESCRIPTION AS [Item Description]
	,rtrim(Orditems.Uom) AS [Unit]
	,ORDITEMS.QTY - isnull(DL.QTY, 0) AS [Qty]
	,ORDITEMS.ALLOCATION AS [Allocation]
	,(((ORDITEMS.QTY - isnull(DL.QTY, 0)) * (ORDITEMS.PRICE * (1 - (ORDITEMS.DISCOUNT / 100)) + RA.RAVAL)) + MT.REIMBTAX) * CASE 
		WHEN (
				ORD.CURRENCY <> tempB.Currency
				AND ORD.HOMECURRENCY = tempB.Currency
				)
			THEN ORD.EXCHRATE
		WHEN ORD.CURRENCY = EXR.CURRCODE
			THEN EXR.RATE
		ELSE 1
		END AS [Amount]
	,isnull(DL.QTY, 0) AS [Delivered Qty]
	,LC.CONTROLTYPE	
	FROM ORD
	INNER JOIN ORDITEMS ON Ord.Ordid = Orditems.Ordid
	LEFT OUTER JOIN CONTRACTSALLOWED CONTRACTS ON ORDITEMS.CONTRACTID = CONTRACTS.CONTRID
		AND CONTRACTS.USERID = 23
	LEFT OUTER JOIN PROJECTS ON PROJECTS.PROJID = CONTRACTS.PROJID
	INNER JOIN @tempB as tempB ON ISNULL(ISNULL(ORDITEMS.TBORGID, PROJECTS.BORGID), ORD.BORGID) = tempB.borgid
	OUTER APPLY (
		SELECT TOP 1 CASE 
				WHEN borgs.currency = @currency
					THEN 1
				ELSE isnull(currexch.rate, tempB.conavcurr)
				END AS RATE
		FROM BORGS
		LEFT OUTER JOIN currexch ON currexch.groupid = borgs.currexgrp
			AND currexch.fromcurr = borgs.currency
			AND currexch.tocurr = @currency
			AND startdate <= ORD.createdate
		WHERE borgs.borgid = ISNULL(ISNULL(ORDITEMS.TBORGID, PROJECTS.BORGID), ORD.BORGID)
		ORDER BY startdate DESC
		) R
	LEFT OUTER JOIN inventory ON orditems.StockID = inventory.StkID
	LEFT OUTER JOIN activities ON orditems.actID = activities.actID
	INNER JOIN Ledgercodes LC ON Orditems.GlcodeID = LC.LedgerID
	LEFT OUTER JOIN SUPPLIERS ON ORD.SUPPID = SUPPLIERS.SUPPID
	CROSS APPLY (
		SELECT isnull(SUM(round(RIA.VALUE / OI.QTY, 4)), 0) RAVAL
		FROM ORD O
		INNER JOIN ORDITEMS OI ON O.ORDID = OI.ORDID
		INNER JOIN REQITEMSADD RIA ON RIA.LINENUMBER = OI.LINENUMBER
			AND RIA.REQID = O.REQID
		INNER JOIN REQADD ON RIA.RAID = REQADD.RAID
		WHERE REQADD.ISCOST = 1
			AND OI.ORDID = ORDITEMS.ORDID
			AND OI.LINENUMBER = ORDITEMS.LINENUMBER
            AND OI.QTY <> 0
		) RA
	OUTER APPLY (
		SELECT RTrim(CURR.CURRCODE) CURRCODE
			,isnull(CCEE.RATE, - 1) AS RATE
			,isnull(CURR.DECIMALS, 2) DECIMALS
		FROM CURRENCIES CURR
		INNER JOIN (
			SELECT CCE.FROMCURR
				,CCE.RATE
			FROM BORGS B
			INNER JOIN CURREXCH CCE ON CCE.GROUPID = B.CURREXGRP
				AND B.CURRENCY = CCE.TOCURR
			INNER JOIN CURREXCHGRP CCG ON CCE.GROUPID = CCG.GROUPID
			INNER JOIN (
				SELECT GROUPID
					,FROMCURR
					,TOCURR
					,MAX(STARTDATE) AS STARTDATE
				FROM CURREXCH C
				GROUP BY GROUPID
					,FROMCURR
					,TOCURR
				) ce ON CCE.GROUPID = ce.groupid
				AND CCE.FROMCURR = ce.fromcurr
				AND CCE.TOCURR = ce.tocurr
				AND CCE.STARTDATE = ce.startdate
			WHERE B.BORGID = ISNULL(ISNULL(ORDITEMS.TBORGID, PROJECTS.BORGID), ORD.BORGID)
				AND CCG.DISABLED = 0
			) CCEE ON CCEE.FROMCURR = CURR.CURRCODE
		WHERE CURR.CURRCODE = ORD.CURRENCY
		) EXR
	OUTER APPLY (
		SELECT CASE 
				WHEN SUM(D.DLVRQTY) > OI.QTY
					THEN OI.QTY
				ELSE SUM(D.DLVRQTY)
				END QTY
			,D.ORDID
			,D.ORDITEMLINENO
		FROM DELIVERIES D
		INNER JOIN ORDITEMS OI ON D.ORDID = OI.ORDID
			AND D.ORDITEMLINENO = OI.LINENUMBER
		WHERE D.ORDID = ORDITEMS.ORDID
			AND D.ORDITEMLINENO = ORDITEMS.LINENUMBER
		GROUP BY D.ORDID
			,D.ORDITEMLINENO
			,OI.QTY
		) DL
  OUTER APPLY(SELECT ISNULL(SUM(ISNULL(TAX, 0)), 0) REIMBTAX FROM GETVIEWTAXTRANS('', ((ORDITEMS.QTY - isnull(DL.QTY, 0)) * ORDITEMS.PRICE) * (1 - (Orditems.Discount / 100)), ORDITEMS.VATID, ISNULL(ISNULL(ORDITEMS.TBORGID, PROJECTS.BORGID), ORD.BORGID), Ord.Currency) WHERE ISNULL(ISREIMB, -1) = 0) MT
	WHERE OrdItems.Allocation = 'Contracts'
		AND (ORDITEMS.QTY - isnull(DL.QTY, 0)) <> 0
		AND isnull(ORDITEMS.TBORGID, ord.borgid) = @borgId
		AND (Contracts.ContrNumber = @contrno)
		AND ORD.ORDSTATUSID IN (274) 
		AND ORD.ORDSTATUSID > 2

	RETURN
END
		
		