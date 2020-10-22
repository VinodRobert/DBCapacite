/****** Object:  Function [dbo].[getViewTaxTrans]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Matthew Spiller
-- Create date: 08-03-2016
-- Description:	returns a table from the Tax calculations 
-- NOTES:
-- 2016-08-03 Matthew
--    Copied from stored procedure spViewTaxTrans, does same calculation but is a table function so can be used directly in SQL queries.
-- =============================================
CREATE FUNCTION getViewTaxTrans(
	@vatControl nvarchar(10),
	@amount numeric(24, 4),
	@vatType nvarchar(250),
	@borg int,
	@curr nvarchar(3))
	RETURNS @t TABLE (
	 vatgc nvarchar(3) COLLATE SQL_Latin1_General_CP1_CI_AS,  
	 [name] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS, 
	 sequence int, 
	 perc numeric(24, 4), 
	 isaccum bit, 
	 isreimb bit , 
	 ledgercode nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS, 
	 tax numeric(24, 4), 
	 cumCost numeric(24, 4),
	 cumTax numeric(24, 4),
	 vatType char(2),
	 borgid int,
	 SURCHARGEAPPLIES bit,
	 ISSURCHARGE bit
	)
as BEGIN

--Variables declaration
	declare @taxAmount numeric(24, 4)
	declare @tax numeric(24, 4)
	declare @cumCost numeric(24, 4)
	declare @vatgc nvarchar(3)
	declare @seq int
	declare @surchargeTax numeric(24, 4)
	declare @surchargeTaxA numeric(24, 4)
	declare @decimals int

--set Variables
	
	set @tax = 0
	set @taxAmount = @amount
	set @cumCost = @amount		
	set @surchargeTax = 0
	set @surchargeTaxA = 0
	set @decimals = 2
	
	SELECT @decimals = ISNULL(DECIMALS, 2) 
	FROM CURRENCIES
	WHERE CURRENCIES.CURRCODE = @curr
 
--populate the temp table using the vat groups
	
	if ((select USEVATGROUPS from borgs WHERE BORGID = @borg) = 1 or @vatType != replace(replace(@vatType,',',''),':',''))
	BEGIN

		insert into @t
		select vt.VATGC, vt.VATNAME, isnull(vg.SEQUENCE, -1), vt.VATPERC, isnull(vg.ISACCUM, 0), vt.ISREIMB, 
        case when isnull(vt.DEFLEDGERCODE, '') = '' then isnull(vg.LEDGERCODE, @vatControl) else vt.DEFLEDGERCODE end,
		0 as TAX, 0 as CUMCOST, 0 as CUMTAX, vt.VATID as VATTYPE, @borg as BORGID,
		isnull(SURCHARGEAPPLIES, 0), isnull(ISSURCHARGE, 0)
		from Split(@vatType, ',') S
		left outer join vattypes vt
		----on dbo.splitval(S.items,':',1) = vt.vatid
		----and isnull(dbo.splitval(S.items,':',2),'') = vt.vatgc
        --on substring(S.items,0, charindex(':', S.items)) = vt.vatid
		--and isnull(substring(S.items, charindex(':', S.items) + 1, len(S.items)),'') = vt.vatgc
        on substring(S.items,0, case when charindex(':', S.items) = 0 then 2 else charindex(':', S.items) end) = vt.vatid
		and isnull(substring(S.items, case when charindex(':', S.items) = 0 then 2 else charindex(':', S.items) end + 1, len(S.items)),'') = vt.vatgc
		and vt.borgid = @borg
		left outer join vatgroups vg
		on vg.vatgc = vt.vatgc
		where S.items is not null 
		order by isnull(vg.SEQUENCE, -1)
	END
	ELSE
	BEGIN
		insert into @t
		select v.VATID, V.VATNAME, -1 as sequence, v.VATPERC, 0 as isaccum, 1 as isreimb, 
        case when isnull(V.DEFLEDGERCODE, '') = '' then @vatControl else V.DEFLEDGERCODE end as ledgercode, 
		0 as tax, 0 as cumCost, 0 as cumTax, @vatType as vatType, @borg as borgid,
		0 as surchargeApplies, 0 as isSurcharge
		from VATTYPES V
		where V.borgid = @borg
		and V.vatid = cast(@vatType as char(2))
	END

	update @t set tax = 0, cumCost = 0, cumTax = 0

--for each value in the temp table, calculate in sequence the vat amounts

	DECLARE the_Cursor CURSOR FOR
	select vatgc, sequence from @t order by sequence 

	OPEN the_Cursor

	FETCH NEXT FROM the_Cursor into @vatgc, @seq
	WHILE @@FETCH_STATUS = 0
	BEGIN

	 update @t set 
	 /*tax = round(cast(case when isaccum = 1 then (perc / 100) * @taxamount else (perc / 100) * @amount end as numeric(24, 4)), @decimals),*/
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
		end as numeric(24, 4)), @decimals),
	 @cumCost = @cumCost + case when isreimb = 0 then round(cast(case when isaccum = 1 then (perc / 100) * @taxamount else (perc / 100) * @amount end as numeric(24, 4)), @decimals) else 0 end
	 where vatgc = @vatgc 
	 and sequence = @seq
	
	 select @tax = @tax + tax,
	 @surchargeTax = @surchargeTax + case when T.SURCHARGEAPPLIES = 1 and T.ISSURCHARGE = 0 then tax else 0 end,
	 @surchargeTaxA = @surchargeTaxA + case when T.SURCHARGEAPPLIES = 1 then tax else 0 end
	 from @t T
	 where vatgc = @vatgc 
	 and sequence = @seq

	 set @taxAmount = @amount + @tax

	 update @t set 
	 cumTax = @taxamount,
	 cumCost = @cumCost
	 where vatgc = @vatgc 
	 and sequence = @seq
	 
	 FETCH NEXT FROM the_Cursor into @vatgc, @seq
	END

	CLOSE the_Cursor
	DEALLOCATE the_Cursor

  RETURN

END
		
		