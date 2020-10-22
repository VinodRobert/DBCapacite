/****** Object:  Function [dbo].[getSnapshotCandyResources]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Riaan Engelbrecht
-- Create date: 29-06-2016
-- Description:	returns Snapshot Candy Resources
-- NOTES:
--  
-- =============================================
create FUNCTION [dbo].[getSnapshotCandyResources] (@snapshotId int)
    RETURNS @t TABLE (
	    [Activity Number]	nvarchar(100) collate SQL_Latin1_General_CP1_CI_AS,
	    [Activity Name] nvarchar(100) collate SQL_Latin1_General_CP1_CI_AS,	
	    [Ledger Code] nvarchar(100) collate SQL_Latin1_General_CP1_CI_AS,	
	    [Ledger Name] nvarchar(35) collate SQL_Latin1_General_CP1_CI_AS,	
	    [Project Number] nvarchar(10) collate SQL_Latin1_General_CP1_CI_AS,	
	    [Project Name] nvarchar(50) collate SQL_Latin1_General_CP1_CI_AS,	
	    [Contract Number]	nvarchar(20) collate SQL_Latin1_General_CP1_CI_AS,
	    [Contract Name] nvarchar(50) collate SQL_Latin1_General_CP1_CI_AS,	
	    [Resource Code] nvarchar(50) collate SQL_Latin1_General_CP1_CI_AS,	
	    [Description] nvarchar(255) collate SQL_Latin1_General_CP1_CI_AS,	
	    [Unit] nvarchar(15) collate SQL_Latin1_General_CP1_CI_AS,	
	    [Rate] decimal(18,4),	
	    [Qty]	decimal(22,8),
	    [Ordered Qty] decimal(22,8),
	    [Ordered Amount] decimal(18,4),
	    [Delivered Qty] decimal(22,8),	
	    [Period Qty] decimal(22,8),	
	    [Period Waste] decimal(23,4),	
	    [Final Waste] decimal(23,4),	
	    [Cost Qty] decimal(23,4),	
	    [Cost Rate] decimal(23,4),	
	    [Cost Waste] decimal(23,4),	
	    [Bill Qty] decimal(23,4),	
	    [Bill Waste] decimal(23,4),	
	    [Actual Usage] decimal(22,8),	
	    [Actual Waste] decimal(22,8),
	    [Paid Qty] decimal(22,8),	
	    [Claim Qty] decimal(22,8),	
	    [User Usage] decimal(22,8),	
	    [User Waste] decimal(22,8),	
	    [Category] nvarchar(55) collate SQL_Latin1_General_CP1_CI_AS,	
	    [Remark] nvarchar(255) collate SQL_Latin1_General_CP1_CI_AS,	
	    [Currency] nvarchar(3) collate SQL_Latin1_General_CP1_CI_AS,	
	    [EXCHRATE] decimal(23,6),	
	    [Supplier] nvarchar(50) collate SQL_Latin1_General_CP1_CI_AS,	
	    [Ordered Discount] decimal(18,4),	
	    [CONTROLTYPE] nvarchar(50) collate SQL_Latin1_General_CP1_CI_AS,
	    [VOAPPFINALUSAGE] decimal(22,8),	
	    [VOAPPACTUALUSAGE] decimal(22,8),
	    [VOAPPCLAIMUSAGE] decimal(22,8),	
	    [VOUNAPPFINALUSAGE] decimal(22,8),	
	    [VOUNAPPACTUALUSAGE] decimal(22,8),
      [COSTREMACTUALUSAGE] decimal(22,8)
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
	declare @createdDate datetime;
	declare @year char(10);
	declare @period int;
	declare @costsOnly bit;

	declare  @tmpCommittedCosts table (
	[Activity Number]	nvarchar(10) collate SQL_Latin1_General_CP1_CI_AS,
	[Activity Name] nvarchar(100) collate SQL_Latin1_General_CP1_CI_AS,	
	[Ledger Code] nvarchar(10) collate SQL_Latin1_General_CP1_CI_AS,	
	[Ledger Name] nvarchar(35) collate SQL_Latin1_General_CP1_CI_AS,	
	[Project Number] nvarchar(10) collate SQL_Latin1_General_CP1_CI_AS,	
	[Project Name] nvarchar(50) collate SQL_Latin1_General_CP1_CI_AS,	
	[Contract Number]	nvarchar(20) collate SQL_Latin1_General_CP1_CI_AS,
	[Contract Name] nvarchar(50) collate SQL_Latin1_General_CP1_CI_AS,	
	[Order Number] nvarchar(50) collate SQL_Latin1_General_CP1_CI_AS,	
	[PO Status] nvarchar(50) collate SQL_Latin1_General_CP1_CI_AS,		
	[Unit] nvarchar(25) collate SQL_Latin1_General_CP1_CI_AS,	
	[Qty] numeric(23,4), /* Ordered Qty	*/
	[Amount] money, /* Ordered Amount inc. discount received or allowed */
	[Delivered Qty] numeric(23,4),
	[RESOURCECODE] nvarchar(25),
	[ORDEREDDISCOUNT] numeric(23,4),
	[CONTROLTYPE] nvarchar(50) collate SQL_Latin1_General_CP1_CI_AS,
	[RATE] numeric(23,4)
	);
	
	select @createdDate = CreatedDate, @candyImportDate = CandyImportDate, @accrualDate = AccrualDate, @contrno = ContractNo, @borgId = OrgID, @year = [Year], @period = Period, @costsOnly = CostsOnly from SNAPSHOTS where SNAPSHOTS.ID = @snapshotId;
	select @projId = PROJID, @contrName = CONTRNAME from Contracts where CONTRNUMBER = @contrno;
	select @projName = ProjName, @projNumber = ProjNumber from PROJECTS where PROJID = @projId;
	select @currency = CURRENCY from BORGS where BORGID = @borgId;

	/* Get Committed Costs */
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
	LEFT OUTER JOIN PERCS ON PERCS.ParentID = 5
		AND PERCS.OrgID = BORGS.BorgID
	WHERE BOrgid = 5

	DELETE
	FROM @tempB
	WHERE conperc = 0
	OR conavcurr = 0;

	declare @tempContractYear table
	(
		TCYYEAR char(10) collate SQL_Latin1_General_CP1_CI_AS,
		TCYCONTRACT nvarchar(10) collate SQL_Latin1_General_CP1_CI_AS
	);

	insert into @tempContractYear
	SELECT Min(T.Year) as TCYYEAR, T.Contract as TCYCONTRACT
	FROM Transactions T
	WHERE T.orgid = 5
	GROUP BY T.Contract;

	insert into @tmpCommittedCosts
	SELECT rtrim(isnull(Activities.ActNumber, '')) as [Activity Number]
	,rtrim(Activities.ActName) as [Activity Name]
	,LC.Ledgercode AS [Ledger Code]
	,LC.Ledgername as [Ledger Name]
	,PROJECTS.Projnumber AS [Project Number]
	,PROJECTS.Projname AS [Project Name]
	,Contracts.CONTRNUMBER AS [Contract Number]
	,Contracts.Contrname AS [Contract Name]
	,ORD.ORDNUMBER AS [Order Number]
	,(CASE ORD.ORDSTATUSID WHEN 274 THEN 'PO Ready' WHEN 37 THEN 'Cancelled' WHEN 41 THEN 'Completed Only' WHEN 500 THEN 'Change Order Process' END) as [PO Status]
	,rtrim(Orditems.Uom) AS [Unit]
	,SUM(isnull(ORDITEMS.QTY, 0) - isnull(DL.QTY, 0)) AS [Qty]
	,SUM((ORDITEMS.QTY - isnull(DL.QTY, 0)) * (ORDITEMS.PRICE * (1 - (ORDITEMS.DISCOUNT / 100)) + RA.RAVAL) * CASE 
		WHEN (
				ORD.CURRENCY <> tempB.Currency
				AND ORD.HOMECURRENCY = tempB.Currency
				)
			THEN ORD.EXCHRATE
		WHEN ORD.CURRENCY = EXR.CURRCODE
			THEN EXR.RATE
		ELSE 1
		END) AS [Amount]
	,SUM(isnull(DL.QTY, 0)) AS [Delivered Qty]
	,ORDITEMS.RESOURCECODE
	,SUM(isnull(ORDITEMS.DISCOUNT, 0)) as [DISCOUNT]
	,LC.CONTROLTYPE	
	,0 as [RATE]
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
	WHERE OrdItems.Allocation = 'Contracts'
		AND (ORDITEMS.QTY - isnull(DL.QTY, 0)) <> 0
		AND isnull(ORDITEMS.TBORGID, ord.borgid) = @borgId
		AND (Contracts.ContrNumber = @contrno)
		AND ORD.ORDSTATUSID IN (274) 
		AND ORDITEMS.CATORTENDITEM = 1
		AND ORD.ORDSTATUSID > 2
		group by Activities.ActNumber
		,Activities.ActName
		,LC.Ledgercode
		,LC.Ledgername
		,PROJECTS.Projnumber
		,PROJECTS.Projname
		,Contracts.CONTRNUMBER
		,Contracts.Contrname
		,ORD.ORDNUMBER
		,ORD.ORDSTATUSID
		,Orditems.Uom
		,ORDITEMS.RESOURCECODE
		,LC.CONTROLTYPE;

	insert into @t
	select tmp.[Activity Number], tmp.[Activity Name], tmp.[Ledger Code], tmp.[Ledger Name], 
	tmp.[Project Number],  tmp.[Project Name], tmp.[Contract Number], tmp.[Contract Name], 
	tmp.RESOURCECODE as [Resource Code], '' as [Description], ISNULL(CR2.UNIT, tmp.[Unit]), ISNULL(CR2.RATE, 0) as [Rate], 
	0 as [Qty], tmp.[Qty] as [Ordered Qty], tmp.Amount as [Ordered Amount], tmp.[Delivered Qty], 0 as [Period Qty], 
	0 as [Period Waste], 0 as [Final Waste], 0 as [Cost Qty], 0 as [Cost Rate], 
	0 as [Cost Waste], 0 as [Bill Qty], 0 as [Bill Waste], 0 as [Actual Usage], 
	0 as [Actual Waste], 0 as [Paid Qty], 0 as [Claim Qty], 0 as [User Usage], 
	0 as [User Waste], 'BSUNMATCHED' as [Category], '' as [Remark], '' as [Currency],
	0 as EXCHRATE, ISNULL(CR2.SUPPCODE, '') as [Supplier], ISNULL(tmp.ORDEREDDISCOUNT, 0) as [Ordered Discount], tmp.CONTROLTYPE, 
	0 as [VOAPPFINALUSAGE], 0 as [VOAPPACTUALUSAGE], 0 as [VOAPPCLAIMUSAGE],
	0 as [VOUNAPPFINALUSAGE], 0 as [VOUNAPPACTUALUSAGE], 0 as [COSTREMACTUALUSAGE]
	from @tmpCommittedCosts tmp
	full outer join (
		select * from CANDY_RESOURCES where SYSDATE = (
			select CandyImportDate from SNAPSHOTS
			where ID = @snapshotId
		)
	) CR on CR.ACTNUMBER = tmp.[Activity Number] 
	and CR.LEDGERCODE = tmp.[Ledger Code] 
	and CR.RESCODE = tmp.RESOURCECODE collate SQL_Latin1_General_CP1_CI_AS
	left outer join (
		select * from CANDY_RESOURCES where SYSDATE = (
			select CandyImportDate from SNAPSHOTS
			where ID = @snapshotId
		)
	) CR2 on CR2.LEDGERCODE = tmp.[Ledger Code] 
	and CR2.RESCODE = tmp.RESOURCECODE collate SQL_Latin1_General_CP1_CI_AS
	where CR.ACTNUMBER is null;


	insert into @t
	select candyresources.ACTNUMBER as [Activity Number], act.ACTNAME as [Activity Name], candyresources.LEDGERCODE as [Ledger Code], lc.LEDGERNAME as [Ledger Name], 
	@projNumber as [Project Number],  @projName as [Project Name], contr.CONTRNUMBER as [Contract Number], @contrName as [Contract Name], 
	candyresources.RESCODE as [Resource Code], candyresources.DESCR as [Description], candyresources.UNIT as [Unit], candyresources.RATE as [Rate], 
	candyresources.QTY as [Qty], ISNULL(tmp.[Qty], candyresources.ORDEREDQTY) as [Ordered Qty], ISNULL(tmp.[Amount], candyresources.ORDEREDAMOUNT) as [Ordered Amount], ISNULL(tmp.[Delivered Qty], 0) as [Delivered Qty], candyresources.PERIODUSAGE as [Period Qty], 
	candyresources.PERIODWASTE as [Period Waste], candyresources.FINALWASTE as [Final Waste], candyresources.COSTQTY as [Cost Qty], candyresources.COSTRATE as [Cost Rate], 
	candyresources.COSTWASTE as [Cost Waste], candyresources.BILLUSAGE as [Bill Qty], candyresources.BILLWASTE as [Bill Waste], candyresources.ACTUALUSAGE as [Actual Usage], 
	candyresources.ACTUALWASTE as [Actual Waste], candyresources.PAIDUSAGE as [Paid Qty], candyresources.CLAIMUSAGE as [Claim Qty], candyresources.USERUSAGE as [User Usage], 
	candyresources.USERWASTE as [User Waste], candyresources.CATEGORY as [Category], candyresources.REMARK as [Remark], candyresources.CURRENCY as [Currency],
	candyresources.EXCHRATE, candyresources.SUPPCODE as [Supplier], candyresources.ORDEREDDISCOUNT as [Ordered Discount], lc.CONTROLTYPE, 
	candyresources.VOAPPFINALUSAGE as [VOAPPFINALUSAGE], candyresources.VOAPPACTUALUSAGE as [VOAPPACTUALUSAGE], candyresources.VOAPPCLAIMUSAGE as [VOAPPCLAIMUSAGE],
	candyresources.VOUNAPPFINALUSAGE as [VOUNAPPFINALUSAGE], candyresources.VOUNAPPACTUALUSAGE as [VOUNAPPACTUALUSAGE], candyresources.COSTREMACTUALUSAGE as [COSTREMACTUALUSAGE] 
	from CANDY_RESOURCES candyresources
    inner join Contracts contr on contr.CONTRID = candyresources.CONTRACT
    /*inner join PROJECTS proj on proj.PROJID = candyresources.PROJECT*/
    left outer join ACTIVITIES act on act.ActNumber = cast(candyresources.ACTNUMBER as char(10))
    left outer join LEDGERCODES lc on lc.LedgerCode = cast(candyresources.LEDGERCODE as char(10))
	left outer join @tmpCommittedCosts tmp
	on candyresources.ACTNUMBER = tmp.[Activity Number]
	and candyresources.LEDGERCODE = tmp.[Ledger Code] 
	and candyresources.RESCODE = tmp.RESOURCECODE collate SQL_Latin1_General_CP1_CI_AS
    where contr.CONTRNUMBER = @contrno
    and candyresources.SYSDATE = @candyImportDate;

	RETURN
END
		
		