/****** Object:  Function [dbo].[YSRATES]    Committed by VersionSQL https://www.versionsql.com ******/

Create function dbo.YSRATES
(
@OrgID		Int,
@Store		nvarchar(200),
@Contract	nvarchar(10)
)

returns @YSRATES table
(
OrgID		int,
StoreCode	nvarchar(15)  COLLATE SQL_Latin1_General_CP1_CI_AS,
StockCode	nvarchar(20)  COLLATE SQL_Latin1_General_CP1_CI_AS,
Description nvarchar(250)  COLLATE SQL_Latin1_General_CP1_CI_AS,
ContrNo		nvarchar(10)  COLLATE SQL_Latin1_General_CP1_CI_AS,
ContrName	nvarchar(50)  COLLATE SQL_Latin1_General_CP1_CI_AS,
RateType	nvarchar(25)  COLLATE SQL_Latin1_General_CP1_CI_AS,
DailyRate	money 
)

as
Begin

Insert into @YSRATES
(
OrgID,		
StoreCode,	
StockCode,	
Description, 
ContrNo,		
ContrName,	
RateType,	
DailyRate	
)
select I.BorgID,I.StkStore,I.StkCode,rtrim(I.StkDesc),@Contract,C.CONTRNAME,

case when CR.Rate is not null then 'Custom Rate' ELSE case when C.STKHIREPRC<>0 then 'Percentage Rate' else 'Standard Daily Rate' end end,
Case when CR.Rate is not null then CR.Rate else case when C.STKHIREPRC<>0 then  I.StkHireRate *((100+C.StkhirePRC)/100) else I.StkhireRate END END
from INVENTORY I
left outer join INVSTORESCOSDIV IC on IC.StoreCode=I.stkStore and IC.BORGID=@OrgID
Left outer join Contracts C on C.CONTRNUMBER=@Contract
left outer join CONTRACTRATES CR on CR.stockid=I.StkID and CR.contractid=C.CONTRID
Where I.BorgID=@OrgID and I.StkStore=@Store and IC.IsYardStore=1 and C.CONTRNUMBER=@Contract
and I.StkStatus=0

RETURN
END