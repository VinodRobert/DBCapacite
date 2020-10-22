/****** Object:  Procedure [dbo].[spPlantMonthEndPosting]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Okker Botes
-- Create date: 2009/06/18
-- Description:	Posts Fringe benefit tax to a separate account, which is not the same for all FB's.  
--  I added a cost-to LG code to the TaxFB table. (I did not want to add more Control codes )
--	I changed the asp posting to the spPostFringeBenifit stored procedure.  
--  This stored procedure makes use of the spPostTrans SP to do the balance check and commit the transaction to the transaction table. 
-- 2010-02-04 OAB
-- The botg Id was hard coded for the incurance leg.
--2010-03-29 Matthew
--  round to the decimal of the homecurrency currency, changed for multi-decimals
--2010-10-28 Matthew
--   Changed MATCHREF to be blank, this is so matching can happen against the transid
--2012-01-20 Riaan Simon
--Add fiter on orgId for Insurance
--2012-02-22 Matthew and Simon
--  PlantVariables table to have BorgId specific record
--2013-11-14 RS 
--  Add custom field INSURANCEVALUE 				

-- =============================================

-- Find out what the Bactch rev and trans rev must be
-- Find out what hte descriptions must be
-- Find out the DIVID for overhead costs
CREATE PROCEDURE [dbo].[spPlantMonthEndPosting]
	@borgid as int  = 46,
	@YearPostTo as int = '2009', 
	@YearPltCostFrom as int = '2009',
	@periodPltCostFrom as int = 1, 
	@periodPostTo as int = 1,
	@userid as int = 23,
	@BatchRef char(10) = '',
	@TransType CHAR(10) = 'PLU',
	@DoPrint bit = 1
	
AS
	SET NOCOUNT ON 
	BEGIN TRANSACTION
	declare @holdError as int	
	DECLARE @TransCount AS INT
	set @holdError = 0	
	
	if @BatchRef = ''
	begin
		set @BatchRef = 'PLU'+cast(month(GetDate())as char(2))+cast(day(GetDate())as char(2))
	end
	declare @TransRef char(10)
	set @TransRef = cast(@periodPltCostFrom as char(2)) +'/'+ cast(@YearPltCostFrom as char(4))

	SELECT  @TransCount =  COUNT(*)
	FROM         TRANSACTIONS
	WHERE     ([TransType] = @TransType) AND ([TransRef] = @Transref) and OrgId = @BorgId
	
	IF @DoPrint = 1
	BEGIN
		SELECT @TransCount AS transCount, @TransType AS [TransType], @Transref AS [TransRef]
	END

	IF @TransCount > 0
	begin
		ROLLBACK TRANSACTION
--		select 'NO'
		select 0 as DEBIT, 0 as CREDIT, 0 as HOMECURR, 0 as RI, 0 as PO, 0 as WP, 0 as Cont, 'The monthly plant charges for the selected from period and year have previously been posted' as THERESULT
		RETURN
	end --1



	declare @DIVID int
	select @DIVID = DEFDIV from borgs where borgid = @BorgId

	--declare @TransType char(10)
	declare @GriIsurCharge numeric(18, 2), @GriIsurChargeGlPlt char(10), @GriIsurChargeGl char(10), @IsurAlloc char(35) , @TotIcur as money
	declare @GriOverhCharge numeric(18, 2), @GriOverhChargeGlPlt char(10), @GriOverhChargeGL char(10), @OverAlloc char(35), @TotOver as money
	declare @GriIntrestCharge numeric(18, 2), @GriIntrestChargeGlPlt char(10), @GriIntrestChargeGl char(10), @IntrestAlolc char(35), @TotIntrest as money
	declare @GriBreakDownCharge numeric(18, 2), @GriBreakDownChargeGlPlt char(10), @GriBreakDownChargeGL char(10), @BreakDownAlloc char(35), @TotBreakDown as money
	declare @dec as int
	
	set @dec = 2
	
	select @dec = CURRENCIES.DECIMALS
	from CURRENCIES
	INNER JOIN BORGS ON CURRENCIES.CURRCODE = BORGS.CURRENCY
	WHERE BORGS.BORGID = @borgid

	SELECT  top 1  @GriIsurCharge = GriIsurCharge, @GriIsurChargeGlPlt = GriIsurChargeGlPlt, @GriIsurChargeGl = GriIsurChargeGl, @IsurAlloc = LEDGERCODES.LedgerAlloc, 
					@GriOverhCharge = GriOverhCharge, @GriOverhChargeGlPlt = GriOverhChargeGlPlt, @GriOverhChargeGL = GriOverhChargeGL, @OverAlloc = LEDGERCODES_1.LedgerAlloc,
					@GriIntrestCharge = GriIntrestCharge, @GriIntrestChargeGlPlt = GriIntrestChargeGlPlt, @GriIntrestChargeGl = GriIntrestChargeGl, @IntrestAlolc = LEDGERCODES_2.LedgerAlloc,
					@GriBreakDownCharge = GriBreakDownCharge, @GriBreakDownChargeGlPlt = GriBreakDownChargeGlPlt, @GriBreakDownChargeGL = GriBreakDownChargeGL, @BreakDownAlloc = LEDGERCODES_3.LedgerAlloc
	FROM         PlantHireVariables INNER JOIN
                      LEDGERCODES ON PlantHireVariables.GriIsurChargeGl = LEDGERCODES.LedgerCode INNER JOIN
                      LEDGERCODES AS LEDGERCODES_1 ON PlantHireVariables.GriOverhChargeGL = LEDGERCODES_1.LedgerCode INNER JOIN
                      LEDGERCODES AS LEDGERCODES_2 ON PlantHireVariables.GriIntrestChargeGl = LEDGERCODES_2.LedgerCode INNER JOIN
                      LEDGERCODES AS LEDGERCODES_3 ON PlantHireVariables.GriBreakDownChargeGL = LEDGERCODES_3.LedgerCode
                      where PlantHireVariables.borgid in (-1, @borgid) order by PlantHireVariables.borgid desc


	EXEC [dbo].[spPostTransCreatTemp] @TIndex = N'PltMonthEnd', @MakeLocal = 0

--Isurance Charges % of bookevalue ******************************************************************************************************************************************************
--2009-12-02	Change speck  the form book value to "Purchase Price" + "Additions"
--				Stop charging Insurance only when asset are scraped i.e. Book value = 0
--	set @TransType = 'PLUIS'  --PLant Uploead InSurence
	if @DoPrint = 1
	begin
		SELECT        ASSETS.AssetBookValue, CAST((ASSETS.AssetPPrice + ASSETS.AssetAdd) * @GriIsurCharge / 1200 AS money) AS debit, PLANTANDEQ.PeNumber, 
		                         PLANTANDEQ.BorgID, ASSETS.AssetPPrice, ASSETS.AssetAdd
		FROM            PLANTANDEQ INNER JOIN
		                         ASSETS ON PLANTANDEQ.PeNumber = ASSETS.AssetNumber
		WHERE        (ASSETS.AssetBookValue > 0) and PLANTANDEQ.BorgId = @Borgid
	end

	IF @holdError = 0
	BEGIN
		INSERT INTO ##TRANSACTIONSPltMonthEnd
				(Debug, OrgID, Year, Period, PDate, BatchRef, TransRef, MatchRef, 
				TransType, Allocation, LedgerCode, Description, Debit, Credit, Plantno)
		SELECT	1 As Debug, @borgid AS OrgID, @YearPostTo AS [Year], @periodPostTo AS Period, GETDATE() AS PDate,  @BatchRef as BatchRef, @TransRef as TransRef, '' as MatchRef, 
				@TransType AS TransType, 'Plant' AS Allocation, @GriIsurChargeGlPlt AS LedgerCode, 
--2013-11-14 RS Add custom field INSURANCEVALUE 				
				--'Monthly Insurance Charge %' + rtrim(ltrim(cast(@GriIsurCharge as char))) + ' of Purchase Price per year '  + rtrim(ltrim(ROUND((ASSETS.AssetPPrice + ASSETS.AssetAdd), @dec)))  AS Description, 				
        --ROUND((ASSETS.AssetPPrice + ASSETS.AssetAdd) * @GriIsurCharge / 1200, @dec) AS Debit, 0 AS Credit, ASSETS.AssetNumber AS Plantno
        'Monthly Insurance Charge %' + rtrim(ltrim(cast(@GriIsurCharge as char))) + ' of Insured value per year '  + rtrim(ltrim(ROUND((ASSETS.INSURANCEVALUE), @dec)))  AS Description,
				ROUND((ASSETS.INSURANCEVALUE) * @GriIsurCharge / 1200, @dec) AS Debit, 0 AS Credit, ASSETS.AssetNumber AS Plantno
		FROM         PLANTANDEQ INNER JOIN
							  ASSETS ON PLANTANDEQ.PeNumber = ASSETS.AssetNumber 
		WHERE ASSETS.AssetBookValue > 1 and PLANTANDEQ.BorgId = @Borgid
	--end
	SET @holdError = @@ERROR
	end

	IF @holdError = 0
	BEGIN
		SELECT     @TotIcur = SUM(Credit - Debit ) 
		FROM  ##TRANSACTIONSPltMonthEnd
		GROUP BY Debug
		HAVING      (Debug = 1)
	SET @holdError = @@ERROR
	END
	-- If no records are returned by the select check total for null and set to zero
	SET @TotIcur = ISNULL(@TotIcur,0)

	IF @holdError = 0
	BEGIN
		INSERT INTO ##TRANSACTIONSPltMonthEnd
				(Debug, OrgID, Year, Period, PDate, BatchRef, TransRef, MatchRef, 
				TransType, Allocation, LedgerCode, Description, 
				Debit, Credit, 
				Plantno, DivID)
		values (2, @borgid, @YearPostTo, @periodPostTo, GETDATE(), @BatchRef, @TransRef, '', 
				@TransType, @IsurAlloc, @GriIsurChargeGl, 'Monthly Insurance Charge ',
				 case when  @TotIcur >= 0 then abs(@TotIcur) else 0 end, 
				case when  @TotIcur <= 0 then abs(@TotIcur) else 0 end, 
				'', @DIVID)
	SET @holdError = @@ERROR
	end


--Overheads Charges  % of revanue ******************************************************************************************************************************************************
	--set @TransType = 'PLUOV'  --PLant Uploead OVerheads
	if @DoPrint = 1
	begin  
		SELECT     OrgID, Year, Period, Plantno, TransType, Allocation, SUM(Debit) AS Expr1, SUM(Credit) AS Expr2
		FROM         TRANSACTIONS
		WHERE     (TransType = 'IPH Req') AND (Allocation = 'plant') AND (Period = @periodPltCostFrom) AND (Year = @yearPltCostFrom) AND (OrgID = 46) OR
							  (TransType = 'IPH PB') AND (Allocation = 'plant') AND (Period = @periodPltCostFrom) AND (Year = @yearPltCostFrom) AND (OrgID = 46)
		GROUP BY TransType, Allocation, Year, Period, Plantno, OrgID
		ORDER BY Year DESC, Period DESC
	end

	IF @holdError = 0
	BEGIN
		INSERT INTO ##TRANSACTIONSPltMonthEnd
				(Debug, OrgID, Year, Period, PDate, BatchRef, TransRef, MatchRef, 
				TransType, Allocation, LedgerCode, Description, 
				Debit, Credit, Plantno)
		--SELECT   3, OrgID, Year, Period, Plantno, TransType, Allocation, SUM(Debit) AS Expr1, SUM(Credit) AS Expr2
		SELECT  3 as Debug, @borgid AS OrgID, @YearPostTo AS Year, @periodPostTo AS Period, GETDATE() AS PDate, @BatchRef AS BatchRef, @TransRef AS TransRef, '' AS MatchRef, 
				@TransType AS TransType, 'Plant' AS Allocation, @GriOverhChargeGlPlt AS LedgerCode, 
				'Monthly Overheads Charge %' + rtrim(ltrim(cast(@GriOverhCharge as char))) + ' of revenue per month '  + rtrim(ltrim(cast(-1*(SUM(Debit)-SUM(Credit)) as char)))  AS Description, 
				ROUND(-1*(SUM(Debit)-SUM(Credit))* @GriOverhCharge / 100.0, @dec) AS Debit, 0 AS Credit, Plantno AS Plantno
		FROM         TRANSACTIONS
		WHERE     (TransType = 'IPH Req') AND (Allocation = 'plant') AND (Period = @periodPltCostFrom) AND (Year = @yearPltCostFrom) AND (OrgID = @BorgID) OR
                  (TransType = 'IPH PB') AND (Allocation = 'plant') AND (Period = @periodPltCostFrom) AND (Year = @yearPltCostFrom) AND (OrgID = @BorgID)
		GROUP BY TransType, Allocation, Year, Period, Plantno, OrgID
		ORDER BY Year DESC, Period DESC
	SET @holdError = @@ERROR
	end

	IF @holdError = 0
	BEGIN
		SELECT     @TotOver = SUM(Credit - Debit ) 
		FROM  ##TRANSACTIONSPltMonthEnd
		GROUP BY Debug
		HAVING      (Debug = 3)
	SET @holdError = @@ERROR
	end
	-- If no records are returned by the select check total for null and set to zero
	set @TotOver = IsNull(@TotOver,0)

	IF @holdError = 0
	BEGIN
		INSERT INTO ##TRANSACTIONSPltMonthEnd
				(Debug, OrgID, Year, Period, PDate, BatchRef, TransRef, MatchRef, 
				TransType, Allocation, LedgerCode, Description, Debit, Credit, Plantno, DivID)
		values (4, @borgid, @YearPostTo, @periodPostTo, GETDATE(), @BatchRef, @TransRef, '', 
				@TransType, @OverAlloc, @GriOverhChargeGl, 'Monthly Overheads Charge ',
				case when  @TotOver >= 0 then abs(@TotOver) else 0 end, 
				case when  @TotOver <= 0 then abs(@TotOver) else 0 end, 
				'', @DIVID)

	SET @holdError = @@ERROR
	end

--Intrest charges % of book value only if item genarated income ***************************************************************************************************************************************
	--set @TransType = 'PLUIN'  --PLant Uploead INtrest
	if @DoPrint = 1
	begin  
		select 'Intrest charges % of book value only if item genarated income' as type
		SELECT        TRANSACTIONS.OrgID, TRANSACTIONS.Year, TRANSACTIONS.Period, TRANSACTIONS.Plantno, TRANSACTIONS.TransType, TRANSACTIONS.Allocation, 
		                         SUM(TRANSACTIONS.Debit) AS SumDebit, SUM(TRANSACTIONS.Credit) AS SumCredit, ASSETS.AssetBookValue
		FROM            TRANSACTIONS INNER JOIN
		                         ASSETS ON TRANSACTIONS.Plantno = ASSETS.AssetNumber
		WHERE       (TRANSACTIONS.TransType = 'IPH Req')	AND (TRANSACTIONS.Allocation = 'plant') AND (TRANSACTIONS.Period = @periodPltCostFrom) AND 
					(TRANSACTIONS.Year = @yearPltCostFrom)	AND (TRANSACTIONS.OrgID = @BorgID) AND (ASSETS.AssetBookValue > 1) 
					OR
					(TRANSACTIONS.TransType = 'IPH PB') AND (TRANSACTIONS.Allocation = 'plant') AND (TRANSACTIONS.Period = @periodPltCostFrom) AND 
					(TRANSACTIONS.Year = @yearPltCostFrom) AND (TRANSACTIONS.OrgID = @BorgID) AND (ASSETS.AssetBookValue > 1)
					
		GROUP BY TRANSACTIONS.TransType, TRANSACTIONS.Allocation, TRANSACTIONS.Year, TRANSACTIONS.Period, TRANSACTIONS.Plantno, TRANSACTIONS.OrgID, 
		                         TRANSACTIONS.OrgID, ASSETS.AssetBookValue
		ORDER BY TRANSACTIONS.Year DESC, TRANSACTIONS.Period DESC
	end

	IF @holdError = 0
	BEGIN
		INSERT INTO ##TRANSACTIONSPltMonthEnd
				(Debug, OrgID, Year, Period, PDate, BatchRef, TransRef, MatchRef, 
				TransType, Allocation, LedgerCode, Description, 
				Debit, Credit, Plantno)
		SELECT        5 AS Debug, @borgid AS OrgID, @YearPostTo AS Year, @periodPostTo AS Period, GETDATE() AS PDate, @BatchRef AS BatchRef, @TransRef AS TransRef, 
                 '' AS MatchRef, @TransType AS TransType, 'Plant' AS Allocation, @GriIntrestChargeGlPlt AS LedgerCode, 
                 'Monthly Intrest Charge %' + rtrim(ltrim(cast(@GriIntrestCharge as char))) + ' per year of book value '  + rtrim(ltrim(cast(ASSETS.AssetBookValue as char)))  AS Description, 
                 ROUND(ASSETS.AssetBookValue * @GriIntrestCharge / 1200.0, @dec) AS Debit,
                  0 AS Credit,
                  TRANSACTIONS.Plantno
		FROM            TRANSACTIONS INNER JOIN
				 ASSETS ON TRANSACTIONS.Plantno = ASSETS.AssetNumber
		WHERE       (TRANSACTIONS.TransType = 'IPH Req')	AND (TRANSACTIONS.Allocation = 'plant') AND (TRANSACTIONS.Period = @periodPltCostFrom) AND 
					(TRANSACTIONS.Year = @yearPltCostFrom)	AND (TRANSACTIONS.OrgID = @BorgID) AND (ASSETS.AssetBookValue > 1) 
					OR
					(TRANSACTIONS.TransType = 'IPH PB') AND (TRANSACTIONS.Allocation = 'plant') AND (TRANSACTIONS.Period = @periodPltCostFrom) AND 
					(TRANSACTIONS.Year = @yearPltCostFrom) AND (TRANSACTIONS.OrgID = @BorgID) AND (ASSETS.AssetBookValue > 1)
				
		GROUP BY TRANSACTIONS.TransType, TRANSACTIONS.Allocation, TRANSACTIONS.Year, TRANSACTIONS.Period, TRANSACTIONS.Plantno, TRANSACTIONS.OrgID, 
		                         TRANSACTIONS.OrgID, ASSETS.AssetBookValue
		ORDER BY Year DESC, Period DESC
	SET @holdError = @@ERROR
	end

	IF @holdError = 0
	BEGIN
		SELECT     @TotIntrest = SUM(Credit - Debit ) 
		FROM  ##TRANSACTIONSPltMonthEnd
		GROUP BY Debug
		HAVING      (Debug = 5)
	SET @holdError = @@ERROR
	end
-- If no records are returned by the select check total for null and set to zero	
	set @TotIntrest = IsNull(@TotIntrest,0)

	IF @holdError = 0
	BEGIN
		INSERT INTO ##TRANSACTIONSPltMonthEnd
				(Debug, OrgID, Year, Period, PDate, BatchRef, TransRef, MatchRef, 
				TransType, Allocation, LedgerCode, Description, 
				Debit, Credit, 
				Plantno, DivID)
		values (6, @borgid, @YearPostTo, @periodPostTo, GETDATE(), @BatchRef, @TransRef, '', 
				@TransType, @IntrestAlolc, @GriIntrestChargeGl, 'Monthly Intrest Charge ',
				case when  @TotIntrest >= 0 then abs(@TotIntrest) else 0 end, 
				case when  @TotIntrest <= 0 then abs(@TotIntrest) else 0 end, 
				'', @DIVID)
	SET @holdError = @@ERROR
	end

-- Break down prevision	% of revenue *******************************************************************************************************************
	--set @TransType = 'PLUBD'  --PLant Break Down prevision
	if @DoPrint = 1
	begin  
		SELECT     OrgID, Year, Period, Plantno, TransType, Allocation, SUM(Debit) AS Expr1, SUM(Credit) AS Expr2
		FROM         TRANSACTIONS
		WHERE     (TransType = 'IPH Req') AND (Allocation = 'plant') AND (Period = @periodPltCostFrom) AND (Year = @yearPltCostFrom) AND (OrgID = @BorgId) OR
							  (TransType = 'IPH PB') AND (Allocation = 'plant') AND (Period = @periodPltCostFrom) AND (Year = @yearPltCostFrom) AND (OrgID = @BorgId)
		GROUP BY TransType, Allocation, Year, Period, Plantno, OrgID
		ORDER BY Year DESC, Period DESC
	end

	IF @holdError = 0
	BEGIN
		INSERT INTO [##TRANSACTIONSPltMonthEnd]
                      (Debug, OrgID, Year, Period, PDate, BatchRef, TransRef, MatchRef, TransType, Allocation, LedgerCode, Description, Debit, Credit, Plantno)
		SELECT     7 AS Debug, @borgid AS OrgID, @YearPostTo AS Year, @periodPostTo AS Period, GETDATE() AS PDate, @BatchRef AS BatchRef, @TransRef AS TransRef, 
						  '' AS MatchRef, @TransType AS TransType, 'Plant' AS Allocation, @GriBreakDownChargeGlPlt AS LedgerCode, 
						  'Break down prevision %' + RTRIM(LTRIM(CAST(@GriBreakDownCharge AS char))) + ' of revenue per month ' + RTRIM(LTRIM(CAST(- (1 * (SUM(Debit) - SUM(Credit))) 
						  AS char))) AS Description, CASE WHEN SUM(Debit) - SUM(Credit) <= 0 THEN ABS(ROUND((SUM(Debit) - SUM(Credit)) * @GriBreakDownCharge / 100.0, @dec)) 
						  ELSE 0 END AS Debit, 0 AS Credit, Plantno
		FROM         TRANSACTIONS
		WHERE     (TransType = 'IPH Req') AND (Allocation = 'plant') AND (Period = @periodPltCostFrom) AND (Year = @yearPltCostFrom) AND (OrgID = @borgid) OR
				(TransType = 'IPH PB') AND (Allocation = 'plant') AND (Period = @periodPltCostFrom) AND (Year = @yearPltCostFrom) AND (OrgID = @borgid)
		GROUP BY TransType, Allocation, Year, Period, Plantno, OrgID
		HAVING      (((SUM(Debit) - SUM(Credit)) * @GriBreakDownCharge / 100.0) <> 0) 
ORDER BY Year DESC, Period DESC
	SET @holdError = @@ERROR
	end

	IF @holdError = 0
	BEGIN
		SELECT     @TotBreakDown = SUM(Credit - Debit ) 
		FROM  ##TRANSACTIONSPltMonthEnd
		GROUP BY Debug
		HAVING      (Debug = 7)
	SET @holdError = @@ERROR
	end
	-- If no records are returned by the select check total for null and set to zero
	set @TotBreakDown = IsNull(@TotBreakDown,0)

	IF @holdError = 0
	BEGIN
		INSERT INTO ##TRANSACTIONSPltMonthEnd
				(Debug, OrgID, Year, Period, PDate, BatchRef, TransRef, MatchRef, 
				TransType, Allocation, LedgerCode, Description, Debit, Credit, Plantno, DivID)
		values (8, @borgid, @YearPostTo, @periodPostTo, GETDATE(), @BatchRef, @TransRef, '', 
				@TransType, @BreakDownAlloc, @GriBreakDownChargeGl, 'Break down prevision',
				case when  @TotBreakDown >= 0 then abs(@TotBreakDown) else 0 end, 
				case when  @TotBreakDown <= 0 then abs(@TotBreakDown) else 0 end, 
				'', @DIVID)

	SET @holdError = @@ERROR
	end


	if @DoPrint = 1
	begin      
		select * from ##TRANSACTIONSPltMonthEnd
	end	

-- Now call B-Check and posting
	declare	@DEBIT money,
			@CREDIT money,
			@HOMECURR money,
			@RI money,
			@PO money,
			@WP money,
			@Cont money,
			@THERESULT nvarchar(200)
			
	exec spPostTrans  
		@TIndex = N'PltMonthEnd',
		@_DEBIT = @DEBIT output,
		@_CREDIT = @CREDIT output, 
		@_HOMECURR = @HOMECURR output, 
		@_RI = @RI output, 
		@_PO =  @PO output, 
		@_WP = @WP output, 
		@_Cont = @Cont output, 
		@_THERESULT = @THERESULT output,
		@DoPrint = @DoPrint


	if @HoldError = 0 and @THERESULT = 'OK' --1
	begin
		COMMIT TRANSACTION
--		select 'OK'
		select @DEBIT as DEBIT, @CREDIT as CREDIT, @HOMECURR as HOMECURR, @RI as RI, @PO as PO, @WP as WP, @Cont as Cont, @THERESULT as THERESULT
	end
	else --1
	begin
		ROLLBACK TRANSACTION
--		select 'NO'
		select @DEBIT as DEBIT, @CREDIT as CREDIT, @HOMECURR as HOMECURR, @RI as RI, @PO as PO, @WP as WP, @Cont as Cont, @THERESULT as THERESULT
	end --1
	
	