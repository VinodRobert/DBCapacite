/****** Object:  Procedure [dbo].[spPlantReportPBInputVar]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Okker Botes
-- Create date: 2009-08-17
-- Description:	Create table in temp DB to store info for the Input Variance Report for Req Bases plant hire  
-- =============================================
CREATE PROCEDURE [dbo].[spPlantReportPBInputVar]
	-- Add the parameters for the stored procedure here
	@CharFromDate as char(12) = '01/01/2000',
	@CharToDate as char(12) = '01/01/9999',
	@FromPeNumber as char(10) = '',
	@ToPeNumber as char(10) = 'ZZZZZZZZZZ',
	@FromCat as int = '1',
	@ToCat as int = '2147483647',
	@ShowSMRDay bit = 1,
	@ShowCapDays bit = 1,
	@ShowCapSMR bit = 1

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

-- VAR DEC **************************************************************************************************
	declare @FromDate datetime, @ToDate datetime

	set @FromDate = CONVERT(DATETIME, @CharFromDate, 103)
	set @ToDate = CONVERT(DATETIME, @CharToDate, 103)

	IF  EXISTS (SELECT * FROM BSBS_Temp.dbo.sysobjects WHERE id = OBJECT_ID(N'[BSBS_temp].[dbo].[PlantInputVar]'))
			DROP TABLE BSBS_Temp.[dbo].[PlantInputVar] 

	CREATE TABLE [BSBS_Temp].[dbo].[PlantInputVar] (
		[HireRNumber] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[PeNumber] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[PeName] char(35) COLLATE SQL_Latin1_General_CP1_CI_AS null,
		[CatNumber] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
		[StartDate] [datetime] NULL,
		[EndDate] [datetime] NULL,
		[SMRDayVar] [int] NULL,
		[StartSMR] [decimal](18, 1) NULL,
		[EndSMR] [decimal](18, 1) NULL,
		[SMRVar] [decimal](18, 1) NULL,
		[HireRFromDate] [datetime] NOT NULL,
		[HireRToDate] [datetime] NOT NULL,
		[FromToDayVar] [int] null,
		[HireRQ1] [decimal](18, 1) NULL DEFAULT ((0)),
		[HireRQ2] [decimal](18, 1) NULL DEFAULT ((0)),
		[HireRQ3] [decimal](18, 1) NULL DEFAULT ((0)),
		[HireRQ4] [decimal](18, 1) NULL DEFAULT ((0)),
		[HireRQ5] [decimal](18, 1) NULL DEFAULT ((0)),
		[HireRWeekDays] [decimal](18, 2) NOT NULL DEFAULT ((0)),
		[HireRHolyday] [decimal](18, 2) NOT NULL DEFAULT ((0)),
		[HireRPenaltyHours] [decimal](18, 2) NOT NULL DEFAULT ((0)),
		[CatUnit1] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT (''),
		[CatUnit2] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL DEFAULT (''),
		[CatUnit3] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL DEFAULT (''),
		[CatUnit4] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL DEFAULT (''),
		[CatUnit5] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL DEFAULT (''),
		[SMRUnit] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL DEFAULT (''),
		[TotSMRCaptured] [int] NULL,
		[TotDaysCaptured] [int] NULL,
		[IsGoodSMRDay] bit default (0),
		[IsGoodCapDays] bit default (1),
		[IsGoodCapSMR] bit default (1),
	 CONSTRAINT [PK_PlantInputVar] PRIMARY KEY CLUSTERED 
	(
		[HireRNumber] ASC
	) ON [PRIMARY]
	) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [IX_PlantInputVar] ON [BSBS_Temp].[dbo].[PlantInputVar] 
	(
		[PeNumber] ASC,
		[EndSMR] ASC,
		[EndDate] ASC
	) ON [PRIMARY]
	
	declare @TR table
	(
	HireRNumber char(10),
	PeNumber char(10),
	StartDate datetime,
	StartSMR decimal(18,1),
	EndDate datetime,
	EndSMR decimal(18,1),
	SMRVar decimal(18,1),
	SMRDayVar int
	)

	declare @HireRNumber char(10),
		@PeNumber char(10),
		@PeNumberHold char(10),
		@TheDate datetime,
		@EndDateHold datetime,
		@TheSMR decimal(18,1),
		@EndSMRHold decimal(18,1),
		@EndDate datetime,
		@EndSMR decimal(18,1),
		@DaysPerWeek int,
		@DaysPerMonth int

	set @DaysPerWeek = (SELECT TOP 1 IsNull(HireVDayPerWeek,0) FROM PlantHireVariables )
	set @DaysPerMonth = (SELECT TOP 1 IsNull(HireVDayPerMonth,0) FROM PlantHireVariables )
-- VAR DEC END **************************************************************************************************


	declare RC cursor 
	for
		SELECT     HireRNumber, PeNumber, HireRSMRReading, HireRSMRDate
		FROM         PlantHireReturns
		WHERE     (PeNumber >= @FromPeNumber) AND (PeNumber <= @ToPeNumber)
		 AND (HireRFromDate >= @FromDate) AND (HireRToDate <= @ToDate)
		GROUP BY HireRNumber, PeNumber, HireRSMRReading, HireRSMRDate
		ORDER BY PeNumber, HireRSMRReading, HireRSMRDate

	open RC

	fetch next 
	from RC
	into @HireRNumber, @PeNumber, @TheSMR, @TheDate 

	WHILE @@FETCH_STATUS = 0
	begin

		if @PeNumberHold = @PeNumber 
		begin

			INSERT INTO @TR
							  (HireRNumber,	PeNumber, StartSMR, StartDate, EndSMR, EndDate, SMRVar, SMRDayVar )
			VALUES     (@HireRNumber, @PeNumber, @EndSMRHold , @EndDateHold, @TheSMR, @TheDate,  @TheSMR - @EndSMRHold , DATEDIFF(day, @EndDateHold, @TheDate) )
		end else begin
			INSERT INTO @TR
							  (HireRNumber,	PeNumber, StartSMR, StartDate, EndSMR, EndDate)
			VALUES     (@HireRNumber, @PeNumber, Null, Null, @TheSMR, @TheDate  )
		end

		Set @PeNumberHold = @PeNumber 
		set @EndDateHold = @TheDate
		set @EndSMRHold = @TheSMR
		
		fetch next 
		from RC
		into @HireRNumber, @PeNumber, @TheSMR, @TheDate 

	end

	--select * from @TR
	--where PeNumber = 'B0004'

	close RC
	DEALLOCATE RC


	SELECT     PlantHireReturns.HireRNumber, PlantHireReturns.PeNumber, PlantHireReturns.HireRFromDate, PlantHireReturns.HireRToDate, PlantHireReturns.HireRQ1, 
		  PlantHireReturns.HireRQ2, PlantHireReturns.HireRQ3, PlantHireReturns.HireRQ4, PlantHireReturns.HireRQ5, PlantHireReturns.HireRWeekDays, 
		  PlantHireReturns.HireRHolyday, PlantHireReturns.HireRPenaltyHours,  
		  PLANTCATEGORIES.CatUnit1, PLANTCATEGORIES.CatUnit2, PLANTCATEGORIES.CatUnit3, PLANTCATEGORIES.CatUnit4, PLANTCATEGORIES.CatUnit5, 
		  PLANTCATEGORIES.SMRUnit, PLANTCATEGORIES.CatNumber,
			MAX(CASE WHEN PLANTCATEGORIES.CatUnit1 = PLANTCATEGORIES.SMRUnit THEN PlantHireReturns.HireRQ1 ELSE 0 END) 
		  + MAX(CASE WHEN PLANTCATEGORIES.CatUnit2 = PLANTCATEGORIES.SMRUnit THEN PlantHireReturns.HireRQ2 ELSE 0 END) 
		  + MAX(CASE WHEN PLANTCATEGORIES.CatUnit3 = PLANTCATEGORIES.SMRUnit THEN PlantHireReturns.HireRQ3 ELSE 0 END) 
		  + MAX(CASE WHEN PLANTCATEGORIES.CatUnit4 = PLANTCATEGORIES.SMRUnit THEN PlantHireReturns.HireRQ4 ELSE 0 END) 
		  + MAX(CASE WHEN PLANTCATEGORIES.CatUnit5 = PLANTCATEGORIES.SMRUnit THEN PlantHireReturns.HireRQ5 ELSE 0 END) AS TotSMRCaptured, 
		  ((MAX(CASE WHEN PLANTCATEGORIES.CatUnit1 = 'Day' THEN PlantHireReturns.HireRQ1 ELSE 0 END) 
		  + MAX(CASE WHEN PLANTCATEGORIES.CatUnit2 = 'Day' THEN PlantHireReturns.HireRQ2 ELSE 0 END) 
		  + MAX(CASE WHEN PLANTCATEGORIES.CatUnit3 = 'Day' THEN PlantHireReturns.HireRQ3 ELSE 0 END) 
		  + MAX(CASE WHEN PLANTCATEGORIES.CatUnit4 = 'Day' THEN PlantHireReturns.HireRQ4 ELSE 0 END) 
		  + MAX(CASE WHEN PLANTCATEGORIES.CatUnit5 = 'Day' THEN PlantHireReturns.HireRQ5 ELSE 0 END)) 
		  + (MAX(CASE WHEN PLANTCATEGORIES.CatUnit1 = 'Week' THEN PlantHireReturns.HireRQ1 ELSE 0 END) 
		  + MAX(CASE WHEN PLANTCATEGORIES.CatUnit2 = 'Week' THEN PlantHireReturns.HireRQ2 ELSE 0 END) 
		  + MAX(CASE WHEN PLANTCATEGORIES.CatUnit3 = 'Week' THEN PlantHireReturns.HireRQ3 ELSE 0 END) 
		  + MAX(CASE WHEN PLANTCATEGORIES.CatUnit4 = 'Week' THEN PlantHireReturns.HireRQ4 ELSE 0 END) 
		  + MAX(CASE WHEN PLANTCATEGORIES.CatUnit5 = 'Week' THEN PlantHireReturns.HireRQ5 ELSE 0 END)) * @DaysPerWeek) 
		  + (MAX(CASE WHEN PLANTCATEGORIES.CatUnit1 = 'Month' THEN PlantHireReturns.HireRQ1 ELSE 0 END) 
		  + MAX(CASE WHEN PLANTCATEGORIES.CatUnit2 = 'Month' THEN PlantHireReturns.HireRQ2 ELSE 0 END) 
		  + MAX(CASE WHEN PLANTCATEGORIES.CatUnit3 = 'Month' THEN PlantHireReturns.HireRQ3 ELSE 0 END) 
		  + MAX(CASE WHEN PLANTCATEGORIES.CatUnit4 = 'Month' THEN PlantHireReturns.HireRQ4 ELSE 0 END) 
		  + MAX(CASE WHEN PLANTCATEGORIES.CatUnit5 = 'Month' THEN PlantHireReturns.HireRQ5 ELSE 0 END)) * @DaysPerMonth AS TotDaysCaptured 
	INTO            [#Data]
	FROM         PlantHireReturnsHead INNER JOIN
		  PlantHireReturns ON PlantHireReturnsHead.HireRNumber = PlantHireReturns.HireRNumber INNER JOIN
		  PLANTCATEGORIES INNER JOIN
		  PlantHireDetail ON PLANTCATEGORIES.CatID = PlantHireDetail.CatID ON PlantHireReturnsHead.HireHNumber = PlantHireDetail.HireHNumber AND 
		  PlantHireReturnsHead.PeNumber = PlantHireDetail.PeNumber
	where PLANTCATEGORIES.CatID >= @FromCat and PLANTCATEGORIES.CatId <= @ToCat
		and PlantHireReturns.PeNumber >= @FromPeNumber and PlantHireReturns.PeNumber <= @ToPeNumber
		AND (HireRFromDate >= @FromDate) AND (HireRToDate <= @ToDate)
	GROUP BY PlantHireReturns.HireRNumber, PlantHireReturns.HireRFromDate, PlantHireReturns.HireRToDate, PlantHireReturns.HireRQ1, PlantHireReturns.HireRQ2, 
		  PlantHireReturns.HireRQ3, PlantHireReturns.HireRQ4, PlantHireReturns.HireRQ5, PlantHireReturns.HireRWeekDays, PlantHireReturns.HireRHolyday, 
		  PlantHireReturns.HireRPenaltyHours, PlantHireReturns.HireRSMRDate, PlantHireReturns.HireRSMRReading, PlantHireReturns.PeNumber, 
		  PLANTCATEGORIES.CatUnit1, PLANTCATEGORIES.CatUnit2, PLANTCATEGORIES.CatUnit3, PLANTCATEGORIES.CatUnit4, PLANTCATEGORIES.CatUnit5, 
		  PLANTCATEGORIES.SMRUnit,  PLANTCATEGORIES.CatNumber


--select * from #Data
	


	INSERT INTO BSBS_Temp.[dbo].[PlantInputVar] 
		([HireRNumber],[PeNumber], PeName, [StartDate],[StartSMR], [EndDate],[EndSMR], [SMRVar], [SMRDayVar], 
		[HireRFromDate], [HireRToDate], [FromToDayVar], 
		[HireRQ1], [HireRQ2], [HireRQ3], [HireRQ4], [HireRQ5],
		[HireRWeekDays], [HireRHolyday], [HireRPenaltyHours], 
		[CatUnit1], [CatUnit2], [CatUnit3], [CatUnit4], [CatUnit5], [SMRUnit], [TotSMRCaptured], [TotDaysCaptured], CatNumber, 
		[IsGoodSMRDay], [IsGoodCapDays], [IsGoodCapSMR])
	SELECT   TR.[HireRNumber],TR.[PeNumber], PLANTANDEQ.PeName, TR.[StartDate], TR.[StartSMR], TR.[EndDate], TR.[EndSMR], TR.[SMRVar], TR.[SMRDayVar],
		#Data.[HireRFromDate], #Data.[HireRToDate], DATEDIFF(day, #Data.[HireRFromDate], #Data.[HireRToDate]),
		#Data.[HireRQ1], #Data.[HireRQ2], #Data.[HireRQ3], #Data.[HireRQ4], #Data.[HireRQ5],
		#Data.[HireRWeekDays], #Data.[HireRHolyday], #Data.[HireRPenaltyHours], 
		#Data.[CatUnit1], #Data.[CatUnit2], #Data.[CatUnit3], #Data.[CatUnit4], #Data.[CatUnit5], 
		#Data.[SMRUnit], #Data.[TotSMRCaptured], #Data.[TotDaysCaptured], CatNumber,
		case when SMRDayVar <> DATEDIFF(day, #Data.[HireRFromDate], #Data.[HireRToDate])  then 1 else @ShowSMRDay end,
		case when (HireRWeekDays-HireRHolyday) <> TotDaysCaptured then 1 else @ShowCapDays end,
		case when SMRVar <> TotSMRCaptured then 1 else @ShowCapSMR end
	FROM #Data  inner join @TR TR on tr.HireRNumber = #Data.HireRNumber
		inner join PLANTANDEQ on PLANTANDEQ.PeNumber = TR.PeNumber

	DROP TABLE #Data

END


		