/****** Object:  Function [dbo].[ORDINVSUM]    Committed by VersionSQL https://www.versionsql.com ******/

Create function dbo.ORDINVSUM
	(
	@StartDate  nvarchar(10),
	@EndDate	nvarchar(10),
	@Org		nvarchar(200)
	)
	Returns @ORDINVSUM table
	(
	OrgID			int,
	OrdID			int,
	OrdNumber		nvarchar(55)  COLLATE SQL_Latin1_General_CP1_CI_AS,
	OrdType			nvarchar(10)  COLLATE SQL_Latin1_General_CP1_CI_AS,
	SuppCode		nvarchar(10)  COLLATE SQL_Latin1_General_CP1_CI_AS,
	SuppName		nvarchar(150)  COLLATE SQL_Latin1_General_CP1_CI_AS,
	CostAlloc		nvarchar(50)  COLLATE SQL_Latin1_General_CP1_CI_AS,
	CostCode		nvarchar(100)  COLLATE SQL_Latin1_General_CP1_CI_AS,
	OrdStatus		nvarchar(50)  COLLATE SQL_Latin1_General_CP1_CI_AS,
	Currency		nvarchar(3)  COLLATE SQL_Latin1_General_CP1_CI_AS,
	OrdValue		money,
	DelValue		money,
	DelUnRecValue	money,
	RecDelValue		money,
	PaidValue		money,
	UnpaidValue		money

	)
	as
	begin
	insert into @ORDINVSUM
	(
	OrgID,
	OrdID,
	OrdNumber,	
	OrdType,
	SuppCode,
	SuppName,	
	CostAlloc,	
	CostCode,	
	OrdStatus,	
	Currency,	
	OrdValue,
	DelValue,	
	DelUnRecValue,
	RecDelValue,	
	PaidValue,	
	UnpaidValue	
	)
	SELECT
	O.BORGID,
	O.ORDID,
	O.ORDNUMBER,
	O.RECTYPE,	
	S.SUPPCODE,
	S.SUPPNAME,
	'',	
	'',	
	case when O.ORDSTATUSID=37 then 'Cancelled' else case when O.ORDSTATUSID=41 then 'Completed' 
	else case when O.ORDSTATUSID=274 then 'PO Ready/Open' else case when O.ORDSTATUSID=500 then 'Change Order Pending' else '' end end end end,
	O.CURRENCY,
	sum(round((OI.QTY*OI.PRICE*((100-OI.DISCOUNT)/100))*(1+OI.VATPERC/100),2)),
	0,
	0,
	0,
	0,
	0
	From Ord O
	left outer join OrdItems OI on OI.ORDID=O.ORDID
	left outer join suppliers S on S.SUPPID=O.SUPPID
	where 
	O.BORGID in (select S.Items from dbo.Split(@Org, ',') S where S.Items is not null ) and
	O.CREATEDATE between convert(datetime,@StartDate,103)and  convert(datetime,@EndDate,103) AND O.RECTYPE='STD'
	group by S.SuppCode,O.BorgID,O.Ordid, O.ORDNUMBER,O.RECTYPE,S.SUPPNAME,O.CURRENCY,O.ORDSTATUSID,o.HOMECURRENCY,O.EXCHRATE

	update @ORDINVSUM
	set CostAlloc=C.C from (select count(distinct(Allocation)) C,Ordid ID from Orditems where ordid in (select ORDID from @ORDINVSUM) group by ORDID) C
	left outer join @ORDINVSUM on ORDID=C.ID

	Update @ORDINVSUM
	set CostAlloc='Multiple' where CostAlloc>1

	update @ORDINVSUM
	set CostAlloc=A.A from (select distinct(Allocation) A,Ordid ID from Orditems where ORDID in (select ORDID from @ORDINVSUM) group by ORDID,ALLOCATION) A
	left outer join @ORDINVSUM on ORDID=A.ID
	where CostAlloc='1'

	/*Set Contract Cost Codes*/
	update @ORDINVSUM
	set CostCode=CC.CC from (select count(DISTINCT(ContractID)) CC,ORDID ID from ORDITEMS where ordid in (select ordid from @ORDINVSUM where COSTALLOC='CONTRACTS') group by ORDID) CC
	left outer join @ORDINVSUM on ORDID=CC.ID
	where CostAlloc='Contracts'

	update @ORDINVSUM
	set CostCode='Multiple' where CostAlloc='Contracts' and CostCode>1

	update @ORDINVSUM
	set CostCode=CI.CI from (select distinct(ContractID) CI,ORDID ID from OrdItems where ordid in (select ordid from @ORDINVSUM where CostAlloc='Contracts' and CostCode='1') group by Ordid,ContractID) CI
	left outer join @ORDINVSUM on ORDID=CI.ID
	where CostCode<>'Multiple' and CostAlloc='Contracts'

	UPDATE @ORDINVSUM
	set CostCode=CN.CN from (select CONTRNUMBER+' - '+CONTRNAME as CN, CONTRID ID from CONTRACTS)CN
	left outer join @ORDINVSUM on CostCode=CN.ID
	where CostAlloc='Contracts' and CostCode<>'Multiple'

	/*Set Overhead Cost codes*/
	update @ORDINVSUM
	set CostCode=CC.CC from (select count(DISTINCT(DIVISIONID)) CC,ORDID ID from ORDITEMS where ordid in (select ordid from @ORDINVSUM where COSTALLOC='Overheads') group by ORDID) CC
	left outer join @ORDINVSUM on ORDID=CC.ID
	where CostAlloc='Overheads'

	update @ORDINVSUM
	set CostCode='Multiple' where CostAlloc='Overheads' and CostCode>1

	update @ORDINVSUM
	set CostCode=CI.CI from (select distinct(DIVISIONID) CI,ORDID ID from OrdItems where ordid in (select ordid from @ORDINVSUM where CostAlloc='Overheads' and CostCode='1') group by Ordid,DIVISIONID) CI
	left outer join @ORDINVSUM on ORDID=CI.ID
	where CostCode<>'Multiple' and CostAlloc='overheads'

	UPDATE @ORDINVSUM
	set CostCode=CN.CN from (select cast(DivID as NVARCHAR)+' - '+DivName as CN, DivID ID from DIVISIONS)CN
	left outer join @ORDINVSUM on CostCode=CN.ID
	where CostAlloc='Overheads' and CostCode<>'Multiple'

	/*Plant*/
	update @ORDINVSUM
	set CostCode=CC.CC from (select count(DISTINCT(PENUMBER)) CC,ORDID ID from ORDITEMS where ordid in (select ordid from @ORDINVSUM where COSTALLOC='Plant') group by ORDID) CC
	left outer join @ORDINVSUM on ORDID=CC.ID
	where CostAlloc='Plant'

	update @ORDINVSUM
	set CostCode='Multiple' where CostAlloc='Plant' and CostCode>1

	update @ORDINVSUM
	set CostCode=CI.CI from (select distinct(PENUMBER) CI,ORDID ID from OrdItems where ordid in (select ordid from @ORDINVSUM where CostAlloc='Plant' and CostCode='1') group by Ordid,PENUMBER) CI
	left outer join @ORDINVSUM on ORDID=CI.ID
	where CostCode<>'Multiple' and CostAlloc='Plant'

	UPDATE @ORDINVSUM
	set CostCode=CN.CN from (select rtrim(PENUMBER)+'- '+ rtrim(PEName) as CN, PENUMBER ID from PLANTANDEQ)CN
	left outer join @ORDINVSUM on CostCode=CN.ID
	where CostAlloc='Plant' and CostCode<>'Multiple'

	UPDATE @ORDINVSUM
	set DelValue=DV.DV from 
	(select D.ORDID ID,SUM(round((D.DLVRQTY*D.PRICE*((100-OI.DISCOUNT)/100))*(1+OI.VATPERC/100),2)) as DV
	from DELIVERIES D
	left outer join ORDITEMS OI on OI.ORDID=D.ORDID and OI.LINENUMBER=D.ORDITEMLINENO
	group by D.ORDID
	)DV
	left outer join @ORDINVSUM on Ordid=DV.ID

	UPDATE @ORDINVSUM
	set DelUnRecValue=DV.DV from 
	(select D.ORDID ID,SUM(round(((D.DLVRQTY-D.RECONQTY)*D.PRICE*((100-OI.DISCOUNT)/100))*(1+OI.VATPERC/100),2)) as DV
	from DELIVERIES D
	left outer join ORDITEMS OI on OI.ORDID=D.ORDID and OI.LINENUMBER=D.ORDITEMLINENO
	where D.ALLOCATED=0
	group by D.ORDID
	)DV
	left outer join @ORDINVSUM on Ordid=DV.ID

	update @ORDINVSUM
	set RecDelValue=RV.RV FROM
	(Select T.Orgid Org, T.OrderNo ORDNO,sum(T.Credit-T.Debit) RV
	from TRANSACTIONS T
	left outer join ControlCodes CC on CC.Controlname='Creditors'
	where T.Ledgercode=CC.COntrolfromGL and  T.ROLLEDFWD is null and T.TransType='DEL' and T.OrderNo in (select OrdNumber from @ORDINVSUM)
	Group by Orgid, T.OrderNo
	)
	RV 
	left outer join @ORDINVSUM on OrgID=RV.Org and OrdNumber=RV.ORDNO

	update @ORDINVSUM
	set PaidValue=PV.PV FROM
	(Select T.Orgid Org, T.OrderNo ORDNO,sum(T.PaidToDate) PV
	from TRANSACTIONS T
	left outer join ControlCodes CC on CC.Controlname='Creditors'
	where T.Ledgercode=CC.COntrolfromGL and  T.ROLLEDFWD is null and T.TransType='DEL' and T.OrderNo in (select OrdNumber from @ORDINVSUM)
	Group by Orgid, T.OrderNo
	)
	PV 
	left outer join @ORDINVSUM on OrgID=PV.Org and OrdNumber=PV.ORDNO

	Update  @ORDINVSUM
	set UnpaidValue=RecDelValue-PaidValue

	return 
END