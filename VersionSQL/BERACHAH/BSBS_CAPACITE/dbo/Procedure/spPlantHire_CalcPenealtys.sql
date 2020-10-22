/****** Object:  Procedure [dbo].[spPlantHire_CalcPenealtys]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [spPlantHire_CalcPenealtys]

	@PBHid int, 
	@user int, 
	@chrFromWhere nChar(20) = 'BachUpdate',
	@theDate as datetime = null
	
AS
--***********************************************************************************************************************
--DATE 10-12-2006
--SET XACT_ABORT ON -- Abort the transction on error
--SET DATEFORMAT dmy --OAB 08/10/2006 Change the FDate and TDate to read from the DB and not a input parameter 
--OAB 19/04/2007 Add Overheads 
--OAB 02/04/2008 When Brake Down was in Days the system did not the Penalty hour correctly, fix this
/* OAB 2007/05/12 
   Set the then fits day of week to Saturday for UAE
*/
--2011-09-14 KSN
--  check for division by zero.
--2011-09-19 KSN
--  Recalc to follow hierachy of flag types - tested at shaft only.
--2012-02-22 Matthew and Simon
--  PlantVariables table to have BorgId specific record
--2013-11-07 RS 
--  Add filter in flagId
--2014-08-08 RS
--  Fixed the amount of days for Fixed Monthly rate. Added 1 day to what the Curser counter returns
--***********************************************************************************************************************

declare @firstDay int
declare @orgid int

select @orgid = BorgID from PlantHirePBHeader WHERE PBHid = @PBHid

SELECT  top 1 @firstDay= HireVFirstDayOfWeeek FROM PlantHireVariables where borgid in (-1, @orgid) order by borgid desc
--SELECT @firstDay as FDay
set DATEFIRST  @firstDay

if @theDate is null 
    set @theDate = getdate()

DECLARE @holdError INT
SET @holdError = 0
BEGIN TRANSACTION

--The bach dates
declare @chrFDATE datetime , @chrTDATE datetime

SELECT @chrFDATE = PBHfDate, @chrTDATE = PBHtDate
FROM    PlantHirePBHeader
WHERE (PBHid = @PBHid) 
SELECT @holdError = @@error IF @holdError <> 0 or @chrFDATE is Null BEGIN ROLLBACK TRANSACTION RETURN @PBHid END



DECLARE @cPeNum char(10), @cPeCalcM char(10), @cRHid int, @cContNum nvarchar(10), @cDebtNum char(10), @cDivToID int,
	@coSMR  numeric(18, 2), @ccSMR as numeric(18, 2), @cDivSMR numeric(18, 2),
	@cQ1 as numeric(12,2), @cQ2 as numeric(12,2), @cQ3 as numeric(12,2), @cQ4 as numeric(12,2), @cQ5 as numeric(12,2),
	@cIsActW1 bit, @cIsActW2 bit, @cIsActW3 bit, @cIsActW4 bit, @isActW5 bit,
	@cIsFix1 bit, @cIsFix2 bit, @cIsFix3 bit, @cIsFix4 bit, @cIsFix5 bit,
	@cIsBD1 bit, @cIsBD2 bit, @cIsBD3 bit, @cIsBD4 bit, @cIsBD5 bit,
	@cUnit1 char(10), @cUnit2 char(10), @cUnit3 char(10), @cUnit4 char(10), @cUnit5 char(10),
	@cIsPenToWeekend bit, @cIsPenToHoliday bit,
	@cTheDate datetime, @cIsPenDay bit, @cIsHoliday bit, @cPenAct char(10), @cCatBal bit, @cCatMinPerDay numeric(18, 1), @ToBorgId int

--@isBD is Breakdown 

DECLARE	@VARoSMR numeric(18, 2), @VARcSMR numeric(18, 2), 
		@actWorkHr numeric(12,2), @actWorkHrTot numeric(12,2),
		@VarBD numeric(12, 2), @isFixed bit

DECLARE @fixedDays as int, @fixedUnit char(10), @fixedRateNum int

DECLARE @DPW float --Days Per Week
SET @DPW = (SELECT TOP 1 HireVDayPerWeek FROM PlantHireVariables where borgid in (-1, @orgid) order by borgid desc)
 
DECLARE InCur   CURSOR SCROLL OPTIMISTIC  for 
SELECT  PHH.PeNumber, PHH.PBHPenaltyCalc, PRH.PBRHid, PRH.ContrNumber, PRH.DebtNumber, PRH.DivToID, 
		PRH.PBRHOpenSMR, PRH.PBHRCloseSMR, PRH.PBHRDifSMR, 
		PRH.PBRHq1, PRH.PBRHq2, PRH.PBRHq3, PRH.PBRHq4, PRH.PBRHq5, 
		PCat.CatActWorkHr1, PCat.CatActWorkHr2, PCat.CatActWorkHr3, PCat.CatActWorkHr4, PCat.CatActWorkHr5, 
		PCat.CatIsFixed1, PCat.CatIsFixed2, PCat.CatIsFixed3, PCat.CatIsFixed4, PCat.CatIsFixed5, 
		PCat.CatIsBreakdown1, PCat.CatIsBreakdown2, PCat.CatIsBreakdown3, PCat.CatIsBreakdown4, PCat.CatIsBreakdown5, 
		PCat.CatUnit1, PCat.CatUnit2, PCat.CatUnit3, PCat.CatUnit4, PCat.CatUnit5, 
		PCat.CatPenToWeekend, PCat.CatPenToHolidays, PCat.CatPenAct, PRH.PBRHDate, PCat.CatBatchBalance, PCat.HireRDayMin
FROM     PlantHirePBReturnsHead AS PRH INNER JOIN
               PlantHirePBHeader AS PHH ON PRH.PBHid = PHH.PBHid INNER JOIN
               PLANTANDEQ ON PHH.PeNumber = PLANTANDEQ.PeNumber INNER JOIN
               PLANTCATEGORIES AS PCat ON PLANTANDEQ.CatID = PCat.CatID
WHERE  (PHH.PBHid = @PBHid) AND (PRH.PBRHPostFlag <> 3)
ORDER BY PRH.PBHid, PRH.PBRHDate, PRH.ContrNumber, PRH.PBRHSortFlag, PRH.PBRHid, PRH.PBRHOpenSMR, PRH.PBHRCloseSMR
		
	FOR UPDATE 
		
OPEN InCur 
		
FETCH NEXT FROM InCur 
Into @cPeNum, @cPeCalcM, @cRHid, @cContNum, @cDebtNum, @cDivToID,
	@coSMR, @ccSMR, @cDivSMR, 
	@cQ1, @cQ2, @cQ3, @cQ4, @cQ5, 
	@cIsActW1, @cIsActW2, @cIsActW3, @cIsActW4, @isActW5,
	@cIsFix1, @cIsFix2, @cIsFix3, @cIsFix4, @cIsFix5,
	@cIsBD1, @cIsBD2, @cIsBD3, @cIsBD4, @cIsBD5,
	@cUnit1, @cUnit2, @cUnit3, @cUnit4, @cUnit5,
	@cIsPenToWeekend, @cIsPenToHoliday, @cPenAct, @cTheDate, @cCatBal, @cCatMinPerDay 


if @@FETCH_STATUS = 0
begin
	if @cIsFix1 <> 0 or @cIsFix2 <> 0 or @cIsFix3 <> 0 or @cIsFix4 <> 0 or @cIsFix5 <> 0
	begin
		set @isFixed = 1

		if @cIsFix1 <> 0 
		begin
			set @fixedUnit = @cUnit1
			set @fixedRateNum = 1
		end 
		else if @cIsFix2 <> 0
		begin
			set @fixedUnit = @cUnit2
			set @fixedRateNum = 2
		end
		else if @cIsFix3 <> 0
		begin
			set @fixedUnit = @cUnit3
			set @fixedRateNum = 3
		end
		else if @cIsFix4 <> 0
		begin	
			set @fixedUnit = @cUnit4
			set @fixedRateNum = 4
		end
		else if @cIsFix5 <> 0
		begin
			set @fixedUnit = @cUnit5
			set @fixedRateNum = 5
		end
		else
		begin
			set @fixedUnit = 'noUnit'
			set @fixedRateNum = -1
		end
	end
	else
		set @isFixed = 0
end

set @ToBorgId = (select case when C.CONTRNUMBER is not null then P.BORGID else case when D.DivID is not null then D.BorgID else PHH.BorgID end end ToBorgId
                from PlantHirePBReturnsHead H
                INNER JOIN PlantHirePBHeader AS PHH ON H.PBHid = PHH.PBHid and H.PBRHid = @cRHid
                left outer join contracts C on H.ContrNumber = C.CONTRNUMBER left outer join Projects P on C.PROJID = p.PROJID
                left outer join divisions D on H.DivToID = D.DivID)
set @actWorkHrTot = 0

WHILE @@FETCH_STATUS = 0 AND @holdError = 0
BEGIN	
	--Select @cContNum as cContNum, @cPeNum as cPeNum, @cRHid as cRHid

-- Determine if this day is a penalty day
	set @cIsPenDay = 1
	--Select DATEPART (dw, @cTheDate) as theDayNum, DATENAME(dw, @cTheDate) as theDayWord, @cTheDate as Date, @cPeNum as PeNum

-- First  check to see if penalties apply to week ends  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	if @cIsPenToWeekend = 0
		/*If penalties do not apply to weekends 
		Then check each day to see if it falls on a weekend day
		And if it falls on a weekend mark is as not being a penalty day
		i.e. set @cIsPenDay = 0  */
	begin
		
		if   @DPW <= 0
		begin 
			if  DATEPART (dw, @cTheDate)= 1 or DATEPART (dw, @cTheDate)= 2 
			or DATEPART (dw, @cTheDate)= 3 or DATEPART (dw, @cTheDate)= 4 
			or DATEPART (dw, @cTheDate)= 5 or DATEPART (dw, @cTheDate)= 6 
			or DATEPART (dw, @cTheDate) = 7 
			begin			
				--Select 'YES is Weekend' as YES0
				set @cIsPenDay = 0
			end
		end
		else if   @DPW <= 1
		begin 
			if  DATEPART (dw, @cTheDate)= 2 or DATEPART (dw, @cTheDate)= 3 
			or DATEPART (dw, @cTheDate)= 4 or DATEPART (dw, @cTheDate)= 5 
			or DATEPART (dw, @cTheDate)= 6 or DATEPART (dw, @cTheDate) = 7 
			begin			
				--Select 'YES is Weekend' as YES1
				set @cIsPenDay = 0
			end
		end
		else if   @DPW <= 2
		begin 
			if  DATEPART (dw, @cTheDate)= 3 or DATEPART (dw, @cTheDate)= 4 
			or DATEPART (dw, @cTheDate)= 5 or DATEPART (dw, @cTheDate)= 6 
			or DATEPART (dw, @cTheDate) = 7 
			begin			
				--Select 'YES is Weekend' as YES2
				set @cIsPenDay = 0
			end
		end
		else if   @DPW <= 3
		begin 
			if  DATEPART (dw, @cTheDate)= 4 or DATEPART (dw, @cTheDate)= 5 
			or DATEPART (dw, @cTheDate)= 6 or DATEPART (dw, @cTheDate) = 7 
			begin			
				--Select 'YES is Weekend' as YES3
				set @cIsPenDay = 0
			end
		end
		else if   @DPW <= 4
		begin 
			if  DATEPART (dw, @cTheDate)= 5 or DATEPART (dw, @cTheDate)= 6 
			or DATEPART (dw, @cTheDate) = 7 
			begin			
				--Select 'YES is Weekend' as YES4
				set @cIsPenDay = 0
			end
		end
		else if   @DPW <= 5 
		begin 
			if  DATEPART (dw, @cTheDate)= 6 or DATEPART (dw, @cTheDate) = 7 
			begin			
				--Select 'YES is Weekend' as YES5
				set @cIsPenDay = 0
			end
		end
		else if   @DPW <= 6 
		begin 
			if   DATEPART (dw, @cTheDate) = 7 
			begin			
				--Select 'YES is Weekend' as YES6
				set @cIsPenDay = 0
			end
		end
		else if   @DPW <= 7 
		begin 
			if   DATEPART (dw, @cTheDate) = 8 
			begin			
				--Select 'YES is Weekend' as YES8
				set @cIsPenDay = 0
			end
		end
	end
		
	--select @cIsPenDay as isPenWeekend


	update PlantHirePBReturnsHead set 
		PBRHIsWeekday = @cIsPenDay
	where current of InCur
	SELECT @holdError = @@error IF @holdError <> 0 BEGIN ROLLBACK TRANSACTION RETURN @PBHid END

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- First  check to see if penalties apply to Holidays  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	--select @cIsPenToHoliday as FlagHoliday

	set @cIsHoliday = 0

	if exists (SELECT *, DebtNumber AS Expr1, ContrNumber AS Expr2
			   --FROM PlantHirePublicHolidays
         FROM PLANTHIREPUBLICHOLIDAYS PHPH   
         INNER JOIN LOCALES LOC ON PHPH.CuntryCode = LOC.COUNTRYID 
         INNER JOIN BORGS B ON LOC.LOCALEID = B.LOCALE AND B.BORGID = @ToBorgId 
			   WHERE (HirePDDate = @cTheDate)AND (ContrNumber IS NULL) AND (DebtNumber IS NULL) )
	begin	
		set @cIsHoliday = 1
	end

--Check to see if the contract haze a holiday assign to it   
	if exists (SELECT *, DebtNumber AS Expr1, ContrNumber AS Expr2
			   FROM PlantHirePublicHolidays PHPH   
         INNER JOIN LOCALES LOC ON PHPH.CuntryCode = LOC.COUNTRYID 
         INNER JOIN BORGS B ON LOC.LOCALEID = B.LOCALE AND B.BORGID = @ToBorgId
			   WHERE (HirePDDate = @cTheDate) AND (ContrNumber = @cContNum) AND (DebtNumber IS NULL) AND HirePDisHoliday = 1 )
	begin	
		set @cIsHoliday = 1
	end
--Check to see if the contract haze a holiday assign to it   AND IF IT IS DISABLED
	if exists (SELECT *, DebtNumber AS Expr1, ContrNumber AS Expr2
			   FROM PlantHirePublicHolidays PHPH   
         INNER JOIN LOCALES LOC ON PHPH.CuntryCode = LOC.COUNTRYID 
         INNER JOIN BORGS B ON LOC.LOCALEID = B.LOCALE AND B.BORGID = @ToBorgId
			   WHERE (HirePDDate = @cTheDate) AND (ContrNumber = @cContNum) AND (DebtNumber IS NULL) AND HirePDisHoliday = 0 )
	begin	
		set @cIsHoliday = 0
	end	

	
--Check to see if the Debtor haze a holiday assign to it   
	if exists (SELECT *, DebtNumber AS Expr1, ContrNumber AS Expr2
			   FROM PlantHirePublicHolidays PHPH   
         INNER JOIN LOCALES LOC ON PHPH.CuntryCode = LOC.COUNTRYID 
         INNER JOIN BORGS B ON LOC.LOCALEID = B.LOCALE AND B.BORGID = @ToBorgId
			   WHERE (HirePDDate = @cTheDate) AND (ContrNumber IS NULL) AND 
				  (HirePDisHoliday = 1) AND (DebtNumber = @cDebtNum) )
	begin	
		set @cIsHoliday = 1
	end
--Check to see if the Debtor haze a holiday assign to it   AND IF IT IS DISABLED
	if exists (SELECT *, DebtNumber AS Expr1, ContrNumber AS Expr2
			   FROM PlantHirePublicHolidays PHPH   
         INNER JOIN LOCALES LOC ON PHPH.CuntryCode = LOC.COUNTRYID 
         INNER JOIN BORGS B ON LOC.LOCALEID = B.LOCALE AND B.BORGID = @ToBorgId
			   WHERE (HirePDDate = @cTheDate) AND (ContrNumber IS NULL) AND (DebtNumber = @cDebtNum) AND HirePDisHoliday = 0 )
	begin	
		set @cIsHoliday = 0
	end

	if @cIsPenToHoliday = 0
		/*If penalties do not apply to Holidays 
		Then check each day to see if it falls on a holiday
		And if it falls on a holiday mark is as not being a penalty day
		i.e. set @cIsPenDay = 0  */
	begin
		if @cIsHoliday = 1
		begin
			--select 'This is a holiday' as IsHoliday
			set @cIsPenDay = 0
		end
	end

	--select @cIsPenDay as isPenHoliday

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


-- Calculat the Breakdown HR
-- Breakdown hours is only applicable if penalties can be charge
-- If this is a fixed cost calculation convert Hr to Days (All fixed cost calculations is based on a day basses)
--	Only Hr and Days are applicable to fixed cost charges

	set @VarBD = 0
	if @cIsBD1 = 1
	begin
		if @isFixed = 1
		begin
			if @cUnit1 = 'Hr' 
				set @VarBD = @VarBD + @cQ1 / (SELECT TOP 1 HireVHrPerDay FROM PlantHireVariables where borgid in (-1, @orgid) order by borgid desc)
			else if @cUnit1 = 'Day'
				set @VarBD = @VarBD + @cQ1
			else
				set @VarBD = @VarBD + 0
		end
		else
		--OAB 02/04/2008 When Brake Down was in Days the system did not the Penalty hour correctly, fix this
		begin
			if @cUnit1 = 'Day'
				set @VarBD = @VarBD + @cQ1 * @cCatMinPerDay 
			else
				set @VarBD = @VarBD + @cQ1
		end	
	end				
	if @cIsBD2 = 1
	begin
		if @isFixed = 1
		begin
			if @cUnit2 = 'Hr' 
				set @VarBD = @VarBD + @cQ2 / (SELECT TOP 1 HireVHrPerDay FROM PlantHireVariables where borgid in (-1, @orgid) order by borgid desc)
			else if @cUnit2 = 'Day'
				set @VarBD = @VarBD + @cQ2
			else
				set @VarBD = @VarBD + 0
		end
		else
		--OAB 02/04/2008 When Brake Down was in Days the system did not the Penalty hour correctly, fix this
		begin
			if @cUnit2 = 'Day'
				set @VarBD = @VarBD + @cQ2 * @cCatMinPerDay 
			else
				set @VarBD = @VarBD + @cQ2
		end	
	end			
	
	if @cIsBD3 = 1
	begin
		if @isFixed = 1
		begin
			if @cUnit3 = 'Hr' 
				set @VarBD = @VarBD + @cQ3 / (SELECT TOP 1 HireVHrPerDay FROM PlantHireVariables where borgid in (-1, @orgid) order by borgid desc)
			else if @cUnit3 = 'Day'
				set @VarBD = @VarBD + @cQ3
			else
				set @VarBD = @VarBD + 0
		end
		else
		--OAB 02/04/2008 When Brake Down was in Days the system did not the Penalty hour correctly, fix this
		begin
			if @cUnit3 = 'Day'
				set @VarBD = @VarBD + @cQ3 * @cCatMinPerDay 
			else
				set @VarBD = @VarBD + @cQ3
		end		
	end	
	if @cIsBD4 = 1
	begin
		if @isFixed = 1
		begin
			if @cUnit4 = 'Hr' 
				set @VarBD = @VarBD + @cQ4 / (SELECT TOP 1 HireVHrPerDay FROM PlantHireVariables where borgid in (-1, @orgid) order by borgid desc)
			else if @cUnit4 = 'Day'
				set @VarBD = @VarBD + @cQ4
			else
				set @VarBD = @VarBD + 0
		end
		else
		--OAB 02/04/2008 When Brake Down was in Days the system did not the Penalty hour correctly, fix this
		begin
			if @cUnit4 = 'Day'
				set @VarBD = @VarBD + @cQ4 * @cCatMinPerDay 
			else
				set @VarBD = @VarBD + @cQ4
		end
	end
	if @cIsBD5 = 1
	begin
		if @isFixed = 1
		begin
			if @cUnit5 = 'Hr' 
				set @VarBD = @VarBD + @cQ5 / (SELECT TOP 1 HireVHrPerDay FROM PlantHireVariables where borgid in (-1, @orgid) order by borgid desc)
			else if @cUnit5 = 'Day'
				set @VarBD = @VarBD + @cQ5
			else
				set @VarBD = @VarBD + 0
		end
		else
		--OAB 02/04/2008 When Brake Down was in Days the system did not the Penalty hour correctly, fix this
		begin
			if @cUnit5 = 'Day'
				set @VarBD = @VarBD + @cQ5 * @cCatMinPerDay 
			else
				set @VarBD = @VarBD + @cQ5
		end
	end

	if @cIsPenDay = 1 and @VarBD = 0
	begin	
		set @VarBD = NULL 	-- no penalties applicable 
	end
	else if @cIsPenDay = 0 and @VarBD <> 0
		set @VarBD = 0
		/* There is penalty hours allocated to this day 
		but the day falls on a Holiday or a Weekend 
		and can not accumulate penalties. 
		I set the penalties to 0 to show this. */
	else if @cIsPenDay = 0 and @VarBD = 0
		set @VarBD = NULL	-- no penalties applicable 


-- Calculat the ACTUAL WORK HR
	set @actWorkHr = 0
	if @cIsActW1 = 1 
	begin
		set @actWorkHr = @actWorkHr + @cQ1 
		set @actWorkHrTot = @actWorkHrTot + @cQ1 	
	end
	if @cIsActW2 = 1
	begin
		set @actWorkHr = @actWorkHr + @cQ2
		set @actWorkHrTot = @actWorkHrTot + @cQ2
	end 	
	if @cIsActW3 = 1
	begin
		set @actWorkHr = @actWorkHr + @cQ3
		set @actWorkHrTot = @actWorkHrTot + @cQ3
	end
	if @cIsActW4 = 1
	begin
		set @actWorkHr = @actWorkHr + @cQ4
		set @actWorkHrTot = @actWorkHrTot + @cQ4
	end
	if @isActW5 = 1
	begin
		set @actWorkHr = @actWorkHr + @cQ5
		set @actWorkHrTot = @actWorkHrTot + @cQ5
	end
	


	update PlantHirePBReturnsHead 
		set PBHRActulWorkHr = @actWorkHr,
		PBHRBreakdownHr = @VarBD,
		PBRHIsPenDay = @cIsPenDay,
		PBRHIsHoliday = @cIsHoliday
	where current of InCur
	SELECT @holdError = @@error IF @holdError <> 0 BEGIN ROLLBACK TRANSACTION RETURN @PBHid END
	--select @actWorkHr as WorkHR, @actWorkHrTot as WorkHRTot


-- Calculate the DifSMR
	if @coSMR IS not NULL
	begin
		
		Set @VARoSMR = @coSMR
		--select @coSMR as oSMR2, @VARoSMR as VARoSMR
	end

	--select @ccSMR as TheCloseSMR
	if  @ccSMR IS  not NULL
	begin
	--select @actWorkHrTot - (@ccSMR - @VARoSMR) as Varinace2

		UPDATE PlantHirePBReturnsHead
		SET PBHRDifSMR = @ccSMR - @VARoSMR, 
		PBHRVariance = @actWorkHrTot - (@ccSMR - @VARoSMR)
		WHERE CURRENT of InCur
		SELECT @holdError = @@error IF @holdError <> 0 BEGIN ROLLBACK TRANSACTION RETURN @PBHid END

		set @actWorkHrTot = 0
		set @VARoSMR = NULL
	end
	else
	begin

		UPDATE PlantHirePBReturnsHead
		SET PBHRDifSMR = NULL,
		PBHRVariance = NULL
		WHERE CURRENT of InCur
		SELECT @holdError = @@error IF @holdError <> 0 BEGIN ROLLBACK TRANSACTION RETURN @PBHid END

	end
	
	
if @cContNum is not null
BEGIN
	--select @cContNum, @cDebtNum, @cDivToID
	UPDATE PlantHirePBReturnsHead
			SET CatID = theCatID, HireFlag = theHireFlag, 
				PBRHRate1 = Rate1, PBRHRate2 = Rate2, PBRHRate3 = Rate3, PBRHRate4 = Rate4, PBRHRate5 = Rate5, 
				PBRHCatRateFactor1 = CatRateFactor1, PBRHCatRateFactor2 = CatRateFactor2, PBRHCatRateFactor3 = CatRateFactor3,
				PBRHCatRateFactor4 = CatRateFactor4, PBRHCatRateFactor5 = CatRateFactor5,
				PBRHDayMin = DayMin, PBRHWeekMin = WeekMin, 
				PBRHMonthMin = MonthMin,  PBRHFixedRateNum = NULL, PBRHFixedDays = NULL,
				PBRHRatePenalty = (CASE WHEN CatIsPenC1 <> 0 THEN Rate1
										WHEN CatIsPenC2 <> 0 THEN Rate2
										WHEN CatIsPenC3 <> 0 THEN Rate3
										WHEN CatIsPenC4 <> 0 THEN Rate4
										WHEN CatIsPenC5 <> 0 THEN Rate5
									ELSE NULL END),
				PBRHOrdNum = HireROrdNum,
				PBRHNote = Note
			FROM (
	select
	PAQ.CatID AS theCatID, 
		ISNULL(isnull (PHR.HireFlag, PHRP.HireFlag), 1) AS TheHireFlag, 
		ISNULL(PHR.HireRate1, ISNULL(PHRP.HireRate1, PCAT.CatRate1)) AS Rate1, 
		ISNULL(PHR.HireRate2, ISNULL(PHRP.HireRate2, PCAT.CatRate2)) AS Rate2, 
		ISNULL(PHR.HireRate3, ISNULL(PHRP.HireRate3, PCAT.CatRate3)) AS Rate3, 
		ISNULL(PHR.HireRate4, ISNULL(PHRP.HireRate4, PCAT.CatRate4)) AS Rate4, 
		ISNULL(PHR.HireRate5, ISNULL(PHRP.HireRate5, PCAT.CatRate5)) AS Rate5, 
		ISNULL(PHR.HireRDayMin, ISNULL(PHRP.HireRDayMin, PCAT.HireRDayMin)) AS DayMin, 
		ISNULL(PHR.HireRWeekMin, ISNULL(PHRP.HireRWeekMin, PCAT.HireRWeekMin)) AS WeekMin, 
		ISNULL(PHR.HireRMonthMin, ISNULL(PHRP.HireRMonthMin, PCAT.HireRMonthMin)) AS MonthMin, 
		ISNULL(PHR.HireRate1, ISNULL(PHRP.HireRate1, PCAT.CatRate1)) / CASE WHEN PCAT.CatRate1 = 0 THEN 1 ELSE PCAT.CatRate1 END AS CatRateFactor1, 
		ISNULL(PHR.HireRate2, ISNULL(PHRP.HireRate2, PCAT.CatRate2)) / CASE WHEN PCAT.CatRate2 = 0 THEN 1 ELSE PCAT.CatRate2 END AS CatRateFactor2, 
		ISNULL(PHR.HireRate3, ISNULL(PHRP.HireRate3, PCAT.CatRate3)) / CASE WHEN PCAT.CatRate3 = 0 THEN 1 ELSE PCAT.CatRate3 END AS CatRateFactor3, 
		ISNULL(PHR.HireRate4, ISNULL(PHRP.HireRate4, PCAT.CatRate4)) / CASE WHEN PCAT.CatRate4 = 0 THEN 1 ELSE PCAT.CatRate4 END AS CatRateFactor4, 
		ISNULL(PHR.HireRate5, ISNULL(PHRP.HireRate5, PCAT.CatRate5)) / CASE WHEN PCAT.CatRate5 = 0 THEN 1 ELSE PCAT.CatRate5 END AS CatRateFactor5,
		PCAT.CatIsPenC1, PCAT.CatIsPenC2, PCAT.CatIsPenC3, PCAT.CatIsPenC4, PCAT.CatIsPenC5, PHR.HireROrdNum as HireROrdNum, PHR.HireRNote as Note
	from PLANTANDEQ PAQ 
	inner join PLANTCATEGORIES PCAT on PAQ.CatID = PCAT.CatID
	left outer join PlantHireRates PHRP on PHRP.HireFlag = 2 AND PHRP.PeNumber = PAQ.PeNumber
	left outer join PlantHireRates PHR on 
	PHR.PeNumber = PAQ.PeNumber
		AND PHR.ContractNum = case when @cContNum is not null then @cContNum else NULL  end
		--AND PHR.DebtNumber = case when @cDebtNum is not null then @cDebtNum else NULL  end
		--AND PHR.DivID = case when @cDivToID is not null then @cDivToID else NULL  end
	WHERE PAQ.PeNumber =  @cPeNum
	) rates
	WHERE PBRHid = @cRHid
END
if @cDebtNum is not null
BEGIN
	UPDATE PlantHirePBReturnsHead
			SET CatID = theCatID, HireFlag = theHireFlag, 
				PBRHRate1 = Rate1, PBRHRate2 = Rate2, PBRHRate3 = Rate3, PBRHRate4 = Rate4, PBRHRate5 = Rate5, 
				PBRHCatRateFactor1 = CatRateFactor1, PBRHCatRateFactor2 = CatRateFactor2, PBRHCatRateFactor3 = CatRateFactor3,
				PBRHCatRateFactor4 = CatRateFactor4, PBRHCatRateFactor5 = CatRateFactor5,
				PBRHDayMin = DayMin, PBRHWeekMin = WeekMin, 
				PBRHMonthMin = MonthMin,  PBRHFixedRateNum = NULL, PBRHFixedDays = NULL,
				PBRHRatePenalty = (CASE WHEN CatIsPenC1 <> 0 THEN Rate1
										WHEN CatIsPenC2 <> 0 THEN Rate2
										WHEN CatIsPenC3 <> 0 THEN Rate3
										WHEN CatIsPenC4 <> 0 THEN Rate4
										WHEN CatIsPenC5 <> 0 THEN Rate5
									ELSE NULL END),
				PBRHOrdNum = HireROrdNum,
				PBRHNote = Note
			FROM (
	select
	PAQ.CatID AS theCatID, 
		ISNULL(isnull (PHR.HireFlag, PHRP.HireFlag), 1) AS TheHireFlag, 
		ISNULL(PHR.HireRate1, ISNULL(PHRP.HireRate1, PCAT.CatRate1)) AS Rate1, 
		ISNULL(PHR.HireRate2, ISNULL(PHRP.HireRate2, PCAT.CatRate2)) AS Rate2, 
		ISNULL(PHR.HireRate3, ISNULL(PHRP.HireRate3, PCAT.CatRate3)) AS Rate3, 
		ISNULL(PHR.HireRate4, ISNULL(PHRP.HireRate4, PCAT.CatRate4)) AS Rate4, 
		ISNULL(PHR.HireRate5, ISNULL(PHRP.HireRate5, PCAT.CatRate5)) AS Rate5, 
		ISNULL(PHR.HireRDayMin, ISNULL(PHRP.HireRDayMin, PCAT.HireRDayMin)) AS DayMin, 
		ISNULL(PHR.HireRWeekMin, ISNULL(PHRP.HireRWeekMin, PCAT.HireRWeekMin)) AS WeekMin, 
		ISNULL(PHR.HireRMonthMin, ISNULL(PHRP.HireRMonthMin, PCAT.HireRMonthMin)) AS MonthMin, 
		ISNULL(PHR.HireRate1, ISNULL(PHRP.HireRate1, PCAT.CatRate1)) / CASE WHEN PCAT.CatRate1 = 0 THEN 1 ELSE PCAT.CatRate1 END AS CatRateFactor1, 
		ISNULL(PHR.HireRate2, ISNULL(PHRP.HireRate2, PCAT.CatRate2)) / CASE WHEN PCAT.CatRate2 = 0 THEN 1 ELSE PCAT.CatRate2 END AS CatRateFactor2, 
		ISNULL(PHR.HireRate3, ISNULL(PHRP.HireRate3, PCAT.CatRate3)) / CASE WHEN PCAT.CatRate3 = 0 THEN 1 ELSE PCAT.CatRate3 END AS CatRateFactor3, 
		ISNULL(PHR.HireRate4, ISNULL(PHRP.HireRate4, PCAT.CatRate4)) / CASE WHEN PCAT.CatRate4 = 0 THEN 1 ELSE PCAT.CatRate4 END AS CatRateFactor4, 
		ISNULL(PHR.HireRate5, ISNULL(PHRP.HireRate5, PCAT.CatRate5)) / CASE WHEN PCAT.CatRate5 = 0 THEN 1 ELSE PCAT.CatRate5 END AS CatRateFactor5,
		PCAT.CatIsPenC1, PCAT.CatIsPenC2, PCAT.CatIsPenC3, PCAT.CatIsPenC4, PCAT.CatIsPenC5, PHR.HireROrdNum as HireROrdNum, PHR.HireRNote as Note
	from PLANTANDEQ PAQ 
	inner join PLANTCATEGORIES PCAT on PAQ.CatID = PCAT.CatID
	left outer join PlantHireRates PHRP on PHRP.HireFlag = 2 AND PHRP.PeNumber = PAQ.PeNumber
	left outer join PlantHireRates PHR on 
	PHR.PeNumber = PAQ.PeNumber
		--AND PHR.ContractNum = case when @cContNum is not null then @cContNum else NULL  end
		AND PHR.DebtNumber = @cDebtNum 
		--AND PHR.DivID = case when @cDivToID is not null then @cDivToID else NULL  end
	WHERE PAQ.PeNumber =  @cPeNum
	) rates
	WHERE PBRHid = @cRHid
END
if @cDivToID is not null
BEGIN
	UPDATE PlantHirePBReturnsHead
			SET CatID = theCatID, HireFlag = theHireFlag, 
				PBRHRate1 = Rate1, PBRHRate2 = Rate2, PBRHRate3 = Rate3, PBRHRate4 = Rate4, PBRHRate5 = Rate5, 
				PBRHCatRateFactor1 = CatRateFactor1, PBRHCatRateFactor2 = CatRateFactor2, PBRHCatRateFactor3 = CatRateFactor3,
				PBRHCatRateFactor4 = CatRateFactor4, PBRHCatRateFactor5 = CatRateFactor5,
				PBRHDayMin = DayMin, PBRHWeekMin = WeekMin, 
				PBRHMonthMin = MonthMin,  PBRHFixedRateNum = NULL, PBRHFixedDays = NULL,
				PBRHRatePenalty = (CASE WHEN CatIsPenC1 <> 0 THEN Rate1
										WHEN CatIsPenC2 <> 0 THEN Rate2
										WHEN CatIsPenC3 <> 0 THEN Rate3
										WHEN CatIsPenC4 <> 0 THEN Rate4
										WHEN CatIsPenC5 <> 0 THEN Rate5
									ELSE NULL END),
				PBRHOrdNum = HireROrdNum,
				PBRHNote = Note
			FROM (
	select
	PAQ.CatID AS theCatID, 
		ISNULL(isnull (PHR.HireFlag, PHRP.HireFlag), 1) AS TheHireFlag, 
		ISNULL(PHR.HireRate1, ISNULL(PHRP.HireRate1, PCAT.CatRate1)) AS Rate1, 
		ISNULL(PHR.HireRate2, ISNULL(PHRP.HireRate2, PCAT.CatRate2)) AS Rate2, 
		ISNULL(PHR.HireRate3, ISNULL(PHRP.HireRate3, PCAT.CatRate3)) AS Rate3, 
		ISNULL(PHR.HireRate4, ISNULL(PHRP.HireRate4, PCAT.CatRate4)) AS Rate4, 
		ISNULL(PHR.HireRate5, ISNULL(PHRP.HireRate5, PCAT.CatRate5)) AS Rate5, 
		ISNULL(PHR.HireRDayMin, ISNULL(PHRP.HireRDayMin, PCAT.HireRDayMin)) AS DayMin, 
		ISNULL(PHR.HireRWeekMin, ISNULL(PHRP.HireRWeekMin, PCAT.HireRWeekMin)) AS WeekMin, 
		ISNULL(PHR.HireRMonthMin, ISNULL(PHRP.HireRMonthMin, PCAT.HireRMonthMin)) AS MonthMin, 
		ISNULL(PHR.HireRate1, ISNULL(PHRP.HireRate1, PCAT.CatRate1)) / CASE WHEN PCAT.CatRate1 = 0 THEN 1 ELSE PCAT.CatRate1 END AS CatRateFactor1, 
		ISNULL(PHR.HireRate2, ISNULL(PHRP.HireRate2, PCAT.CatRate2)) / CASE WHEN PCAT.CatRate2 = 0 THEN 1 ELSE PCAT.CatRate2 END AS CatRateFactor2, 
		ISNULL(PHR.HireRate3, ISNULL(PHRP.HireRate3, PCAT.CatRate3)) / CASE WHEN PCAT.CatRate3 = 0 THEN 1 ELSE PCAT.CatRate3 END AS CatRateFactor3, 
		ISNULL(PHR.HireRate4, ISNULL(PHRP.HireRate4, PCAT.CatRate4)) / CASE WHEN PCAT.CatRate4 = 0 THEN 1 ELSE PCAT.CatRate4 END AS CatRateFactor4, 
		ISNULL(PHR.HireRate5, ISNULL(PHRP.HireRate5, PCAT.CatRate5)) / CASE WHEN PCAT.CatRate5 = 0 THEN 1 ELSE PCAT.CatRate5 END AS CatRateFactor5,
		PCAT.CatIsPenC1, PCAT.CatIsPenC2, PCAT.CatIsPenC3, PCAT.CatIsPenC4, PCAT.CatIsPenC5, PHR.HireROrdNum as HireROrdNum, PHR.HireRNote as Note
	from PLANTANDEQ PAQ 
	inner join PLANTCATEGORIES PCAT on PAQ.CatID = PCAT.CatID
	left outer join PlantHireRates PHRP on PHRP.HireFlag = 2 AND PHRP.PeNumber = PAQ.PeNumber
	left outer join PlantHireRates PHR on 
	PHR.PeNumber = PAQ.PeNumber
		--AND PHR.ContractNum = case when @cContNum is not null then @cContNum else NULL  end
		--AND PHR.DebtNumber = @cDebtNum 
		AND PHR.DivID = @cDivToID
	WHERE PAQ.PeNumber =  @cPeNum
	) rates
	WHERE PBRHid = @cRHid
END

SELECT @holdError = @@error IF @holdError <> 0 BEGIN ROLLBACK TRANSACTION 
RETURN @PBHid 
END
--------------end 2011-09-19 KSN-----------

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


	FETCH NEXT FROM InCur 
	Into @cPeNum, @cPeCalcM, @cRHid, @cContNum, @cDebtNum, @cDivToID,
		@coSMR, @ccSMR, @cDivSMR, 
		@cQ1, @cQ2, @cQ3, @cQ4, @cQ5, 
		@cIsActW1, @cIsActW2, @cIsActW3, @cIsActW4, @isActW5,
		@cIsFix1, @cIsFix2, @cIsFix3, @cIsFix4, @cIsFix5,
		@cIsBD1, @cIsBD2, @cIsBD3, @cIsBD4, @cIsBD5,
		@cUnit1, @cUnit2, @cUnit3, @cUnit4, @cUnit5,
		@cIsPenToWeekend, @cIsPenToHoliday, @cPenAct, @cTheDate, @cCatBal, @cCatMinPerDay 
END


CLOSE InCur
DEALLOCATE InCur




-- Calculate and save the penalty hours ******************************************************************************************************

DECLARE @numWeekDays int, @TotPenWithCarry numeric(12,2), @TotPenWithWeeklyCarry numeric(12,2), @totPenNoCarry numeric(12,2) 

DECLARE PenCur CURSOR 
SCROLL OPTIMISTIC  for 
	
	SELECT CalcMonth.Debt_Cont_Ovr_Num, TotPenaltiesWithCarry, TotPenaltiesWithWeeklyCarry, TotPenaltieNoCarry
	FROM(
		SELECT Debt_Cont_Ovr_Num, 
				CASE WHEN SUM(PenaltiesWithCarry) < 0 THEN 0 ELSE SUM(PenaltiesWithCarry) END AS TotPenaltiesWithCarry, 
				SUM(PenaltieNoCarry) AS TotPenaltieNoCarry
			FROM 
				(SELECT DATENAME(mm, DatePenDays) AS Month, DATENAME(wk, DatePenDays) AS Week,DATENAME(dw, DatePenDays) AS DayOfWeek, *, 
				CASE --PenaltiesWithCarry
				WHEN PBRHIsPenDay = 0 THEN 
					- SumActWorkHr
				ELSE 
					CASE 
					WHEN (SumActWorkHr >= AvailableMinPerSite) THEN 
						AvailableMinPerSite - SumActWorkHr 
					ELSE 
						AvailableMinPerSite - SumActWorkHr 
					END
				END AS PenaltiesWithCarry, 
				CASE --PenaltieNoCarry
				WHEN (SumActWorkHr >= AvailableMinPerSite) THEN 
					0 
				ELSE 
					CASE 
					WHEN PBRHIsPenDay = 0 THEN 
						0 
					ELSE 
						AvailableMinPerSite - SumActWorkHr 
					END 
				END AS PenaltieNoCarry
				
				FROM 
-- TO add overheade rementber to edite PlantPBReturnsHead_CombineCD to include Overheads
-- OAB this was done on 19-04-2007
			
					(SELECT PlantPBReturnsHead_CombineCD.PBRHDate AS DatePenDays, PlantPBReturnsHead_CombineCD.Debt_Cont_Ovr_Num, 
						COUNT(*) AS RecordCont, SUM(PlantPBReturnsHead_CombineCD.PBHRActulWorkHr) AS SumActWorkHr, 
						SUM(ISNULL(PlantPBReturnsHead_CombineCD.PBHRBreakdownHr, 0)) AS SumBrakdownHr, 
						PlantPBReturnsHead_CombineCD.PBRHDayMin, SITE_DAY.SitePerDay, 
						PlantPBReturnsHead_CombineCD.PBRHDayMin / SITE_DAY.SitePerDay AS MinHrPerSite, 
						PlantPBReturnsHead_CombineCD.PBRHDayMin / SITE_DAY.SitePerDay 
							- SUM(ISNULL(PlantPBReturnsHead_CombineCD.PBHRBreakdownHr, 0)) AS AvailableMinPerSite, 
						PlantPBReturnsHead_CombineCD.PBRHIsPenDay
					FROM PlantPBReturnsHead_CombineCD INNER JOIN
						(SELECT        PBRHDate AS NumWeekDays, COUNT(DISTINCT Debt_Cont_Ovr_Num) AS SitePerDay, COUNT(*) AS RecordCont, SUM(PBHRActulWorkHr) AS SumActWorkHr, 
						                          SUM(PBHRBreakdownHr) AS SumBrakdownHr
						 FROM            PlantPBReturnsHead_CombineCD
						 WHERE        (PBHid = @PBHid)
						 GROUP BY PBRHDate) SITE_DAY ON SITE_DAY.NumWeekDays = PlantPBReturnsHead_CombineCD.PBRHDate
						WHERE (PlantPBReturnsHead_CombineCD.PBHid = @PBHid)
						GROUP BY PlantPBReturnsHead_CombineCD.PBRHDate, 
							PlantPBReturnsHead_CombineCD.Debt_Cont_Ovr_Num, 
							PlantPBReturnsHead_CombineCD.PBRHDayMin, SITE_DAY.SitePerDay, 
							PlantPBReturnsHead_CombineCD.PBRHIsPenDay) CalcPenalties) CalcPen
			GROUP BY Debt_Cont_Ovr_Num) CalcMonth 
			
		INNER JOIN (

		SELECT Debt_Cont_Ovr_Num, SUM(TotPenaltiesWithWeeklyCarry) AS TotPenaltiesWithWeeklyCarry
		FROM
		(SELECT Debt_Cont_Ovr_Num, Week, 
			CASE
			WHEN SUM(PenaltiesWithCarry) < 0 THEN
				0
			ELSE 
				SUM(PenaltiesWithCarry)
			END AS TotPenaltiesWithWeeklyCarry
		FROM (SELECT DATENAME(mm, DatePenDays) AS Month, 
			CASE 	
			WHEN DATENAME(weekday, DatePenDays)= 'Sunday' THEN 
				DATENAME(ww, DatePenDays) - 1 
			ELSE 
				DATENAME(ww, DatePenDays) 
			END AS Week, 
				DATENAME(dw, DatePenDays) AS DayOfWeek, *, 
				CASE
			WHEN PBRHIsPenDay  = 0 THEN 
				- SumActWorkHr  
			ELSE 
				CASE 	
				WHEN (SumActWorkHr >= AvailableMinPerSite) THEN 
					AvailableMinPerSite - SumActWorkHr	
				ELSE 
					AvailableMinPerSite - SumActWorkHr 
				END
			END AS PenaltiesWithCarry, 
				CASE
			WHEN (SumActWorkHr >= AvailableMinPerSite) THEN 
				0 
			ELSE 
				CASE
				WHEN PBRHIsPenDay = 0 THEN 
					0 
				ELSE 
					AvailableMinPerSite - SumActWorkHr 
				END 
			END AS PenaltieNoCarry
		
			FROM (SELECT PlantPBReturnsHead_CombineCD.PBRHDate AS DatePenDays, PlantPBReturnsHead_CombineCD.Debt_Cont_Ovr_Num, COUNT(*) AS RecordCont, 
			SUM(PlantPBReturnsHead_CombineCD.PBHRActulWorkHr) AS SumActWorkHr, 
			SUM(ISNULL(PlantPBReturnsHead_CombineCD.PBHRBreakdownHr, 0)) AS SumBrakdownHr, PlantPBReturnsHead_CombineCD.PBRHDayMin, 
			SITE_DAY.SitePerDay, 
			PlantPBReturnsHead_CombineCD.PBRHDayMin / SITE_DAY.SitePerDay AS MinHrPerSite, 
			PlantPBReturnsHead_CombineCD.PBRHDayMin / SITE_DAY.SitePerDay - SUM(ISNULL(PlantPBReturnsHead_CombineCD.PBHRBreakdownHr,0)) AS AvailableMinPerSite, 
			PlantPBReturnsHead_CombineCD.PBRHIsPenDay
				FROM PlantPBReturnsHead_CombineCD INNER JOIN
						(SELECT PBRHDate AS NumWeekDays, 
						COUNT(DISTINCT Debt_Cont_Ovr_Num) AS SitePerDay, 
						COUNT(*) AS RecordCont, SUM(PBHRActulWorkHr) 
						AS SumActWorkHr, SUM(PBHRBreakdownHr) 
						AS SumBrakdownHr
					FROM PlantPBReturnsHead_CombineCD
					WHERE (PBHid = @PBHid)
					GROUP BY PBRHDate) SITE_DAY ON 
					SITE_DAY.NumWeekDays = PlantPBReturnsHead_CombineCD.PBRHDate
				WHERE (PlantPBReturnsHead_CombineCD.PBHid = @PBHid)
				GROUP BY PlantPBReturnsHead_CombineCD.PBRHDate, 
					PlantPBReturnsHead_CombineCD.Debt_Cont_Ovr_Num, 
					PlantPBReturnsHead_CombineCD.PBRHDayMin, SITE_DAY.SitePerDay, 
					PlantPBReturnsHead_CombineCD.PBRHIsPenDay) CalcPenalties) CalcPensPerWeek
		GROUP BY Debt_Cont_Ovr_Num, Week) CalcPensPerWeekSum
		GROUP BY Debt_Cont_Ovr_Num ) CalcWeek 
	on CalcMonth.Debt_Cont_Ovr_Num = CalcWeek.Debt_Cont_Ovr_Num

DECLARE @cTypeNum  nvarchar(50)
OPEN PenCur
FETCH NEXT FROM PenCur 
Into @cTypeNum, @TotPenWithCarry, @TotPenWithWeeklyCarry, @totPenNoCarry

--select @cTypeNum, @TotPenWithCarry, @TotPenWithWeeklyCarry, @totPenNoCarry

declare @PBRHid int, @TotPen numeric(12,2)

WHILE @@FETCH_STATUS = 0 AND @holdError = 0
BEGIN	


	SELECT @cPeCalcM, @cTypeNum, @TotPenWithCarry, @TotPenWithWeeklyCarry, @totPenNoCarry
	
	
	if @cPeCalcM = 'Batch'
		set @TotPen = @TotPenWithCarry
	else if @cPeCalcM = 'week'
		set @TotPen = @TotPenWithWeeklyCarry
	else
		set @TotPen = @totPenNoCarry
	
	DECLARE @theType  nvarChar(1) 
	set @theType = LEFT( @cTypeNum , 1 )
	
	--SELECT LEN(@cTypeNum)
	
	set @cTypeNum = LTRIM(RTRIM(SUBSTRING(@cTypeNum ,2, LEN(@cTypeNum))))
	
	--SELECT @Totpen as TotPen
	--SELECT @cPeCalcM, @theType AS TypeNum,  @cTypeNum, @TotPenWithCarry, @TotPenWithWeeklyCarry, @totPenNoCarry, @TotPen AS TotPen
	
	

	if @TotPen = 0 
	begin
		IF @theType = 'C'																				-- If is Contract
		begin
		select 'contract'
			DELETE FROM PlantHirePBReturnsHead
			WHERE (PBHid = @PBHid) AND (PBRHPenaltyHours IS NOT NULL) AND (ContrNumber = @cTypeNum)
			SELECT @holdError = @@error IF @holdError <> 0 BEGIN ROLLBACK TRANSACTION RETURN @PBHid END
		end
		else IF @theType = 'D'	
		begin	
		select 'Debotr'																						-- if is Debutor
			DELETE FROM PlantHirePBReturnsHead
			WHERE (PBHid = @PBHid) AND (PBRHPenaltyHours IS NOT NULL) AND (DebtNumber = @cTypeNum)
			SELECT @holdError = @@error IF @holdError <> 0 BEGIN ROLLBACK TRANSACTION RETURN @PBHid END
		end
		else IF @theType = 'O'	
		begin	
		select 'Overhead'																						-- if is Overhead
			DELETE FROM PlantHirePBReturnsHead
			WHERE (PBHid = @PBHid) AND (PBRHPenaltyHours IS NOT NULL) AND (DivToID = cast(@cTypeNum as int))
			SELECT @holdError = @@error IF @holdError <> 0 BEGIN ROLLBACK TRANSACTION RETURN @PBHid END
		end

	end 
	else 
	begin
/*
OAB 20/04/2007
If there is no Penalty hour record, than add a new record in the PlantHirePBReturnsHead table. This is the Penalty hour record that we see at the bottom of the Plant Based Display

Else update the record that has been added before. 

If theres no penalties delete the penalty hours record for that site (Like was done above ) 
*/
	-- See if there are already records for Overtime for this allocation 
	DECLARE @cNumRecs int
	IF @theType = 'C'																				-- If is Contract
	begin
	--@cNumRecs = 
		SELECT @cNumRecs =  COUNT(*) 
		FROM     PlantHirePBReturnsHead
		WHERE  (PBRHPenaltyHours IS NOT NULL) AND (PBHid = @PBHid) AND (ContrNumber = @cTypeNum)
	end
	else IF @theType = 'D'																				-- If is Contract
	begin
		SELECT @cNumRecs =  COUNT(*) 
		FROM     PlantHirePBReturnsHead
		WHERE  (PBRHPenaltyHours IS NOT NULL) AND (PBHid = @PBHid) AND (DebtNumber = @cTypeNum)
	end 
	else IF @theType = 'O'																				-- If is Contract
	begin
		SELECT @cNumRecs =  COUNT(*) 
		FROM     PlantHirePBReturnsHead
		WHERE  (PBRHPenaltyHours IS NOT NULL) AND (PBHid = @PBHid) AND (DivToID = @cTypeNum)
	end

	if @cNumRecs < 1
	begin	
	SELECT 'INSER', @theType
			IF @theType = 'C'																				-- If is Contract
			begin
			--Find the rates for the penalty hours of the Contract 
			INSERT INTO PlantHirePBReturnsHead
				(PBHid, PBRHDate, PBRHSortFlag, ContrNumber, DebtNumber, DivToID, ActNumber, PBRHPenaltyHours, PBRHPostUserID,				
				CatID, HireFlag, 
				PBRHRate1, PBRHRate2, PBRHRate3, PBRHRate4, PBRHRate5, 
				PBRHCatRateFactor1, PBRHCatRateFactor2, PBRHCatRateFactor3,	PBRHCatRateFactor4, PBRHCatRateFactor5,
				PBRHDayMin, PBRHWeekMin, PBRHMonthMin,  PBRHFixedRateNum, PBRHFixedDays,
				PBRHRatePenalty)			
				
				SELECT	@PBHid, @cTheDate, 5, @cTypeNum, NULL, NULL, @cPenAct, @TotPen, @user,
	
						theCatID, theHireFlag, 
						Rate1, Rate2, Rate3, Rate4, Rate5, 
						CatRateFactor1, CatRateFactor2, CatRateFactor3, CatRateFactor4, CatRateFactor5,
						DayMin, WeekMin, MonthMin,  NULL,  NULL,
						(CASE WHEN CatIsPenC1 <> 0 THEN Rate1
							WHEN CatIsPenC2 <> 0 THEN Rate2
							WHEN CatIsPenC3 <> 0 THEN Rate3
							WHEN CatIsPenC4 <> 0 THEN Rate4
							WHEN CatIsPenC5 <> 0 THEN Rate5
						ELSE NULL END)

				from(
				SELECT	PAQ.CatID AS theCatID, 
						ISNULL(COALESCE (PHR.HireFlag, PHRP.HireFlag), 1) AS TheHireFlag, 
						ISNULL(PHR.HireRate1, ISNULL(PHRP.HireRate1, PCAT.CatRate1)) AS Rate1, 
						ISNULL(PHR.HireRate2, ISNULL(PHRP.HireRate2, PCAT.CatRate2)) AS Rate2, 
						ISNULL(PHR.HireRate3, ISNULL(PHRP.HireRate3, PCAT.CatRate3)) AS Rate3, 
						ISNULL(PHR.HireRate4, ISNULL(PHRP.HireRate4, PCAT.CatRate4)) AS Rate4, 
						ISNULL(PHR.HireRate5, ISNULL(PHRP.HireRate5, PCAT.CatRate5)) AS Rate5, 
						ISNULL(PHR.HireRDayMin, ISNULL(PHRP.HireRDayMin, PCAT.HireRDayMin)) AS DayMin, 
						ISNULL(PHR.HireRWeekMin, ISNULL(PHRP.HireRWeekMin, PCAT.HireRWeekMin)) AS WeekMin, 
						ISNULL(PHR.HireRMonthMin, ISNULL(PHRP.HireRMonthMin, PCAT.HireRMonthMin)) AS MonthMin, 
						ISNULL(PHR.HireRate1, ISNULL(PHRP.HireRate1, PCAT.CatRate1)) / CASE WHEN PCAT.CatRate1 = 0 THEN 1 ELSE PCAT.CatRate1 END AS CatRateFactor1, 
						ISNULL(PHR.HireRate2, ISNULL(PHRP.HireRate2, PCAT.CatRate2)) / CASE WHEN PCAT.CatRate2 = 0 THEN 1 ELSE PCAT.CatRate2 END AS CatRateFactor2, 
						ISNULL(PHR.HireRate3, ISNULL(PHRP.HireRate3, PCAT.CatRate3)) / CASE WHEN PCAT.CatRate3 = 0 THEN 1 ELSE PCAT.CatRate3 END AS CatRateFactor3, 
						ISNULL(PHR.HireRate4, ISNULL(PHRP.HireRate4, PCAT.CatRate4)) / CASE WHEN PCAT.CatRate4 = 0 THEN 1 ELSE PCAT.CatRate4 END AS CatRateFactor4, 
						ISNULL(PHR.HireRate5, ISNULL(PHRP.HireRate5, PCAT.CatRate5)) / CASE WHEN PCAT.CatRate5 = 0 THEN 1 ELSE PCAT.CatRate5 END AS CatRateFactor5,
						PCAT.CatIsPenC1, PCAT.CatIsPenC2, PCAT.CatIsPenC3, PCAT.CatIsPenC4, PCAT.CatIsPenC5
					
						FROM PlantHireFlag PHRP_F 
							INNER JOIN PlantHireRates PHRP ON PHRP_F.HireFID = PHRP.HireFlag  AND PHRP.ContractNum = @cTypeNum
							RIGHT OUTER JOIN PLANTCATEGORIES PCAT 
							INNER JOIN PLANTANDEQ PAQ ON PCAT.CatID = PAQ.CatID 
								ON PHRP.PeNumber = PAQ.PeNumber 
								AND PHRP.DebtNumber IS NULL 
								--AND PHRP.SubNumber IS NULL OAB 19-04-2005 No more custom rates to Sub-Contractrs 
								AND PHRP.ContractNum IS NULL 
							LEFT OUTER JOIN PlantHireFlag PHR_F 
							INNER JOIN PlantHireRates PHR ON PHR_F.HireFID = PHR.HireFlag 
								ON PAQ.PeNumber = PHR.PeNumber 
								AND PHR.DebtNumber IS NULL
								AND PHR.DivID is NULL 
								AND PHR.ContractNum = @cTypeNum  --Find the rates for CONTRACTS

						WHERE (PAQ.PeNumber = @cPeNum)) RateData
			
			end
			else if @theType = 'D'	
			begin																							-- if is Debutor
			--Find the rates for the penalty hours of the Debutor
				INSERT INTO PlantHirePBReturnsHead
				(PBHid, PBRHDate, PBRHSortFlag, ContrNumber, DebtNumber, DivToID, ActNumber, PBRHPenaltyHours, PBRHPostUserID,				
				CatID, HireFlag, 
				PBRHRate1, PBRHRate2, PBRHRate3, PBRHRate4, PBRHRate5, 
				PBRHCatRateFactor1, PBRHCatRateFactor2, PBRHCatRateFactor3,	PBRHCatRateFactor4, PBRHCatRateFactor5,
				PBRHDayMin, PBRHWeekMin, PBRHMonthMin,  PBRHFixedRateNum, PBRHFixedDays,
				PBRHRatePenalty)			
				
				SELECT	@PBHid, @cTheDate, 5, NULL, @cTypeNum, NULL, @cPenAct, @TotPen, @user,
	
						theCatID, theHireFlag, 
						Rate1, Rate2, Rate3, Rate4, Rate5, 
						CatRateFactor1, CatRateFactor2, CatRateFactor3, CatRateFactor4, CatRateFactor5,
						DayMin, WeekMin, MonthMin,  NULL,  NULL,
						(CASE WHEN CatIsPenC1 <> 0 THEN Rate1
							WHEN CatIsPenC2 <> 0 THEN Rate2
							WHEN CatIsPenC3 <> 0 THEN Rate3
							WHEN CatIsPenC4 <> 0 THEN Rate4
							WHEN CatIsPenC5 <> 0 THEN Rate5
						ELSE NULL END)

				from(
				SELECT	PAQ.CatID AS theCatID, 
						ISNULL(COALESCE (PHR.HireFlag, PHRP.HireFlag), 1) AS TheHireFlag, 
						ISNULL(PHR.HireRate1, ISNULL(PHRP.HireRate1, PCAT.CatRate1)) AS Rate1, 
						ISNULL(PHR.HireRate2, ISNULL(PHRP.HireRate2, PCAT.CatRate2)) AS Rate2, 
						ISNULL(PHR.HireRate3, ISNULL(PHRP.HireRate3, PCAT.CatRate3)) AS Rate3, 
						ISNULL(PHR.HireRate4, ISNULL(PHRP.HireRate4, PCAT.CatRate4)) AS Rate4, 
						ISNULL(PHR.HireRate5, ISNULL(PHRP.HireRate5, PCAT.CatRate5)) AS Rate5, 
						ISNULL(PHR.HireRDayMin, ISNULL(PHRP.HireRDayMin, PCAT.HireRDayMin)) AS DayMin, 
						ISNULL(PHR.HireRWeekMin, ISNULL(PHRP.HireRWeekMin, PCAT.HireRWeekMin)) AS WeekMin, 
						ISNULL(PHR.HireRMonthMin, ISNULL(PHRP.HireRMonthMin, PCAT.HireRMonthMin)) AS MonthMin, 
						ISNULL(PHR.HireRate1, ISNULL(PHRP.HireRate1, PCAT.CatRate1)) / CASE WHEN PCAT.CatRate1 = 0 THEN 1 ELSE PCAT.CatRate1 END AS CatRateFactor1, 
						ISNULL(PHR.HireRate2, ISNULL(PHRP.HireRate2, PCAT.CatRate2)) / CASE WHEN PCAT.CatRate2 = 0 THEN 1 ELSE PCAT.CatRate2 END AS CatRateFactor2, 
						ISNULL(PHR.HireRate3, ISNULL(PHRP.HireRate3, PCAT.CatRate3)) / CASE WHEN PCAT.CatRate3 = 0 THEN 1 ELSE PCAT.CatRate3 END AS CatRateFactor3, 
						ISNULL(PHR.HireRate4, ISNULL(PHRP.HireRate4, PCAT.CatRate4)) / CASE WHEN PCAT.CatRate4 = 0 THEN 1 ELSE PCAT.CatRate4 END AS CatRateFactor4, 
						ISNULL(PHR.HireRate5, ISNULL(PHRP.HireRate5, PCAT.CatRate5)) / CASE WHEN PCAT.CatRate5 = 0 THEN 1 ELSE PCAT.CatRate5 END AS CatRateFactor5,
						PCAT.CatIsPenC1, PCAT.CatIsPenC2, PCAT.CatIsPenC3, PCAT.CatIsPenC4, PCAT.CatIsPenC5
					
						FROM PlantHireFlag PHRP_F 
							INNER JOIN PlantHireRates PHRP ON PHRP_F.HireFID = PHRP.HireFlag and PHRP.DebtNumber = @cTypeNum 
							RIGHT OUTER JOIN PLANTCATEGORIES PCAT 
							INNER JOIN PLANTANDEQ PAQ ON PCAT.CatID = PAQ.CatID 
								ON PHRP.PeNumber = PAQ.PeNumber 
								AND PHRP.DebtNumber IS NULL 
								--AND PHRP.SubNumber IS NULL  OAB 19-04-2005 No more custom rates to Sub-Contractrs 
								AND PHRP.ContractNum IS NULL 
							LEFT OUTER JOIN PlantHireFlag PHR_F 
							INNER JOIN PlantHireRates PHR ON PHR_F.HireFID = PHR.HireFlag 
								ON PAQ.PeNumber = PHR.PeNumber 
								AND PHR.ContractNum IS NULL 								 
								AND PHR.DivID is NULL 
								AND PHR.DebtNumber = @cTypeNum --Find the rates for DEBTORS
								
						WHERE (PAQ.PeNumber = @cPeNum)) RateData
			
			end
			else if @theType = 'O'	
			begin																							-- if is Overheads
			--Find the rates for the penalty hours of the Overheads
				INSERT INTO PlantHirePBReturnsHead
				(PBHid, PBRHDate, PBRHSortFlag, ContrNumber, DebtNumber, DivToID, ActNumber, PBRHPenaltyHours, PBRHPostUserID,				
				CatID, HireFlag, 
				PBRHRate1, PBRHRate2, PBRHRate3, PBRHRate4, PBRHRate5, 
				PBRHCatRateFactor1, PBRHCatRateFactor2, PBRHCatRateFactor3,	PBRHCatRateFactor4, PBRHCatRateFactor5,
				PBRHDayMin, PBRHWeekMin, PBRHMonthMin,  PBRHFixedRateNum, PBRHFixedDays,
				PBRHRatePenalty)			
				
				SELECT	@PBHid, @cTheDate, 5, NULL, NULL, @cTypeNum, @cPenAct, @TotPen, @user,
	
						theCatID, theHireFlag, 
						Rate1, Rate2, Rate3, Rate4, Rate5, 
						CatRateFactor1, CatRateFactor2, CatRateFactor3, CatRateFactor4, CatRateFactor5,
						DayMin, WeekMin, MonthMin,  NULL,  NULL,
						(CASE WHEN CatIsPenC1 <> 0 THEN Rate1
							WHEN CatIsPenC2 <> 0 THEN Rate2
							WHEN CatIsPenC3 <> 0 THEN Rate3
							WHEN CatIsPenC4 <> 0 THEN Rate4
							WHEN CatIsPenC5 <> 0 THEN Rate5
						ELSE NULL END)

				from(
				SELECT	PAQ.CatID AS theCatID, 
						ISNULL(COALESCE (PHR.HireFlag, PHRP.HireFlag), 1) AS TheHireFlag, 
						ISNULL(PHR.HireRate1, ISNULL(PHRP.HireRate1, PCAT.CatRate1)) AS Rate1, 
						ISNULL(PHR.HireRate2, ISNULL(PHRP.HireRate2, PCAT.CatRate2)) AS Rate2, 
						ISNULL(PHR.HireRate3, ISNULL(PHRP.HireRate3, PCAT.CatRate3)) AS Rate3, 
						ISNULL(PHR.HireRate4, ISNULL(PHRP.HireRate4, PCAT.CatRate4)) AS Rate4, 
						ISNULL(PHR.HireRate5, ISNULL(PHRP.HireRate5, PCAT.CatRate5)) AS Rate5, 
						ISNULL(PHR.HireRDayMin, ISNULL(PHRP.HireRDayMin, PCAT.HireRDayMin)) AS DayMin, 
						ISNULL(PHR.HireRWeekMin, ISNULL(PHRP.HireRWeekMin, PCAT.HireRWeekMin)) AS WeekMin, 
						ISNULL(PHR.HireRMonthMin, ISNULL(PHRP.HireRMonthMin, PCAT.HireRMonthMin)) AS MonthMin, 
						ISNULL(PHR.HireRate1, ISNULL(PHRP.HireRate1, PCAT.CatRate1)) / CASE WHEN PCAT.CatRate1 = 0 THEN 1 ELSE PCAT.CatRate1 END AS CatRateFactor1, 
						ISNULL(PHR.HireRate2, ISNULL(PHRP.HireRate2, PCAT.CatRate2)) / CASE WHEN PCAT.CatRate2 = 0 THEN 1 ELSE PCAT.CatRate2 END AS CatRateFactor2, 
						ISNULL(PHR.HireRate3, ISNULL(PHRP.HireRate3, PCAT.CatRate3)) / CASE WHEN PCAT.CatRate3 = 0 THEN 1 ELSE PCAT.CatRate3 END AS CatRateFactor3, 
						ISNULL(PHR.HireRate4, ISNULL(PHRP.HireRate4, PCAT.CatRate4)) / CASE WHEN PCAT.CatRate4 = 0 THEN 1 ELSE PCAT.CatRate4 END AS CatRateFactor4, 
						ISNULL(PHR.HireRate5, ISNULL(PHRP.HireRate5, PCAT.CatRate5)) / CASE WHEN PCAT.CatRate5 = 0 THEN 1 ELSE PCAT.CatRate5 END AS CatRateFactor5,
						PCAT.CatIsPenC1, PCAT.CatIsPenC2, PCAT.CatIsPenC3, PCAT.CatIsPenC4, PCAT.CatIsPenC5
					
						FROM PlantHireFlag PHRP_F 
							INNER JOIN PlantHireRates PHRP ON PHRP_F.HireFID = PHRP.HireFlag AND PHRP.DivID = @cTypeNum
							RIGHT OUTER JOIN PLANTCATEGORIES PCAT 
							INNER JOIN PLANTANDEQ PAQ ON PCAT.CatID = PAQ.CatID 
								ON PHRP.PeNumber = PAQ.PeNumber 
								AND PHRP.DebtNumber IS NULL 
								--AND PHRP.SubNumber IS NULL OAB 19-04-2005 No more custom rates to Sub-Contractrs 
								AND PHRP.ContractNum IS NULL 
							LEFT OUTER JOIN PlantHireFlag PHR_F 
							INNER JOIN PlantHireRates PHR ON PHR_F.HireFID = PHR.HireFlag 
								ON PAQ.PeNumber = PHR.PeNumber 
								AND PHR.ContractNum IS NULL 
								AND PHR.DebtNumber is NULL 
								AND PHR.DivID = @cTypeNum --Find the rates for OVERHEADS

						WHERE (PAQ.PeNumber = @cPeNum)) RateData
			end
	end 
	else
	begin
  if @cTheDate is not null																			--test that there are actual rows in the cursor
	begin
		IF @theType = 'C'																				-- If is Contract
		begin
			UPDATE PlantHirePBReturnsHead
			SET PBRHDate = @cTheDate, ActNumber = @cPenAct, PBRHPenaltyHours = @TotPen
			WHERE (PBRHid =  (SELECT PBRHid
					FROM PlantHirePBReturnsHead
					WHERE (PBRHPenaltyHours IS NOT NULL) AND (PBHid = @PBHid) AND (ContrNumber = @cTypeNum)))
			SELECT @holdError = @@error IF @holdError <> 0 BEGIN ROLLBACK TRANSACTION RETURN @PBHid END
		end
		else IF @theType = 'D'																				-- If is Debtor
		begin
			UPDATE PlantHirePBReturnsHead
			SET PBRHDate = @cTheDate, ActNumber = @cPenAct, PBRHPenaltyHours = @TotPen
			WHERE (PBRHid =  (SELECT PBRHid
					FROM PlantHirePBReturnsHead
					WHERE (PBRHPenaltyHours IS NOT NULL) AND (PBHid = @PBHid) AND (DebtNumber = @cTypeNum)))
			SELECT @holdError = @@error IF @holdError <> 0 BEGIN ROLLBACK TRANSACTION RETURN @PBHid END
		end
		else IF @theType = 'O'
		begin																							-- if is Overhead
			UPDATE PlantHirePBReturnsHead
			SET PBRHDate = @cTheDate, ActNumber = @cPenAct, PBRHPenaltyHours = @TotPen
			WHERE (PBRHid =  (SELECT PBRHid
					FROM PlantHirePBReturnsHead
					WHERE (PBRHPenaltyHours IS NOT NULL) AND (PBHid = @PBHid) AND (DivToID = @cTypeNum)))
			SELECT @holdError = @@error IF @holdError <> 0 BEGIN ROLLBACK TRANSACTION RETURN @PBHid END			
		end
	end
end
end
	
	FETCH NEXT FROM PenCur 
	Into @cTypeNum, @TotPenWithCarry, @TotPenWithWeeklyCarry, @totPenNoCarry
END

CLOSE PenCur
DEALLOCATE PenCur
-- ********************************************************************************************************************************************


--SELECT 'StartFixed' AS StartFixed

--START FIXED COST CALCULATION
if @isFixed = 1 AND @holdError = 0
begin


	select @chrFDATE as chrFDATE, @chrTDATE  as chrTDATE
	DECLARE @FDATE smalldatetime,@TDATE smalldatetime

	SET @FDATE = @chrFDATE --DATEADD(day, 0, CONVERT(datetime, @chrFDATE, 103))
	SELECT @holdError = @@error IF @holdError <> 0 BEGIN ROLLBACK TRANSACTION RETURN @PBHid END
	SET @TDATE = @chrTDATE --DATEADD(day, 1, CONVERT(datetime, @chrTDATE, 103))
	SELECT @holdError = @@error IF @holdError <> 0 BEGIN ROLLBACK TRANSACTION RETURN @PBHid END

	DECLARE DaysCur CURSOR for 
		SELECT 
			CASE 

			WHEN @DPW <= 0 THEN
				(SELECT COUNT(*)
				FROM PlantHirePublicHolidays PHPH   
         INNER JOIN LOCALES LOC ON PHPH.CuntryCode = LOC.COUNTRYID 
         INNER JOIN BORGS B ON LOC.LOCALEID = B.LOCALE AND B.BORGID = @ToBorgId
				WHERE DATENAME(dw, HirePDDate) NOT IN ('Sunday', 'Saturday', 'Friday', 'Tuesday', 'Wednesday', 'Thursday', 'Monday') 
				AND HirePDDate BETWEEN @FDATE AND @TDATE) 
				WHEN @DPW <= 1 THEN
				(SELECT COUNT(*)
				FROM PlantHirePublicHolidays PHPH   
         INNER JOIN LOCALES LOC ON PHPH.CuntryCode = LOC.COUNTRYID 
         INNER JOIN BORGS B ON LOC.LOCALEID = B.LOCALE AND B.BORGID = @ToBorgId        
				WHERE DATENAME(dw, HirePDDate) NOT IN ('Sunday', 'Saturday', 'Friday', 'Tuesday', 'Wednesday', 'Thursday') 
				AND HirePDDate BETWEEN @FDATE AND @TDATE) 
			WHEN @DPW <= 2 THEN
				(SELECT COUNT(*)
				FROM PlantHirePublicHolidays PHPH   
         INNER JOIN LOCALES LOC ON PHPH.CuntryCode = LOC.COUNTRYID 
         INNER JOIN BORGS B ON LOC.LOCALEID = B.LOCALE AND B.BORGID = @ToBorgId
				WHERE DATENAME(dw, HirePDDate) NOT IN ('Sunday', 'Saturday', 'Friday', 'Tuesday', 'Wednesday') 
				AND HirePDDate BETWEEN @FDATE AND @TDATE) 
			WHEN @DPW <= 3 THEN
				(SELECT COUNT(*)
				FROM PlantHirePublicHolidays PHPH   
         INNER JOIN LOCALES LOC ON PHPH.CuntryCode = LOC.COUNTRYID 
         INNER JOIN BORGS B ON LOC.LOCALEID = B.LOCALE AND B.BORGID = @ToBorgId
				WHERE DATENAME(dw, HirePDDate) NOT IN ('Sunday', 'Saturday', 'Friday', 'Tuesday') 
				AND HirePDDate BETWEEN @FDATE AND @TDATE) 
			WHEN @DPW <= 4 THEN
				(SELECT COUNT(*)
				FROM PlantHirePublicHolidays PHPH   
         INNER JOIN LOCALES LOC ON PHPH.CuntryCode = LOC.COUNTRYID 
         INNER JOIN BORGS B ON LOC.LOCALEID = B.LOCALE AND B.BORGID = @ToBorgId
				WHERE DATENAME(dw, HirePDDate) NOT IN ('Sunday', 'Saturday', 'Friday') 
				AND HirePDDate BETWEEN @FDATE AND @TDATE) 
			WHEN @DPW <= 5 THEN
				(SELECT COUNT(*)
				FROM PlantHirePublicHolidays PHPH   
         INNER JOIN LOCALES LOC ON PHPH.CuntryCode = LOC.COUNTRYID 
         INNER JOIN BORGS B ON LOC.LOCALEID = B.LOCALE AND B.BORGID = @ToBorgId
				WHERE DATENAME(dw, HirePDDate) NOT IN ('Sunday', 'Saturday') 
				AND HirePDDate BETWEEN @FDATE AND @TDATE) 
			WHEN @DPW <= 6 THEN
				(SELECT COUNT(*)
				FROM PlantHirePublicHolidays PHPH   
         INNER JOIN LOCALES LOC ON PHPH.CuntryCode = LOC.COUNTRYID 
         INNER JOIN BORGS B ON LOC.LOCALEID = B.LOCALE AND B.BORGID = @ToBorgId
				WHERE DATENAME(dw, HirePDDate) NOT IN ('Sunday') 
				AND HirePDDate BETWEEN @FDATE AND @TDATE) 
			ELSE
				(SELECT COUNT(*)
				FROM PlantHirePublicHolidays PHPH   
         INNER JOIN LOCALES LOC ON PHPH.CuntryCode = LOC.COUNTRYID 
         INNER JOIN BORGS B ON LOC.LOCALEID = B.LOCALE AND B.BORGID = @ToBorgId
				WHERE HirePDDate BETWEEN @FDATE AND @TDATE) 
				END AS numHolidays, 

			DATEDIFF(dd, @FDATE, @TDATE) - DATEDIFF(ww, @FDATE, @TDATE) * (7 - @DPW) AS numWorkDays,

			DATEDIFF(day, @FDATE, @TDATE) as numDays,
			DATEDIFF(ww, @FDATE, @TDATE) as  numWeekends
			

	OPEN DaysCur 

	DECLARE @cNumHolidys int, @cNumWorkDays int, @cNumDays int, @cNumWeekends int
	FETCH NEXT FROM DaysCur 
	Into @cNumHolidys, @cNumWorkDays, @cNumDays, @cNumWeekends

	CLOSE DaysCur
	DEALLOCATE DaysCur

	--select @cNumHolidys AS cNumHolidys, @cNumWorkDays AS cNumWorkDays, @cNumDays AS cNumDays, @cNumWeekends AS cNumWeekends

	if @fixedUnit = 'Month' and @cPeCalcM = 'Batch'
	begin
		if @cIsPenToWeekend = 0 
			set @fixedDays = @cNumWorkDays + 1
		else
			set @fixedDays = @cNumDays
		if @cIsPenToHoliday <> 0 
			set @fixedDays = @fixedDays - @cNumHolidys
	end
	else
	begin
		if @fixedUnit = 'Week'
			if @cIsPenToWeekend <> 0 
				set @fixedDays = 7
			else
				set @fixedDays = (SELECT TOP 1 HireVDayPerWeek FROM PlantHireVariables where borgid in (-1, @orgid) order by borgid desc)
		else if @fixedUnit = 'Month' 
			set @fixedDays = (SELECT TOP 1 HireVDayPerMonth FROM PlantHireVariables where borgid in (-1, @orgid) order by borgid desc)
		else
			set @fixedDays = 1
	end
	
	--select @fixedUnit as fixedUnit, @fixedDays as fixedDays --@cIsPenToWeekend, @cIsPenToHoliday, @cTheDate
	
	

	UPDATE PlantHirePBReturnsHead
	SET PBRHFixedRateNum = @fixedRateNum, PBRHFixedDays = @fixedDays
	WHERE (PBHid = @PBHid)
	SELECT @holdError = @@error IF @holdError <> 0 BEGIN ROLLBACK TRANSACTION RETURN @PBHid END

	
--Set all the Fixed cost Quantity = 0 before updating them in the next routine
--SELECT PlantHirePBReturnsHead.PBHid AS PBHid, 
--				PLANTCATEGORIES.CatIsFixed1 AS CatIsFixed1, 
--				PLANTCATEGORIES.CatIsFixed2 AS CatIsFixed2, 
--				PLANTCATEGORIES.CatIsFixed3 AS CatIsFixed3, 
--				PLANTCATEGORIES.CatIsFixed4 AS CatIsFixed4, 
--				PLANTCATEGORIES.CatIsFixed5 AS CatIsFixed5
--			FROM PlantHirePBReturnsHead INNER JOIN
--				PLANTCATEGORIES ON 
--				PlantHirePBReturnsHead.CatID = PLANTCATEGORIES.CatID


	UPDATE PlantHirePBReturnsHead
	SET PBRHq1 = CASE WHEN CatIsFixed1 <> 0 THEN 0 ELSE PBRHq1 END, 
		PBRHq2 = CASE WHEN CatIsFixed2 <> 0 THEN 0 ELSE PBRHq2 END, 
		PBRHq3 = CASE WHEN CatIsFixed3 <> 0 THEN 0 ELSE PBRHq3 END, 
		PBRHq4 = CASE WHEN CatIsFixed4 <> 0 THEN 0 ELSE PBRHq4 END, 
		PBRHq5 = CASE WHEN CatIsFixed5 <> 0 THEN 0 ELSE PBRHq5 END
	FROM PlantHirePBReturnsHead 
		INNER JOIN PLANTCATEGORIES ON  PlantHirePBReturnsHead.CatID = PLANTCATEGORIES.CatID
	WHERE (PlantHirePBReturnsHead.PBHid = @PBHid)
	SELECT @holdError = @@error IF @holdError <> 0 BEGIN ROLLBACK TRANSACTION RETURN @PBHid END

	

	UPDATE PlantPBReturnsHead_CombineCD
	SET PBRHq1 = CASE WHEN CatIsFixed1 <> 0 THEN  TheDayPerAct - ISNULL(PlantPBReturnsHead_CombineCD.PBHRBreakdownHr,0) ELSE PBRHq1 END,
		PBRHq2 = CASE WHEN CatIsFixed2 <> 0 THEN  TheDayPerAct - ISNULL(PlantPBReturnsHead_CombineCD.PBHRBreakdownHr,0) ELSE PBRHq2 END,
		PBRHq3 = CASE WHEN CatIsFixed3 <> 0 THEN  TheDayPerAct - ISNULL(PlantPBReturnsHead_CombineCD.PBHRBreakdownHr,0) ELSE PBRHq3 END,
		PBRHq4 = CASE WHEN CatIsFixed4 <> 0 THEN  TheDayPerAct - ISNULL(PlantPBReturnsHead_CombineCD.PBHRBreakdownHr,0) ELSE PBRHq4 END,
		PBRHq5 = CASE WHEN CatIsFixed5 <> 0 THEN  TheDayPerAct - ISNULL(PlantPBReturnsHead_CombineCD.PBHRBreakdownHr,0) ELSE PBRHq5 END
	FROM (SELECT PlantPBReturnsHead_CombineCD.PBRHid, 
			PlantPBReturnsHead_CombineCD.PBHid, PlantPBReturnsHead_CombineCD.PBRHDate, 
			PlantPBReturnsHead_CombineCD.Debt_Cont_Ovr_Num, 
			PlantPBReturnsHead_CombineCD.ActNumber, SitesPerDay.SitePerDay, 
			1.0 / SitesPerDay.SitePerDay AS TheDayPerSite, 
			TActPerDay.ActsPerDay, 
			1.0 / SitesPerDay.SitePerDay / TActPerDay.ActsPerDay AS TheDayPerAct,
			SitesPerDay.CatIsFixed1, SitesPerDay.CatIsFixed2, 
			SitesPerDay.CatIsFixed3, SitesPerDay.CatIsFixed4, 
			SitesPerDay.CatIsFixed5
		FROM PlantPBReturnsHead_CombineCD INNER JOIN
			(SELECT PlantPBReturnsHead_CombineCD.PBRHDate AS TheDate, 
				COUNT(DISTINCT PlantPBReturnsHead_CombineCD.Debt_Cont_Ovr_Num) AS SitePerDay, 
				PLANTCATEGORIES.CatIsFixed1,
				PLANTCATEGORIES.CatIsFixed2, 
				PLANTCATEGORIES.CatIsFixed3, 
				PLANTCATEGORIES.CatIsFixed4, 
				PLANTCATEGORIES.CatIsFixed5
			FROM PlantPBReturnsHead_CombineCD INNER JOIN PLANTCATEGORIES ON PlantPBReturnsHead_CombineCD.CatID = PLANTCATEGORIES.CatID
			WHERE (PlantPBReturnsHead_CombineCD.PBRHIsPenDay = 1) 
				AND (CASE WHEN PLANTCATEGORIES.CatIsFixed1 = 1 OR
				PLANTCATEGORIES.CatIsFixed2 = 1 OR
				PLANTCATEGORIES.CatIsFixed3 = 1 OR
				PLANTCATEGORIES.CatIsFixed4 = 1 OR
				PLANTCATEGORIES.CatIsFixed5 = 1 THEN 1 ELSE 0 END = 1) 
				AND (PlantPBReturnsHead_CombineCD.PBHid = @PBHid)
			GROUP BY PlantPBReturnsHead_CombineCD.PBRHDate, 
				PLANTCATEGORIES.CatIsFixed1, 
				PLANTCATEGORIES.CatIsFixed2, 
				PLANTCATEGORIES.CatIsFixed3, 
				PLANTCATEGORIES.CatIsFixed4, 
				PLANTCATEGORIES.CatIsFixed5) SitesPerDay 
				ON PlantPBReturnsHead_CombineCD.PBRHDate = SitesPerDay.TheDate 
				INNER JOIN
					(SELECT PlantPBReturnsHead_CombineCD.PBRHDate AS TheDate, 
						PlantPBReturnsHead_CombineCD.Debt_Cont_Ovr_Num AS Debt_Cont_Ovr_Num, 
						COUNT(PlantPBReturnsHead_CombineCD.ActNumber) AS ActsPerDay
					FROM PlantPBReturnsHead_CombineCD INNER JOIN PLANTCATEGORIES 
					ON PlantPBReturnsHead_CombineCD.CatID = PLANTCATEGORIES.CatID
					WHERE (PlantPBReturnsHead_CombineCD.PBRHIsPenDay = 1) AND 
						(CASE WHEN PLANTCATEGORIES.CatIsFixed1 = 1 OR
						PLANTCATEGORIES.CatIsFixed2 = 1 OR
						PLANTCATEGORIES.CatIsFixed3 = 1 OR
						PLANTCATEGORIES.CatIsFixed4 = 1 OR
						PLANTCATEGORIES.CatIsFixed5 = 1 THEN 1 ELSE 0 END = 1) 
						AND (PlantPBReturnsHead_CombineCD.PBHid = @PBHid)
					GROUP BY PlantPBReturnsHead_CombineCD.PBRHDate, 
						PlantPBReturnsHead_CombineCD.Debt_Cont_Ovr_Num) TActPerDay ON 
						PlantPBReturnsHead_CombineCD.Debt_Cont_Ovr_Num = TActPerDay.Debt_Cont_Ovr_Num AND 
						PlantPBReturnsHead_CombineCD.PBRHDate = TActPerDay.TheDate
					WHERE (PlantPBReturnsHead_CombineCD.PBHid = @PBHid)) DATA
	WHERE PlantPBReturnsHead_CombineCD.PBRHid = DATA.PBRHid
	SELECT @holdError = @@error IF @holdError <> 0 BEGIN ROLLBACK TRANSACTION RETURN @PBHid END

end --@cIsFix1 <> 0 or @cIsFix2 <> 0 or @cIsFix3 <> 0 or @cIsFix4 <> 0 or @cIsFix5 <> 0






--	Calculate the revenue brake up and save it to the Values table 
--		I need to delete all the records and insert new ones because the revenue GL code brake-up could have change from the last save.

DELETE FROM PlantHirePBReturnsValues
WHERE (PBHid = @PBHid)
SELECT @holdError = @@error IF @holdError <> 0 BEGIN ROLLBACK TRANSACTION RETURN @PBHid END



SELECT *
INTO [#MyTemp]
FROM (SELECT PlantHirePBReturnsHead.PBHid, PlantHirePBReturnsHead.PBRHid, PlantHireRevenueBU.LedgerCode, 
	CONVERT(NUMERIC(18, 2), CASE WHEN PBRHFixedRateNum = 1 THEN HireRevRate1 / (case when ISNULL(PBRHFixedDays, 1)= 0 then 1 else ISNULL(PBRHFixedDays, 1) end) ELSE HireRevRate1 END * PlantHirePBReturnsHead.PBRHCatRateFactor1) AS GlRate1, 
	CONVERT(NUMERIC(18, 2), CASE WHEN PBRHFixedRateNum = 2 THEN HireRevRate2 / (case when ISNULL(PBRHFixedDays, 1)= 0 then 1 else ISNULL(PBRHFixedDays, 1) end) ELSE HireRevRate2 END * PlantHirePBReturnsHead.PBRHCatRateFactor2) AS GlRate2, 
	CONVERT(NUMERIC(18, 2), CASE WHEN PBRHFixedRateNum = 3 THEN HireRevRate3 / (case when ISNULL(PBRHFixedDays, 1)= 0 then 1 else ISNULL(PBRHFixedDays, 1) end) ELSE HireRevRate3 END * PlantHirePBReturnsHead.PBRHCatRateFactor3) AS GlRate3, 
	CONVERT(NUMERIC(18, 2), CASE WHEN PBRHFixedRateNum = 4 THEN HireRevRate4 / (case when ISNULL(PBRHFixedDays, 1)= 0 then 1 else ISNULL(PBRHFixedDays, 1) end) ELSE HireRevRate4 END * PlantHirePBReturnsHead.PBRHCatRateFactor4) AS GlRate4, 
	CONVERT(NUMERIC(18, 2), CASE WHEN PBRHFixedRateNum = 5 THEN HireRevRate5 / (case when ISNULL(PBRHFixedDays, 1)= 0 then 1 else ISNULL(PBRHFixedDays, 1) end) ELSE HireRevRate5 END * PlantHirePBReturnsHead.PBRHCatRateFactor5) AS GlRate5, 
	CONVERT(NUMERIC(18, 2), ISNULL(PlantHirePBReturnsHead.PBRHRatePenalty, 0) * PlantHireRevenueBU.HireRevPenaltyPerc / 100) AS GLPenRate
	FROM PlantHirePBReturnsHead INNER JOIN
	PlantHireRevenueBU ON 
	PlantHireRevenueBU.CatID = PlantHirePBReturnsHead.CatID
	WHERE (PlantHirePBReturnsHead.PBHid = @PBHid)) GlRates
SELECT @holdError = @@error IF @holdError <> 0 BEGIN ROLLBACK TRANSACTION RETURN @PBHid END


--select * from #MyTemp

UPDATE #MyTemp
SET GlRate1 = GlRate1 + RateDef1,
	GlRate2 = GlRate2 + RateDef2,
	GlRate3 = GlRate3 + RateDef3,
	GlRate4 = GlRate4 + RateDef4,
	GlRate5 = GlRate5 + RateDef5,
	GLPenRate = GLPenRate + PenDef
FROM (SELECT PlantHirePBReturnsHead.PBRHid, 
-- Find the maximum GL-code in the set and update the rates for that GL-code with the rounding fault 
--	(There is no specific reason for using the max code, any of the codes will do) 	
	MAX(PlantHireRevenueBU.LedgerCode)  AS TheGlCode, 
	CASE WHEN PBRHFixedRateNum = 1 THEN PBRHRate1/(case when ISNULL(PBRHFixedDays, 1)=0 then 1 else ISNULL(PBRHFixedDays, 1) end) ELSE PBRHRate1 END - GlRate1 AS RateDef1, 
	CASE WHEN PBRHFixedRateNum = 2 THEN PBRHRate2/(case when ISNULL(PBRHFixedDays, 1)=0 then 1 else ISNULL(PBRHFixedDays, 1) end) ELSE PBRHRate2 END - GlRate2 AS RateDef2, 
	CASE WHEN PBRHFixedRateNum = 3 THEN PBRHRate3/(case when ISNULL(PBRHFixedDays, 1)=0 then 1 else ISNULL(PBRHFixedDays, 1) end) ELSE PBRHRate3 END - GlRate3 AS RateDef3, 
	CASE WHEN PBRHFixedRateNum = 4 THEN PBRHRate4/(case when ISNULL(PBRHFixedDays, 1)=0 then 1 else ISNULL(PBRHFixedDays, 1) end) ELSE PBRHRate4 END - GlRate4 AS RateDef4, 
	CASE WHEN PBRHFixedRateNum = 5 THEN PBRHRate5/(case when ISNULL(PBRHFixedDays, 1)=0 then 1 else ISNULL(PBRHFixedDays, 1) end) ELSE PBRHRate5 END - GlRate5 AS RateDef5, 
	ISNULL(PlantHirePBReturnsHead.PBRHRatePenalty, 0) - GLPenRate AS PenDef
	FROM PlantHirePBReturnsHead INNER JOIN
		(SELECT PBHid, PBRHid, 
			SUM(GlRate1) AS GlRate1, 
			SUM(GlRate2) AS GlRate2, 
			SUM(GlRate3) AS GlRate3, 
			SUM(GlRate4) AS GlRate4, 
			SUM(GlRate5) AS GlRate5, 
			SUM(GLPenRate) AS GLPenRate
			FROM #MyTemp
			GROUP BY PBHid, PBRHid) SumTemp 
		ON PlantHirePBReturnsHead.PBRHid = SumTemp.PBRHid 
		INNER JOIN PlantHireRevenueBU 
		ON PlantHirePBReturnsHead.CatID = PlantHireRevenueBU.CatID
		GROUP BY PlantHirePBReturnsHead.PBRHid, 
			CASE WHEN PBRHFixedRateNum = 1 THEN PBRHRate1/(case when ISNULL(PBRHFixedDays, 1)=0 then 1 else ISNULL(PBRHFixedDays, 1) end) ELSE PBRHRate1 END - GlRate1, 
			CASE WHEN PBRHFixedRateNum = 2 THEN PBRHRate2/(case when ISNULL(PBRHFixedDays, 1)=0 then 1 else ISNULL(PBRHFixedDays, 1) end) ELSE PBRHRate2 END - GlRate2, 
			CASE WHEN PBRHFixedRateNum = 3 THEN PBRHRate3/(case when ISNULL(PBRHFixedDays, 1)=0 then 1 else ISNULL(PBRHFixedDays, 1) end) ELSE PBRHRate3 END - GlRate3,
			CASE WHEN PBRHFixedRateNum = 4 THEN PBRHRate4/(case when ISNULL(PBRHFixedDays, 1)=0 then 1 else ISNULL(PBRHFixedDays, 1) end) ELSE PBRHRate4 END - GlRate4,
			CASE WHEN PBRHFixedRateNum = 5 THEN PBRHRate5/(case when ISNULL(PBRHFixedDays, 1)=0 then 1 else ISNULL(PBRHFixedDays, 1) end) ELSE PBRHRate5 END - GlRate5,
		ISNULL(PlantHirePBReturnsHead.PBRHRatePenalty, 0) - GLPenRate) Correct
WHERE Correct.TheGlCode = #MyTemp.LedgerCode and Correct.PBRHid = #MyTemp.PBRHid
SELECT @holdError = @@error IF @holdError <> 0 BEGIN ROLLBACK TRANSACTION RETURN @PBHid END


--select * from #MyTemp

INSERT INTO PlantHirePBReturnsValues
		(PBRHid, GlCode, PBHid,  
		PBRDRevRate1, PBRDRevRate2, PBRDRevRate3, PBRDRevRate4, PBRDRevRate5, PBRDPenRate, 
		PBRDAmount1, PBRDAmount2, PBRDAmount3, PBRDAmount4, PBRDAmount5, 
		PBRDAmount, PBRDPenaltyAmount, PBRDTotalAmount, PBRDVatType)
SELECT PBRHid, LedgerCode, PBHid,
		GlRate1, GlRate2, GlRate3, GlRate4, GlRate5, GLPenRate, 
		GlAmount1, GlAmount2, GlAmount3, GlAmount4, GlAmount5, 
		GlAmount, GLPenAmount, TotalAmount, 'Z' as VatType

FROM (SELECT PBRHid, LedgerCode, PBHid,
		GlRate1, GlRate2, GlRate3, GlRate4, GlRate5, GLPenRate,
		GlAmount1, GlAmount2, GlAmount3, GlAmount4, GlAmount5,
		GlAmount1 + GlAmount2 + GlAmount3 + GlAmount4 + GlAmount5 AS GlAmount,
		GLPenAmount, 
		GlAmount1 + GlAmount2 + GlAmount3 + GlAmount4 + GlAmount5 + GLPenAmount AS TotalAmount
	FROM(
		SELECT #MyTemp.PBRHid, LedgerCode, #MyTemp.PBHid,
			GlRate1, GlRate2, GlRate3, GlRate4, GlRate5, GLPenRate,
			GlRate1 *  PBRHq1 AS GlAmount1,
			GlRate2 *  PBRHq2 AS GlAmount2,
			GlRate3 *  PBRHq3 AS GlAmount3,
			GlRate4 *  PBRHq4 AS GlAmount4,
			GlRate5 *  PBRHq5 AS GlAmount5,
			GlPenRate * ISNULL(PBRHPenaltyHours,0) AS GLPenAmount
		FROM #MyTemp INNER JOIN dbo.PlantHirePBReturnsHead 
		ON #MyTemp.PBRHid = PlantHirePBReturnsHead.PBRHid ) Rates) Data
SELECT @holdError = @@error IF @holdError <> 0 BEGIN ROLLBACK TRANSACTION RETURN @PBHid END


--Calc VAT on debtors transactions 
UPDATE PlantHirePBReturnsValues
SET PBRDVatAmount = PBRDTotalAmount * isnull(VATTYPES.VATPERC, VATTYPES2.VATPERC) / 100,
	PBRDVatType = isnull(VATTYPES.VATID, VATTYPES2.VATID),
	PBRDVatRate = isnull(VATTYPES.VATPERC, VATTYPES2.VATPERC)  
FROM PlantHirePBReturnsHead 
	INNER JOIN PlantHirePBReturnsValues ON PlantHirePBReturnsHead.PBRHid = PlantHirePBReturnsValues.PBRHid 
	INNER JOIN PlantHirePBHeader ON PlantHirePBReturnsHead.PBHid = PlantHirePBHeader.PBHid 
    --INNER JOIN VATTYPES ON PlantHirePBHeader.BorgID = VATTYPES.BORGID
    LEFT OUTER JOIN DEBTORS ON PlantHirePBReturnsHead.DebtNumber = DEBTORS.DebtNumber
    LEFT OUTER JOIN VATTYPES ON PlantHirePBHeader.BorgID = VATTYPES.BORGID AND VATTYPES.VATID = DEBTORS.STXDEFVATID
    LEFT OUTER JOIN VATTYPES VATTYPES2 ON PlantHirePBHeader.BorgID = VATTYPES2.BORGID AND VATTYPES2.VATID = 'D'
	
WHERE (PlantHirePBReturnsHead.DebtNumber IS not NULL) AND (PlantHirePBReturnsHead.PBHid = @PBHid)

SELECT @holdError = @@error IF @holdError <> 0 BEGIN ROLLBACK TRANSACTION RETURN @PBHid END



--Check the batch for Balinsing  BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
DECLARE @openSMR NUMERIC(9,2), @closeSMR NUMERIC(9,2), 
		@haveOpenSMR bit, @haveCloseSMR bit, @varIsZero bit, @ActEqToDifSMR bit,
		@DivOpenCloseEqToAct bit, @DivMinMaxEqToAct bit
		
set @haveOpenSMR = 0 
set @haveCloseSMR = 0
set @varIsZero = 0
set @ActEqToDifSMR = 0
set @DivOpenCloseEqToAct = 0
set @DivMinMaxEqToAct = 0


set @OpenSMR = (SELECT TOP 1 ISNULL(PBRHOpenSMR, -1)
				FROM PlantHirePBReturnsHead
				WHERE (PBHid = @PBHid)
				ORDER BY PBRHDate,PBRHSortFlag,PBRHOpenSMR, PBHRCloseSMR, ContrNumber, DebtNumber)
if @openSMR <> -1
	set @haveOpenSMR = 1

	
--select @haveOpenSMR as haveOpenSMR

set @closeSMR = (SELECT TOP 1 ISNULL(PBHRCloseSMR, - 1) AS Expr1
				 FROM PlantHirePBReturnsHead
				 WHERE (PBHid = @PBHid) AND (PBRHPenaltyHours IS NULL)
				 ORDER BY PBRHDate DESC,PBRHSortFlag DESC, PBRHOpenSMR DESC, PBHRCloseSMR DESC, ContrNumber DESC, DebtNumber DESC)
if @closeSMR <> -1
	set @haveCloseSMR = 1

	
--select @haveCloseSMR as haveCloseSMR
	


DECLARE @cMinSMR NUMERIC(18,2), @cMaxSMR NUMERIC(18,2), @cSumAct NUMERIC(18,2),
		@cSumDifSMR NUMERIC(18,2), @cSumVar NUMERIC(18,2), 
		@cDivMinMaxSMR NUMERIC(18,2)		
				
DECLARE checkTotCur CURSOR FOR
	SELECT MIN(PBRHOpenSMR) AS MinSMR, MAX(PBHRCloseSMR) AS MaxSMR, 
		SUM(PBHRActulWorkHr) AS SumAct, SUM(PBHRDifSMR) AS SumDifSMR, 
		SUM(PBHRVariance) AS SumVar, SUM(PBHRCloseSMR) - SUM(PBRHOpenSMR) AS DivMinMaxSMR
	FROM PlantHirePBReturnsHead
	WHERE (PBHid = @PBHid)
	GROUP BY PBHid
	ORDER BY MIN(PBRHOpenSMR), MAX(PBHRCloseSMR)
	
OPEN checkTotCur

FETCH NEXT FROM checkTotCur 
Into @cMinSMR, @cMaxSMR, @cSumAct, @cSumDifSMR, @cSumVar, @cDivMinMaxSMR 

--select @cMinSMR, @cMaxSMR, @cSumAct, @cSumDifSMR, @cSumVar, @cDivMinMaxSMR

if @@FETCH_STATUS = 0 AND @holdError = 0
BEGIN			
	if @cSumVar = 0 
		set @varIsZero =  1
	
	if @cSumAct =  @cSumDifSMR
		set @ActEqToDifSMR = 1
	
	if (@closeSMR - @openSMR) = @cSumAct
		set @DivOpenCloseEqToAct = 1

	if (@cMaxSMR - @cMinSMR) = @cSumAct
		set @DivMinMaxEqToAct = 1
END
--select (@openSMR - @closeSMR), @cSumAct

if @cCatBal = 0 	
	UPDATE PlantHirePBHeader
	SET PBRHhaveOpenSMR = 1, PBRHhaveCloseSMR = 1, BHRHvarIsZero = 1, 
	BHRHActEqToDifSMR = 1, BHRHDivOpenCloseEqToAct = 1, 
	BHRHDivMinMaxEqToAct = 1
	where (PBHid = @PBHid)
else
	UPDATE PlantHirePBHeader
	SET PBRHhaveOpenSMR = @haveOpenSMR, PBRHhaveCloseSMR = @haveCloseSMR, BHRHvarIsZero = @varIsZero, 
	BHRHActEqToDifSMR = @ActEqToDifSMR, BHRHDivOpenCloseEqToAct = @DivOpenCloseEqToAct, 
	BHRHDivMinMaxEqToAct = @DivMinMaxEqToAct
	where (PBHid = @PBHid)

SELECT @holdError = @@error IF @holdError <> 0 BEGIN ROLLBACK TRANSACTION RETURN @PBHid END


CLOSE checkTotCur
DEALLOCATE checkTotCur
--BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB


Update PlantHirePBHeader set PBRHLastUpdate = @theDate , PBRHFromWhere = @chrFromWhere where (PBHid = @PBHid)
SELECT @holdError = @@error IF @holdError <> 0 BEGIN ROLLBACK TRANSACTION RETURN @PBHid END


If @holdError <> 0 
begin 
	ROLLBACK TRANSACTION
	RETURN @PBHid
end 
else 
begin  	
	Commit transaction 
	RETURN 0
end	
		
		