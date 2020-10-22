/****** Object:  Procedure [dbo].[spInsertTaxTrans]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Matthew Spiller
-- Create date: 13-11-2008
-- Description:	returns a table from the Tax calculations 
-- =============================================
CREATE PROCEDURE [dbo].[spInsertTaxTrans] 
	-- Add the parameters for the stored procedure here
	@transid int,
	@vatControl nvarchar(10),
	@amount numeric(18, 4),
	@vatType nvarchar(250),
	@borg int,
	@provinceids int,
	@provinceido int,
	@provinceidd int,
	@curr nvarchar(3)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


--create temp table

	create table #temp
	(
	 vatgc nvarchar(3) COLLATE SQL_Latin1_General_CP1_CI_AS,  
	 [name] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS, 
	 sequence int, 
	 perc numeric(18, 4), 
	 isaccum bit, 
	 isreimb bit, 
	 ledgercode nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS, 
	 tax numeric(18, 4), 
	 cumCost numeric(18, 4),
	 cumTax numeric(18, 4),
	 vatType char(2),
	 borgid int, 
	 surchargeApplies bit, 
	 isSurcharge bit
	)

--populate the temp table using stored procedure

	insert into #temp
	EXEC [spViewTaxTrans] @vatControl, @amount, @vatType, @borg, @curr
	

--insert the calculated vats into the TAXTRANS table

	insert into TAXTRANS (
	 TRANSID, VATGC, [name], SEQUENCE, PERC,
	 ISACCUM, ISREIMB, LEDGERCODE, TAX, CUMCOST,
	 CUMTAX, VATTYPE, BORGID,
	 PROVINCEIDS, PROVINCEIDO, PROVINCEIDD,
	 SURCHARGEAPPLIES, ISSURCHARGE
	 )
	select
	 @transid, vatgc, [name], sequence, perc, 
	 isaccum, isreimb, ledgercode, tax, cumCost,
	 cumTax, vatType, borgid,
	 @provinceids, @provinceido, @provinceidd,
	 SURCHARGEAPPLIES, ISSURCHARGE
	from #temp
	where VATTYPE is not null

--remove the temp table

	drop table #temp
END
		
		