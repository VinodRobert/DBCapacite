/****** Object:  Function [dbo].[Transactionlinking]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Tim Forshaw
-- Create date: 12-10-2015
-- Description:	Creates function to link transactions to a single ledger code to all of the other transaction legs
-- NOTES:
--  
-- =============================================
create function [dbo].[Transactionlinking]
(
@year char(10),
@period int,
@ledgercode char(10),
@org int
)
returns @tl table (
[Organisation ID]						int,
[Year]									char (10) COLLATE SQL_Latin1_General_CP1_CI_AS,
Period									int,
[Transaction Date]						datetime,
[Batch Reference]						char (10) COLLATE SQL_Latin1_General_CP1_CI_AS,
[Transaction Reference]					char (10) COLLATE SQL_Latin1_General_CP1_CI_AS,
[Transaction Type]						char (10) COLLATE SQL_Latin1_General_CP1_CI_AS,
[Description]							char (255) COLLATE SQL_Latin1_General_CP1_CI_AS,
[Ledger Code]							char (10) COLLATE SQL_Latin1_General_CP1_CI_AS,
[Allocation]							char (25) COLLATE SQL_Latin1_General_CP1_CI_AS,
[Contract]								nvarchar (10) COLLATE SQL_Latin1_General_CP1_CI_AS,
[Activity]								char (10) COLLATE SQL_Latin1_General_CP1_CI_AS,
[Division ID]							int,
[Plant Number]							char (10) COLLATE SQL_Latin1_General_CP1_CI_AS,
[Stock Number]							char (20) COLLATE SQL_Latin1_General_CP1_CI_AS,
[Store Code]							char (20) COLLATE SQL_Latin1_General_CP1_CI_AS,
[Currency]								nvarchar (3) COLLATE SQL_Latin1_General_CP1_CI_AS,
[Debit]									money,
[Credit]								money,
[Home Currency Amount]					money,
[Creditor/Debtor/Subcontractoor Code]	char (10) COLLATE SQL_Latin1_General_CP1_CI_AS,
[SubConTran]							char (20) COLLATE SQL_Latin1_General_CP1_CI_AS,
[Quantity]								numeric (23,4),
[Rate]									money,
[Transaction Group]						int,
[Transaction ID]						int
)	

AS
BEGIN

declare @ctlWIP nvarchar(10)
declare @ctlRI nvarchar(10)

select @ctlWIP = CONTROLCODES.ControlFromGL from CONTROLCODES where ControlName in ('Work In Progress')
select @ctlRI = CONTROLCODES.ControlFromGL from CONTROLCODES where ControlName in ('Retained Income')


 insert @tl (
 [Organisation ID]						,
 [Year]									,
 Period									,
 [Transaction Date]						,
 [Batch Reference]						,
 [Transaction Reference]				,	
 [Transaction Type]						,
 [Description]							,
 [Ledger Code]							,
 [Allocation]							,
 [Contract]								,
 [Activity]								,
 [Division ID]							,
 [Plant Number]							,
 [Stock Number]							,
 [Store Code]							,
 [Currency]								,
 [Debit]								,	
 [Credit]								,
 [Home Currency Amount]					,
 [Creditor/Debtor/Subcontractoor Code]	,
 [SubConTran]							,
 [Quantity]								,
 [Rate]									,
 [Transaction Group]					,	
 [Transaction ID]		
 )

select orgid, [year], period, pdate, batchref, transref, transtype,[Description], ledgercode,allocation, [contract], activity, divid, plantno, Stockno, Store, Currency, Debit, Credit, HomeCurrAmount, Credno,SubConTran,Quantity,Rate, TRANGRP, Transid
from TRANSACTIONS

where trangrp in (
	select trangrp 
	from transactions
	where ledgercode=@ledgercode 
	and Year=@year 
	and period=case when @period = -1 then period else @period end
	and trangrp is not null
	and orgid=@org
	)
and TRANSACTIONS.LedgerCode not in (@ctlRI, @ctlWIP)
order by TRANGRP, TransID
				
RETURN
END
		
		