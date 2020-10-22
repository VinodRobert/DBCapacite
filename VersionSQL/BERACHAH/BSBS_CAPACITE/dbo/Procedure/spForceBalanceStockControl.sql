/****** Object:  Procedure [dbo].[spForceBalanceStockControl]    Committed by VersionSQL https://www.versionsql.com ******/

    

CREATE PROCEDURE [dbo].[spForceBalanceStockControl]
-- =============================================
-- Author:		Okker Bites
-- Create date: 03/03/2009
-- Description:	Forcefully balances the stock control account to the stock values 
--Notes
--2009/04/03 OAB Add filter on the exclsion of period zero stock control postings
--2009/0417 OAB Fix rounding problem on Cost Rate.
--	Cost rate must be rounded to 4 dec.
--2010-01-11 Matthew
--  Changed the stock control to a stock range of controls with the default code in the INVSTORES table
--2010-03-18 Matthew
--  Improved query to check unreconciled deliveries
--2010-03-29 Matthew
--  Fixed the rounding to work for multi-decimals
--2010-06-23 Matthew
--  Changed to take homeCurrency into account when transaction not in HC
--  Deliveries now consider the discount and the exchrate.
--2011-09-13 KSN
--   ledger code creates duplication errors on shaft - Martella tested
--2011-10-03 Matthew
--  Forest spelling fixed to Forced
--2012-02-17 Matthew
--  Added QTY to the balance checking.
--2012-02-20 Matthew
--  Deleiveries qty adjustment to use the stock unit and apply the conversion from the orditem
--2012-05-02 Matthew
--  Filter out transaction types REV and ACC, for shaft that are posting their accruals
--2013-06-14 Matthew
--   Added TranGrp to TRANSACTIONS insert
--
-- =============================================


	-- Add the parameters for the stored procedure here
	@OrgID int = 1,
	@year  char(10) = '2009', 
	@Period int = 1, 
	@BatchRef char(10)= 'STO230223', 
	@transTyp as char(10) = 'SFB',
	@opLG char(10) = '876999',
	--@curr as char(10) = 'ZAR',  --get it from org paramerts
	@UserID char(15)= 'admin',
	
	@FrmStor char(20) = '',
	@ToStor char(20) = 'zzzzzzzzz',
    @docNumber char(50) = '',
    @tblName nvarchar(100) = ''	


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

DECLARE @holdError INT
SET @holdError = 0
BEGIN TRANSACTION
	
DECLARE @StkContCode AS char(10)
DECLARE @StkContCodeFrom AS char(10)
DECLARE @StkContCodeTo AS char(10)
declare @curr char(10), @DivID int
declare @dec as int 
declare @tranGRP int
declare @loopCntr int
declare @sql nvarchar(max)

set @tranGRP = -1
set @loopCntr = 0

while @tranGRP <> (select TRANGRP from TRANGROUP) and @loopCntr < 50
BEGIN
  select @tranGRP = TRANGRP + 1 from TRANGROUP
  update TRANGROUP set TRANGRP = @tranGRP 
  set @loopCntr = @loopCntr + 1
END 

SELECT @dec = ISNULL(DECIMALS, 2),
@curr = CURRENCY, @DivID = DEFDIV
FROM BORGS
LEFT OUTER JOIN CURRENCIES 
on BORGS.CURRENCY = CURRENCIES.CURRCODE  
WHERE BORGID = @orgid

SELECT @StkContCodeFrom = ControlFromGL,
@StkContCodeTo = ControlToGL
FROM CONTROLCODES
WHERE ControlName = 'Stock'

SELECT StkID, StkStore, StkCode,
IsNull(SUM((QTY * Price) + REIMBTAX),0) as ValueOfDvl, SUM(QTY) as QTYofDvl
into #DVL
FROM (
 SELECT INVENTORY.StkID, INVENTORY.BorgID, INVENTORY.StkStore, INVENTORY.StkCode,
 --2012-02-20 Matthew
 --DELIVERIES.DLVRQTY - DELIVERIES.RECONQTY as QTY,
 --(isnull(DELIVERIES.PRICE, ORDITEMS.PRICE) - (isnull(DELIVERIES.PRICE, ORDITEMS.PRICE) * ORDITEMS.DISCOUNT / 100))
 -- * case when ORD.CURRENCY <> @curr then ORD.EXCHRATE else 1 end AS Price
 (DELIVERIES.DLVRQTY - DELIVERIES.RECONQTY) * case when ORDITEMS.STKCONVERTFLAG = 0 THEN 1 / case when isnull(ORDITEMS.STKBUYCONV, INVENTORY.STKBUYCONV) = 0 then 1 else isnull(ORDITEMS.STKBUYCONV, INVENTORY.STKBUYCONV) end ELSE case when isnull(ORDITEMS.STKBUYCONV, INVENTORY.STKBUYCONV) = 0 then 1 else isnull(ORDITEMS.STKBUYCONV, INVENTORY.STKBUYCONV) end END as QTY,
 (isnull(DELIVERIES.PRICE, ORDITEMS.PRICE) - (isnull(DELIVERIES.PRICE, ORDITEMS.PRICE) * ORDITEMS.DISCOUNT / 100) + RA.RAVAL)
  * case when ORD.CURRENCY <> @curr then ORD.EXCHRATE else 1 end * case when ORDITEMS.STKCONVERTFLAG = 0 THEN case when isnull(ORDITEMS.STKBUYCONV, INVENTORY.STKBUYCONV) = 0 then 1 else isnull(ORDITEMS.STKBUYCONV, INVENTORY.STKBUYCONV) end ELSE 1 / case when isnull(ORDITEMS.STKBUYCONV, INVENTORY.STKBUYCONV) = 0 then 1 else isnull(ORDITEMS.STKBUYCONV, INVENTORY.STKBUYCONV) end END AS Price,
 MT.REIMBTAX REIMBTAX
 FROM DELIVERIES
 INNER JOIN ORDITEMS ON DELIVERIES.ORDID = ORDITEMS.ORDID AND DELIVERIES.ORDITEMLINENO = ORDITEMS.LINENUMBER
 INNER JOIN ORD ON ORD.ORDID = ORDITEMS.ORDID
 INNER JOIN LEDGERCODES ON ORDITEMS.GLCODEID = LEDGERCODES.LedgerID
 INNER JOIN INVENTORY ON ORDITEMS.STOCKID = INVENTORY.StkID
 OUTER APPLY(SELECT ISNULL(SUM(ISNULL(TAX, 0)), 0) REIMBTAX FROM GETVIEWTAXTRANS('', (((DELIVERIES.DLVRQTY - DELIVERIES.RECONQTY) * case when ORDITEMS.STKCONVERTFLAG = 0 THEN 1 / case when isnull(ORDITEMS.STKBUYCONV, INVENTORY.STKBUYCONV) = 0 then 1 else isnull(ORDITEMS.STKBUYCONV, INVENTORY.STKBUYCONV) end ELSE case when isnull(ORDITEMS.STKBUYCONV, INVENTORY.STKBUYCONV) = 0 then 1 else isnull(ORDITEMS.STKBUYCONV, INVENTORY.STKBUYCONV) end END) * isnull(DELIVERIES.PRICE, ORDITEMS.PRICE)) * (1 - (Orditems.Discount / 100)), ORDITEMS.VATID, ISNULL(ORDITEMS.TBORGID, ORD.BORGID), Ord.Currency) WHERE ISNULL(ISREIMB, -1) = 0) MT
 CROSS APPLY (
  select isnull(SUM(round(RIA.VALUE / OI.QTY, 4)), 0) RAVAL
  from ORD O
  INNER JOIN ORDITEMS OI on O.ORDID = OI.ORDID
  INNER JOIN REQITEMSADD RIA ON RIA.LINENUMBER = OI.LINENUMBER AND RIA.REQID = O.REQID
  inner join REQADD on RIA.RAID = REQADD.RAID
  WHERE REQADD.ISCOST = 1
  AND OI.ORDID = DELIVERIES.ORDID
  AND OI.LINENUMBER = DELIVERIES.ORDITEMLINENO
  AND OI.QTY <> 0
 ) RA
 WHERE DELIVERIES.ALLOCATION = 'Balance Sheet'
 AND DELIVERIES.ALLOCATED = 0
 AND LEDGERCODES.LedgerCode between @StkContCodeFrom and @StkContCodeTo
 AND INVENTORY.STKSTORE BETWEEN @FrmStor AND @ToStor
 and INVENTORY.BorgID = @orgid
) AS data
GROUP BY StkID, StkStore, StkCode

exec('alter table #DVL add 
CONSTRAINT [IX_TEMP_DVL_StkStore'+ @@SPID +'] UNIQUE NONCLUSTERED (StkStore, StkCode) ON [PRIMARY]')

SELECT TRANSACTIONS.Store, TRANSACTIONS.Stockno,
SUM(case when TRANSACTIONS.Currency = @curr then TRANSACTIONS.Debit else case when (TRANSACTIONS.Debit - TRANSACTIONS.Credit) > 0 then TRANSACTIONS.HomeCurrAmount else 0 end end) AS SumDebit,
SUM(case when TRANSACTIONS.Currency = @curr then TRANSACTIONS.Credit else case when (TRANSACTIONS.Debit - TRANSACTIONS.Credit) < 0 then TRANSACTIONS.HomeCurrAmount else 0 end end) AS sumCredit,
--SUM(TRANSACTIONS.QUANTITY) as SUMQTY
SUM(case when (TRANSACTIONS.Debit - TRANSACTIONS.Credit) = 0 then TRANSACTIONS.QUANTITY else case when (TRANSACTIONS.Debit - TRANSACTIONS.Credit) > 0 then ABS(TRANSACTIONS.QUANTITY) else -1 * ABS(TRANSACTIONS.QUANTITY) end end) as SUMQTY

--2011-09-13 KSN
--,
--TRANSACTIONS.LedgerCode as ledgercode
into #TRANS
FROM TRANSACTIONS
WHERE TRANSACTIONS.ALLOCATION = 'Balance Sheet'
AND TRANSACTIONS.LedgerCode between @StkContCodeFrom and @StkContCodeTo
and TRANSACTIONS.Store >= @FrmStor 
and TRANSACTIONS.Store <= @ToStor 
and TRANSACTIONS.OrgID = @orgid
and (TRANSACTIONS.Period <> 0 or (TRANSACTIONS.Period = 0 AND TRANSACTIONS.TRANSTYPE <> 'OPB'))
and LEFT(TRANSACTIONS.TRANSTYPE, 3) <> 'ACC'
and LEFT(TRANSACTIONS.TRANSTYPE, 3) <> 'REV'
group by TRANSACTIONS.Store, TRANSACTIONS.Stockno--, TRANSACTIONS.LedgerCode

exec('alter table #TRANS add 
CONSTRAINT [IX_TEMP_TRANS_Store'+ @@SPID +'] UNIQUE NONCLUSTERED (Store, Stockno) ON [PRIMARY]')

SELECT
@orgid as ORGID,
cast(StkStore as char(20)) as Store,
cast(StkCode as char(20)) as StockNo,
'Balance Sheet' AS Allocation,
--2011-09-13 KSN
--cast(@StkContCode as char(10)) AS LedgerCode,
cast(0 as decimal(24, 4)) AS SumDebit,
cast(0 as decimal(24, 4)) AS sumCredit,
cast(Round(StkQuantity * Round(StkCostRate,4), @dec) as decimal(24, 4)) AS ValueInStock,
@curr AS Currency,
cast(0 as decimal(24, 4)) AS Delta,
cast(StkQuantity as decimal(24, 4)) AS QinStock,
cast(Round(StkCostRate,4) as decimal(24, 4)) AS CostRatre,
cast(Round(StkQuantity * Round(StkCostRate,4), @dec) as decimal(24, 4)) AS StockCorrection,
cast(0 as decimal(24, 4)) AS ValueOfDvl,
cast(0 as decimal(24, 4)) AS QtyOfDvl,
cast(0 as decimal(24, 4)) AS StockQTYInLedger,
cast(0 as decimal(24, 4)) AS StockQTYCorrection,
INVENTORY.STKUNIT as STKUNIT
into #Var
FROM INVENTORY
LEFT OUTER JOIN #TRANS ON #TRANS.STORE = INVENTORY.STKSTORE AND #TRANS.STOCKNO = INVENTORY.STKCODE
WHERE (StkQuantity <> 0 OR #TRANS.STOCKNO = INVENTORY.STKCODE)
AND INVENTORY.StkStore >= @FrmStor
AND INVENTORY.StkStore <= @ToStor
AND INVENTORY.BorgID = @orgid

INSERT INTO #Var
(OrgID, Store, Stockno, Allocation, 
--2011-09-13 KSN
--LedgerCode, 
SumDebit, sumCredit, Delta, QinStock, CostRatre, ValueInStock, ValueOfDvl, QTYofDvl, StockCorrection)
SELECT @orgid, TRANSACTIONS.Store, TRANSACTIONS.Stockno, 'Balance Sheet',
--2011-09-13 KSN
--TRANSACTIONS.LedgerCode,
SUM(case when TRANSACTIONS.Currency = @curr then TRANSACTIONS.Debit else case when (TRANSACTIONS.Debit - TRANSACTIONS.Credit) > 0 then TRANSACTIONS.HomeCurrAmount else 0 end end),
SUM(case when TRANSACTIONS.Currency = @curr then TRANSACTIONS.Credit else case when (TRANSACTIONS.Debit - TRANSACTIONS.Credit) < 0 then TRANSACTIONS.HomeCurrAmount else 0 end end),
SUM(case when TRANSACTIONS.Currency = @curr then TRANSACTIONS.Debit - TRANSACTIONS.Credit else case when (TRANSACTIONS.Debit - TRANSACTIONS.Credit) > 0 then abs(TRANSACTIONS.HomeCurrAmount) else -1 * ABS(TRANSACTIONS.HomeCurrAmount) end end),
0 AS QinStock,
0 AS CostRatre, 
0 AS ValueInStock,
0 AS ValueOfDvl,
0 AS QTYofDvl,
0 AS StockCorrection
FROM TRANSACTIONS
WHERE TRANSACTIONS.Stockno = ''
and TRANSACTIONS.ALLOCATION = 'Balance Sheet'
AND TRANSACTIONS.LedgerCode between @StkContCodeFrom and @StkContCodeTo
and TRANSACTIONS.Store >= @FrmStor
and TRANSACTIONS.Store <= @ToStor
and TRANSACTIONS.OrgID = @orgid
and (TRANSACTIONS.Period <> 0 or (TRANSACTIONS.Period = 0 AND TRANSACTIONS.TRANSTYPE <> 'OPB'))
and LEFT(TRANSACTIONS.TRANSTYPE, 3) <> 'ACC'
and LEFT(TRANSACTIONS.TRANSTYPE, 3) <> 'REV'
GROUP BY TRANSACTIONS.Store, TRANSACTIONS.Stockno
--2011-09-13 KSN
--, TRANSACTIONS.LedgerCode

update #var
set ValueOfDvl = round(#DVL.ValueOfDvl, @dec),
QTYofDvl = round(#DVL.QTYofDvl, 4)
from #Var
inner join #DVL
ON #Var.Store = #DVL.StkStore AND #Var.StockNo = #DVL.StkCode

update #var
set SumDebit = round(#TRANS.SumDebit, @dec),
SumCredit = round(#TRANS.SumCredit, @dec),
Delta = round(#TRANS.SumDebit - #TRANS.SumCredit, @dec),
StockQTYInLedger = round(SUMQTY, 4)
--2011-09-13 KSN
--,
--LedgerCode = #TRANS.LedgerCode
from #Var
inner join #TRANS
ON #Var.Store = #TRANS.Store AND #Var.StockNo = #TRANS.StockNo

update #var
set StockCorrection = ValueInStock - (Delta + ValueOfDvl),
StockQTYCorrection = QinStock - (StockQTYInLedger + QtyOfDvl)
        

drop table #dvl
drop table #TRANS

declare  @Store char(20), @Stockno char(20), @StkDesc char(255), @StockCorrection as money
declare @stockQtyCorrection decimal(24, 4)
declare @stkUnit nvarchar(10)

DECLARE TransIns CURSOR SCROLL OPTIMISTIC for 
SELECT #Var.OrgID, #Var.Store, #Var.Stockno, StkDesc, round(StockCorrection, @dec) StockCorrection,
round(StockQTYCorrection, 4) StockQTYCorrection, #Var.STKUNIT
FROM #Var 
inner join INVENTORY on #Var.OrgID = INVENTORY.BorgID and #Var.Store = INVENTORY.StkStore and #Var.StockNo = INVENTORY.StkCode
where StockCorrection <> 0 or StockQTYCorrection <> 0
OPEN TransIns


FETCH NEXT FROM TransIns 
Into  @OrgID,@Store, @Stockno, @StkDesc, @StockCorrection, @stockQtyCorrection, @stkUnit


WHILE @@FETCH_STATUS = 0
begin

  set @StkContCode = @StkContCodeFrom
  select @StkContCode = STKCTL from INVSTORES where STORECODE = @Store

  set @sql = ''
  set @sql = @sql + 'declare @OrgID int '
  set @sql = @sql + 'declare @year char(10) '
  set @sql = @sql + 'declare @period int '
  set @sql = @sql + 'declare @BatchRef char(10) '
  set @sql = @sql + 'declare @transTyp char(10) '
  set @sql = @sql + 'declare @StkContCode char(10) '
  set @sql = @sql + 'declare @curr char(10) '
  set @sql = @sql + 'declare @Store char(20) '
  set @sql = @sql + 'declare @UserID char(15) '
  set @sql = @sql + 'declare @DivID int '
  set @sql = @sql + 'declare @StkDesc char(255) '
  set @sql = @sql + 'declare @Stockno char(20) '
  set @sql = @sql + 'declare @StockCorrection money '
  set @sql = @sql + 'declare @stockQtyCorrection decimal(24, 4) '
  set @sql = @sql + 'declare @stkUnit nvarchar(10) '
  set @sql = @sql + 'declare @tranGRP int '
  set @sql = @sql + 'declare @docNumber char(50) '
  set @sql = @sql + 'declare @opLG char(10) '

  set @sql = @sql + 'set @OrgID = ' + cast(@OrgID as nvarchar(10)) + ' '
  set @sql = @sql + 'set @year = ''' + @year + ''' '
  set @sql = @sql + 'set @period = ' + cast(@period as nvarchar(10)) + ' '
  set @sql = @sql + 'set @BatchRef = ''' + @BatchRef + ''' '
  set @sql = @sql + 'set @transTyp = ''' + @transTyp + ''' '
  set @sql = @sql + 'set @StkContCode = ''' + @StkContCode + ''' '
  set @sql = @sql + 'set @curr = ''' + @curr + ''' '
  set @sql = @sql + 'set @Store = ''' + @Store + ''' '
  set @sql = @sql + 'set @UserID = ''' + @UserID + ''' '
  set @sql = @sql + 'set @DivID = ' + cast(@DivID as nvarchar(10)) + ' '
  set @sql = @sql + 'set @StkDesc = ''' + @StkDesc + ''' '
  set @sql = @sql + 'set @Stockno = ''' + @Stockno + ''' '
  set @sql = @sql + 'set @StockCorrection = ' + cast(@StockCorrection as nvarchar(24)) + ' '
  set @sql = @sql + 'set @stockQtyCorrection = ' + cast(@stockQtyCorrection as nvarchar(24)) + ' '
  set @sql = @sql + 'set @stkUnit = ''' + @stkUnit + ''' '
  set @sql = @sql + 'set @tranGRP = ' + cast(@tranGRP as nvarchar(10)) + ' '
  set @sql = @sql + 'set @docNumber = ''' + @docNumber + ''' '
  set @sql = @sql + 'set @opLG = ''' + @opLG + ''' '

  set @sql = @sql + 'INSERT INTO BSBS_TEMP.dbo.'+ @tblName +' ( '
  set @sql = @sql + 'OrgID, Year, Period, PDate, TransRef, BatchRef,  TransType, Allocation, LedgerCode, Currency, '
  set @sql = @sql + 'Debit, Credit, '
  set @sql = @sql + 'VatDebit, VatCredit, Store, VATType, UserID, DivID, '
  set @sql = @sql + 'Description, Stockno, '
  set @sql = @sql + 'Quantity, '
  set @sql = @sql + 'Unit, Rate, TRANGRP, DOCNUMBER '
  set @sql = @sql + ') '
  set @sql = @sql + 'VALUES ( '
  set @sql = @sql + '@OrgID, @year, @period, GetDate(), @BatchRef, @BatchRef, @transTyp, ''Balance Sheet'', @StkContCode, @curr, '
  set @sql = @sql + 'case when @StockCorrection > 0 then @StockCorrection else 0 end, case when @StockCorrection < 0 then abs(@StockCorrection) else 0 end, '
  set @sql = @sql + '0, 0, @Store, ''Z'', @UserID, @DivID, '
  set @sql = @sql + 'Left(''Forced stock control balancing  for '' + @StkDesc, 255) ,RTrim(@Stockno), '
  set @sql = @sql + 'case when (@StockCorrection >= 0 and @stockQtyCorrection > 0) or (@StockCorrection <= 0 and @stockQtyCorrection < 0) then @stockQtyCorrection else 0 end, '
  set @sql = @sql + '@stkUnit, 0, @tranGRP, @docNumber '
  set @sql = @sql + ') '

  if @StockCorrection <> 0 
  begin
	  set @sql = @sql + 'INSERT INTO BSBS_TEMP.dbo.'+ @tblName +' ( '
	  set @sql = @sql + 'OrgID, Year, Period, PDate, TransRef, BatchRef, TransType, Allocation, LedgerCode, Currency, '
	  set @sql = @sql + 'Debit, Credit, '
	  set @sql = @sql + 'VatDebit, VatCredit, Store, VATType, UserID, DivID, '
	  set @sql = @sql + 'Description, Stockno, '
	  set @sql = @sql + 'Quantity, '
	  set @sql = @sql + 'Unit, Rate, TRANGRP, DOCNUMBER '
	  set @sql = @sql + ') '
	  set @sql = @sql + 'VALUES ( '
	  set @sql = @sql + '@OrgID, @year, @period, GetDate(), @BatchRef, @BatchRef, @transTyp, ''Balance Sheet'', @opLG, @curr, '
	  set @sql = @sql + 'case when @StockCorrection > 0 then 0 else abs(@StockCorrection) end, case when @StockCorrection < 0 then 0 else abs(@StockCorrection) end, '
	  set @sql = @sql + '0, 0, @Store, ''Z'', @UserID, @DivID, '
	  set @sql = @sql + 'Left(''Forced stock control balancing  for ''+ @StkDesc, 255) ,RTrim(@Stockno), '
	  set @sql = @sql + 'case when (@StockCorrection >= 0 and @stockQtyCorrection > 0) or (@StockCorrection <= 0 and @stockQtyCorrection < 0) then @stockQtyCorrection else 0 end, '
	  set @sql = @sql + '@stkUnit, 0, @tranGRP, @docNumber '
	  set @sql = @sql + ') '
  end

  if (@StockCorrection > 0 and @stockQtyCorrection < 0) or (@StockCorrection < 0 and @stockQtyCorrection > 0) 
  begin
	  set @sql = @sql + 'INSERT INTO BSBS_TEMP.dbo.'+ @tblName +' ( '
	  set @sql = @sql + 'OrgID, Year, Period, PDate, TransRef, BatchRef,  TransType, Allocation, LedgerCode, Currency, '
	  set @sql = @sql + 'Debit, Credit, '
	  set @sql = @sql + 'VatDebit, VatCredit, Store, VATType, UserID, DivID, '
	  set @sql = @sql + 'Description, Stockno, '
	  set @sql = @sql + 'Quantity, '
	  set @sql = @sql + 'Unit, Rate, TRANGRP, DOCNUMBER '
	  set @sql = @sql + ') '
	  set @sql = @sql + 'VALUES ( '
	  set @sql = @sql + '@OrgID, @year, @period, GetDate(), @BatchRef, @BatchRef, @transTyp, ''Balance Sheet'', @StkContCode, @curr, '
	  set @sql = @sql + '0,0, '
	  set @sql = @sql + '0, 0, @Store, ''Z'', @UserID, @DivID, '
	  set @sql = @sql + 'Left(''Forced stock control balancing  for ''+ @StkDesc, 255) ,RTrim(@Stockno), '
	  set @sql = @sql + '@stockQtyCorrection, '
	  set @sql = @sql + '@stkUnit, 0, @tranGRP, @docNumber '
	  set @sql = @sql + ') '
  end 

  EXEC (@sql)

  SELECT @holdError = @@error IF @holdError <> 0 BEGIN ROLLBACK TRANSACTION RETURN RTrim(@Stockno) END

FETCH NEXT FROM TransIns 
Into  @OrgID,@Store, @Stockno, @StkDesc, @StockCorrection, @stockQtyCorrection, @stkUnit
end 

CLOSE TransIns
DEALLOCATE TransIns

drop table #Var

If @holdError <> 0 
begin 
	ROLLBACK TRANSACTION
	RETURN @Stockno
end 
else 
begin  	
	Commit transaction 
	RETURN 0
end	
END
		