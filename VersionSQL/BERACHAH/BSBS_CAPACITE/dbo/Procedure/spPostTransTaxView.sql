/****** Object:  Procedure [dbo].[spPostTransTaxView]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Matthew Spiller
-- Create date: 13-11-2008
-- Description:	returns a table from the Tax calculations 
-- Notes
-- 2009/06/10 OAB 
-- Adapted the procedure from spViewTaxTrans 
-- This now forms part of the Balance check and multi Tax posting  
-- 2009-07-02 Matthew
--  Change spec to have accumulated taxes after the surcharge taxes   
--2010-03-09 Matthew
--  Added the currency on the import values so we can round to the correct decimals, for multi-decimal change on currencies
-- =============================================
CREATE PROCEDURE [dbo].[spPostTransTaxView] 
	-- Add the parameters for the stored procedure here
--	@vatctl nvarchar(10),
	@amount numeric(18, 4),
	@vatType nvarchar(250),
	@BorgID int,
	@TempTransID int = 1,
	@curr nvarchar(3)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--Variables declaration
	declare @taxAmount numeric(18, 4)
	declare @tax numeric(18, 4)
	declare @cumCost numeric(18, 4)
	declare @vatgc nvarchar(3)
	declare @seq int
	declare @surchargeTax numeric(18, 4)
	declare @surchargeTaxA numeric(18, 4)
	declare @vatctl char(10)
	declare @decimals int

--set Variables
-- Vat contral or GST control 
	if 9 = ( select ENTERPRISE from Borgs where borgId = @BorgID ) 
		set @vatctl = ( select top 1  CONTROLTOGL from dbo.CONTROLCODES where CONTROLNAME = 'General Sales Tax' )
	else
		set @vatctl = ( select top 1  CONTROLTOGL from dbo.CONTROLCODES where CONTROLNAME = 'Value Added Tax' )

	set @tax = 0
	set @taxAmount = @amount
	set @cumCost = @amount		
	set @surchargeTax = 0
	set @surchargeTaxA = 0
	set @decimals = 2
	
	SELECT @decimals = ISNULL(DECIMALS, 2) 
	FROM CURRENCIES
	WHERE CURRENCIES.CURRCODE = @curr

--create temp table
	declare @temp table
	(
		vatgc nvarchar(3) COLLATE SQL_Latin1_General_CP1_CI_AS,  
		[name] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS, 
		sequence int, 
		perc numeric(18, 4), 
		isaccum bit, 
		isreimb bit , 
		ledgercode nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS, 
		tax numeric(18, 4), 
		cumCost numeric(18, 4),
		cumTax numeric(18, 4),
		vatType char(2),
		borgid int,
		SURCHARGEAPPLIES bit,
		ISSURCHARGE bit,
		TempTransID int
	)

--populate the temp table using the vat groups
	if ((select USEVATGROUPS from borgs WHERE BORGID = @BorgID) = 1 or @vatType != replace(replace(@vatType,',',''),':',''))
	BEGIN

		insert into @temp
		select vt.VATGC, vt.VATNAME, isnull(vg.SEQUENCE, -1), vt.VATPERC, isnull(vg.ISACCUM, 0), vt.ISREIMB, 
        case when isnull(vt.DEFLEDGERCODE, '') = '' then isnull(vg.LEDGERCODE, @vatctl) else vt.DEFLEDGERCODE end, 
		0 as TAX, 0 as CUMCOST, 0 as CUMTAX, vt.VATID as VATTYPE, @BorgID as BORGID,
		isnull(SURCHARGEAPPLIES, 0), isnull(ISSURCHARGE, 0), @TempTransID
		from Split(@vatType, ',') S
		left outer join vattypes vt
		----on dbo.splitval(S.items,':',1) = vt.vatid
		----and isnull(dbo.splitval(S.items,':',2),'') = vt.vatgc
        --on substring(S.items,0, charindex(':', S.items)) = vt.vatid
		--and isnull(substring(S.items, charindex(':', S.items) + 1, len(S.items)),'') = vt.vatgc
        on substring(S.items,0, case when charindex(':', S.items) = 0 then 2 else charindex(':', S.items) end) = vt.vatid
		and isnull(substring(S.items, case when charindex(':', S.items) = 0 then 2 else charindex(':', S.items) end + 1, len(S.items)),'') = vt.vatgc
		and vt.borgid = @BorgID
		left outer join vatgroups vg
		on vg.vatgc = vt.vatgc
		where S.items is not null
		--2009-07-02 Matthew
		--order by isnull(vg.ISSURCHARGE, 0), isnull(vg.SEQUENCE, -1)
		order by isnull(vg.SEQUENCE, -1)
	END
	ELSE
	BEGIN
		insert into @temp
		select v.VATID, V.VATNAME, -1 as sequence, v.VATPERC, 0 as isaccum, 1 as isreimb, 
        case when isnull(V.DEFLEDGERCODE, '') = '' then @vatctl else V.DEFLEDGERCODE end as ledgercode, 
		0 as tax, 0 as cumCost, 0 as cumTax, @vatType as vatType, @BorgID as borgid,
		0 as surchargeApplies, 0 as isSurcharge, @TempTransID as tempTtansID
		from VATTYPES V
		where V.borgid = @BorgID
		and V.vatid = @vatType		
	END

	update @temp set tax = 0, cumCost = 0, cumTax = 0

--for each value in the temp table, calculate in sequence the vat amounts
	DECLARE the_Cursor CURSOR FOR
	select vatgc, sequence from @temp order by sequence
	--2009-07-02 Matthew
	--order by issurcharge, sequence


	OPEN the_Cursor

	FETCH NEXT FROM the_Cursor into @vatgc, @seq
	WHILE @@FETCH_STATUS = 0
	BEGIN

	 update @temp set 
	 /*tax = round(cast(case when isaccum = 1 then (perc / 100) * @taxamount else (perc / 100) * @amount end as numeric(18, 4)), @decimals),*/
	 tax = round(cast(
		case when isaccum = 1 then 
		(perc / 100) * 
  			case when ISSURCHARGE = 0 
				then @taxamount 
				else @surchargeTaxA
			end 
		else (perc / 100) * 
			case when ISSURCHARGE = 0 
				then @amount 
				else @surchargeTax
			end 
		end as numeric(18, 4)), @decimals),
	 @cumCost = @cumCost + case when isreimb = 0 then round(cast(case when isaccum = 1 then (perc / 100) * @taxamount else (perc / 100) * @amount end as numeric(18, 4)), @decimals) else 0 end
	 where vatgc = @vatgc 
	 and sequence = @seq
	
	 select @tax = @tax + tax,
	 @surchargeTax = @surchargeTax + case when t.SURCHARGEAPPLIES = 1 and t.ISSURCHARGE = 0 then tax else 0 end,
	 @surchargeTaxA = @surchargeTaxA + case when t.SURCHARGEAPPLIES = 1 then tax else 0 end
	 from @temp t
	 where vatgc = @vatgc 
	 and sequence = @seq

	 set @taxAmount = @amount + @tax

	 update @temp set 
	 cumTax = @taxamount,
	 cumCost = @cumCost
	 where vatgc = @vatgc 
	 and sequence = @seq
	 
	 FETCH NEXT FROM the_Cursor into @vatgc, @seq
	END

	CLOSE the_Cursor
	DEALLOCATE the_Cursor

--select 'ViewTest' as test

--returns the table

        select * from @temp

--select @amount as Amount, @tax as Tax, @taxAmount as taxAmount, @cumCost as cumCost

--remove the temp table

END