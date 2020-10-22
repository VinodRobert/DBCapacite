/****** Object:  Function [dbo].[dellist]    Committed by VersionSQL https://www.versionsql.com ******/

create function dbo.dellist
(
@Start	nvarchar(10),
@End	nvarchar(10),
@ForOrgs	nvarchar(100)
)

returns @DelList table
(
OrderOrg	int,
ForOrg		int,
OrderNo		nvarchar(55) COLLATE SQL_Latin1_General_CP1_CI_AS,
CredNo		nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS,
CredName	nvarchar(130) COLLATE SQL_Latin1_General_CP1_CI_AS,
Line		int,
CostAlloc	nvarchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS,
CostCode	nvarchar(15) COLLATE SQL_Latin1_General_CP1_CI_AS,
CostName	nvarchar(55) COLLATE SQL_Latin1_General_CP1_CI_AS,
LedgerCode	nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS,
LedgerName	nvarchar(35) COLLATE SQL_Latin1_General_CP1_CI_AS,
Activity	nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS,
Descr		nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS,
DLVRID		int,
GRNONO		nvarchar(55) COLLATE SQL_Latin1_General_CP1_CI_AS,
DLVRNO		nvarchar(55) COLLATE SQL_Latin1_General_CP1_CI_AS,
UOM			nvarchar(25) COLLATE SQL_Latin1_General_CP1_CI_AS,
Price		money,
DelQty		decimal(18,4),
DelDate		nvarchar(10),
CapDate		datetime,
UserID		int,
UserName	nvarchar(75) COLLATE SQL_Latin1_General_CP1_CI_AS
)
AS
BEGIN

If @ForOrgs<>'-1'
INSERT INTO @DelList
(
OrderOrg	
,ForOrg		
,OrderNo		
,CredNo		
,CredName	
,Line		
,CostAlloc	
,CostCode	
,CostName	
,LedgerCode	
,LedgerName	
,Activity	
,Descr
,DLVRID		
,GRNONO		
,DLVRNO		
,UOM			
,Price		
,DelQty		
,DelDate		
,CapDate			
,UserID
,UserName
)

Select
O.BORGID,
OI.TBORGID,		
O.ORDNUMBER,	
S.SUPPCODE,	
C.CredName,
D.ORDITEMLINENO,
OI.ALLOCATION,
Case when OI.ALLOCATION='Contracts' then CC.CONTRNUMBER else case when OI.Allocation='Overheads' then cast(DV.DivID as nvarchar(10)) else case when OI.ALLOCATION='Plant' then P.PeNumber else 'Balance Sheet' end end end,
Case when OI.ALLOCATION='Contracts' then CC.CONTRNAME else case when OI.Allocation='Overheads' then DV.DivName else case when OI.ALLOCATION='Plant' then P.PeName else '' end end end,	
LC.LedgerCode,	
LC.LedgerName,	
A.ActNumber,
replace (replace (replace (replace (replace (OI.ITEMDESCRIPTION,char(9),' '),char(160),' '),';',' '),char(13),' '),char(10),' '),
D.DLVRID,	
D.GRNNO,		
D.DLVRNO,		
OI.UOM,		
OI.PRICE,		
D.DLVRQTY,		
convert(nvarchar,D.DLVRDATE,103),		
D.DLVRCAPTDATE,
D.USERID,
U.USERNAME
From Deliveries D
left outer join ORDITEMS OI on OI.ORDID=D.ORDID and OI.LINENUMBER=D.ORDITEMLINENO
left outer join Ord O on O.ORDID=D.ORDID
left outer join SUPPLIERS S on S.SUPPID=O.SUPPID
left outer join CREDITORS C on C.CredNumber=S.SUPPCODE
left outer join LEDGERCODES LC on LC.LedgerID=OI.GLCODEID
left outer join Contracts CC on CC.Contrid=OI.ContractID
left outer join Activities A on A.Actid=OI.ACTID
left outer join Divisions DV on DV.Divid=OI.DivisionID
left outer join PlantandEq P on P.PENumber=OI.PENumber
left outer join Users U on U.USERID=D.USERID
WHERE
D.DLVRCAPTDATE between convert(datetime,@Start,103) and dateadd(dd,1,convert(datetime,@End,103)) and D.TBORGID in (select S.Items from dbo.Split(@ForOrgs, ',') S where S.Items is not null )

If @ForOrgs='-1'
INSERT INTO @DelList
(
OrderOrg	
,ForOrg		
,OrderNo		
,CredNo		
,CredName	
,Line		
,CostAlloc	
,CostCode	
,CostName	
,LedgerCode	
,LedgerName	
,Activity	
,Descr
,DLVRID		
,GRNONO		
,DLVRNO		
,UOM			
,Price		
,DelQty		
,DelDate		
,CapDate	
,UserID
,UserName		
)

Select
O.BORGID,
OI.TBORGID,		
O.ORDNUMBER,	
S.SUPPCODE,	
C.CredName,
D.ORDITEMLINENO,
OI.ALLOCATION,
Case when OI.ALLOCATION='Contracts' then CC.CONTRNUMBER else case when OI.Allocation='Overheads' then cast(DV.DivID as nvarchar(10)) else case when OI.ALLOCATION='Plant' then P.PeNumber else 'Balance Sheet' end end end,
Case when OI.ALLOCATION='Contracts' then CC.CONTRNAME else case when OI.Allocation='Overheads' then DV.DivName else case when OI.ALLOCATION='Plant' then P.PeName else '' end end end,	
LC.LedgerCode,	
LC.LedgerName,	
A.ActNumber,
replace (replace (replace (replace (replace (OI.ITEMDESCRIPTION,char(9),' '),char(160),' '),';',' '),char(13),' '),char(10),' '),
D.DLVRID,	
D.GRNNO,		
D.DLVRNO,		
OI.UOM,		
OI.PRICE,		
D.DLVRQTY,		
convert(nvarchar,D.DLVRDATE,103),		
D.DLVRCAPTDATE,
D.USERID,
U.USERNAME
From Deliveries D
left outer join ORDITEMS OI on OI.ORDID=D.ORDID and OI.LINENUMBER=D.ORDITEMLINENO
left outer join Ord O on O.ORDID=D.ORDID
left outer join SUPPLIERS S on S.SUPPID=O.SUPPID
left outer join CREDITORS C on C.CredNumber=S.SUPPCODE
left outer join LEDGERCODES LC on LC.LedgerID=OI.GLCODEID
left outer join Contracts CC on CC.Contrid=OI.ContractID
left outer join Activities A on A.Actid=OI.ACTID
left outer join Divisions DV on DV.Divid=OI.DivisionID
left outer join PlantandEq P on P.PENumber=OI.PENumber
left outer join Users U on U.USERID=D.USERID
WHERE
D.DLVRCAPTDATE between convert(datetime,@Start,103) and dateadd(dd,1,convert(datetime,@End,103))



return
END