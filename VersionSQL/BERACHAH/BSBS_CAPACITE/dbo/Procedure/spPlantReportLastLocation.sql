/****** Object:  Procedure [dbo].[spPlantReportLastLocation]    Committed by VersionSQL https://www.versionsql.com ******/

/*
Notes
OAB 08/08/2009  Add the index number for Geinaker Minning spec
OAB 20/08/2009 Add @IsTADoc to see if report to pring is the grinaker turnarond documnet and
	add the BSBS_Temp.[dbo].[PlantLastLocationBORGS] table.
OAB 02/12/2009 increace PeName char(35) to PeName char(55) 	trancation error 

*/
CREATE PROCEDURE [dbo].[spPlantReportLastLocation]
	-- Add the parameters for the stored procedure here
	@ToDate as char(12),
	@OnlySMR as bit = 1,
	@OrgID as int = 0,
	@IsTADoc as bit = 0
AS
BEGIN
	BEGIN TRANSACTION
	DECLARE @holdError INT, @PBHidThis int, @theDate datetime
	Declare @holdIndex int

	

	SET @holdError = 0
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @IsTADoc = 1 
	BEGIN
		SELECT  @holdIndex = IsNull(PltHireRetDocNum,0) FROM BORGS WHERE (BORGID = @OrgID)

		IF  EXISTS (select * from BSBS_Temp.dbo.sysobjects where id = object_id(N'BSBS_Temp.[dbo].[PlantLastLocationBORGS]'))
		DROP TABLE BSBS_Temp.[dbo].[PlantLastLocationBORGS]
		SELECT @holdError = @@error IF @holdError <> 0 BEGIN ROLLBACK TRANSACTION RETURN @holdError END


		CREATE TABLE BSBS_Temp.[dbo].[PlantLastLocationBORGS](
			[BORGID] [int] NOT NULL,
			[BORGNAME] [nvarchar](75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[ADDRESS1] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[ADDRESS2] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[ADDRESS3] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[PCODE] [nvarchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT (''),
			[VATREG] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT (''),
			[COMPREG] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT (''),
			[TELNO] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT (''),
			[FAXNO] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT ('')
		) ON [PRIMARY]
		SELECT @holdError = @@error IF @holdError <> 0 BEGIN ROLLBACK TRANSACTION RETURN @holdError END

		INSERT INTO BSBS_Temp.[dbo].[PlantLastLocationBORGS]
							  (BORGID, BORGNAME, ADDRESS1, ADDRESS2, ADDRESS3, PCODE, VATREG, COMPREG, TELNO, FAXNO)
		SELECT     BORGID AS Expr1, BORGNAME AS Expr2, ADDRESS1 AS Expr3, ADDRESS2 AS Expr4, ADDRESS3 AS Expr5, PCODE AS Expr37, VATREG AS Expr38, 
							  COMPREG AS Expr39, TELNO AS Expr40, FAXNO AS Expr73
		FROM         BORGS
	
	END 


	IF  EXISTS (select * from BSBS_Temp.dbo.sysobjects where id = object_id(N'BSBS_Temp.[dbo].[PlantLastLocation]'))
	DROP TABLE BSBS_Temp.[dbo].[PlantLastLocation]
	SELECT @holdError = @@error IF @holdError <> 0 BEGIN ROLLBACK TRANSACTION RETURN @holdError END

	CREATE TABLE BSBS_Temp.[dbo].[PlantLastLocation](
		[Index] [int] IDENTITY(1,1) NOT NULL
		,LineIndex int
		,ReportDate datetime
		,PeNumber char(10) not null
		,SMRUnit char(10) null
		,PltMeterNum int null
		,SMR numeric(20,2) Null
		,Date datetime null
		,IsService int null
		,ID nvarchar(40) null
		,[Where] char(40) null
		,USERNAME char(75) not null
		,AllocTO nvarchar(30) not null
		,AllocName nvarchar(50) not null
		,Alloc varchar(12) not null
		,HireFlag int null
		,HireFName char(25) null
		,Rate1 money null
		,Rate2 money null
		,Rate3 money null
		,Rate4 money null
		,Rate5 money null
		,Unit1 char(10) null
		,Unit2 char(10) null
		,Unit3 char(10) null
		,Unit4 char(10) null
		,Unit5 char(10) null
		,MinPerDay numeric(18,1) null
		,BorgID int null
		,PeName char(55) null
		,PeRegNo char(25) null 
		,CatID int null
		,CatName char(55) null
		,PeLocation char(35) null
		,PeStatus int null)
	SELECT @holdError = @@error IF @holdError <> 0 BEGIN ROLLBACK TRANSACTION RETURN @holdError END



	if @OnlySMR = 1 
	begin
		-- Use the view PlantViewReadings 
		-- This will show only records with end SMR values 
		select @OnlySMR as OnlySMR, 'SMR Only'
		INSERT INTO BSBS_Temp.dbo.PlantLastLocation
							  (LineIndex ,ReportDate, PeNumber, SMRUnit, PltMeterNum, SMR, Date, IsService, ID, [Where], USERNAME, AllocTO, AllocName, Alloc, HireFlag, HireFName, 
							  Rate1, Rate2, Rate3, Rate4, Rate5, Unit1, Unit2, Unit3, Unit4, Unit5, MinPerDay, PeName, PeRegNo, CatName, PeLocation, CatID, BorgID, PeStatus)
			SELECT       @holdIndex, CONVERT(DATETIME, @ToDate, 103) AS Expr1, PlantViewReadings.PeNumber, PlantViewReadings.SMRUnit, PlantViewReadings.PltMeterNum, 
									 PlantViewReadings.PBHRCloseSMR AS SMR, PlantViewReadings.PBRHDate AS Date, PlantViewReadings.IsService, PlantViewReadings.ID, 
									 PlantViewReadings.[Where], PlantViewReadings.USERNAME, PlantViewReadings.AllocTO, PlantViewReadings.AllocName, PlantViewReadings.Alloc, 
									 ISNULL(ReqRates.HireFlag, PlantRates.HireFlag) AS HireFlag, ISNULL(ReqRates.HireFName, PlantRates.HireFName) AS HireFName, 
									 ISNULL(ReqRates.PeRate1, PlantRates.PBRHRate1) AS Rate1, ISNULL(ReqRates.PeRate2, PlantRates.PBRHRate2) AS Rate2, ISNULL(ReqRates.PeRate3, 
									 PlantRates.PBRHRate3) AS Rate3, ISNULL(ReqRates.PeRate4, PlantRates.PBRHRate4) AS Rate4, ISNULL(ReqRates.PeRate5, PlantRates.PBRHRate5) AS Rate5, 
									 CatUnit1, CatUnit2, CatUnit3, CatUnit4, CatUnit5,
									 ISNULL(ReqRates.HireRDayMin, PlantRates.PBRHDayMin) AS MinPerDay, PLANTANDEQ.PeName, PLANTANDEQ.PeRegNo, 
									 PLANTCATEGORIES.CatNumber, PLANTANDEQ.PeLocation, PLANTANDEQ.CatID, PLANTANDEQ.BorgID, PLANTANDEQ.PeStatus
			FROM            PlantViewReadings INNER JOIN
										 (SELECT        PlantViewReadings_2.PeNumber, PlantViewReadings_2.PBRHDate, MAX(PlantViewReadings_2.ID) AS MaxID, MaxDateSMR.MaxSMR
										   FROM            PlantViewReadings AS PlantViewReadings_2 INNER JOIN
																		 (SELECT        PlantViewReadings_1.PeNumber, PlantViewReadings_1.PBRHDate AS MaxDate, 
																									 PlantViewReadings_1.PBHRCloseSMR AS MaxSMR
																		   FROM            PlantViewReadings AS PlantViewReadings_1 INNER JOIN
																										 (SELECT        PeNumber, MAX(PBRHDate) AS MaxDate
																										   FROM            PlantViewReadings AS PlantViewReadings_1
																										   WHERE        (NOT (AllocTO = N'N/A')) AND (NOT (PltFID = 5)) AND (PBRHDate <= CONVERT(DATETIME, @ToDate, 103))
																										   GROUP BY PeNumber) AS MaxDate ON MaxDate.MaxDate = PlantViewReadings_1.PBRHDate AND 
																									 PlantViewReadings_1.PeNumber = MaxDate.PeNumber
																		   WHERE        (NOT (PlantViewReadings_1.AllocTO = N'N/A')) AND (NOT (PlantViewReadings_1.PltFID = 5))
																		   GROUP BY PlantViewReadings_1.PeNumber, PlantViewReadings_1.PBRHDate, PlantViewReadings_1.PBHRCloseSMR) AS MaxDateSMR ON
																	  PlantViewReadings_2.PeNumber = MaxDateSMR.PeNumber AND PlantViewReadings_2.PBRHDate = MaxDateSMR.MaxDate AND 
																	 PlantViewReadings_2.PBHRCloseSMR = MaxDateSMR.MaxSMR
										   GROUP BY PlantViewReadings_2.PeNumber, PlantViewReadings_2.PBRHDate, MaxDateSMR.MaxSMR) AS FindMaxID ON 
									 PlantViewReadings.PeNumber = FindMaxID.PeNumber AND PlantViewReadings.ID = FindMaxID.MaxID AND 
									 PlantViewReadings.PBRHDate = FindMaxID.PBRHDate INNER JOIN
									 PLANTANDEQ ON PlantViewReadings.PeNumber = PLANTANDEQ.PeNumber INNER JOIN
									 PLANTCATEGORIES ON PLANTANDEQ.CatID = PLANTCATEGORIES.CatID LEFT OUTER JOIN
										 (SELECT        'ReqBased' AS [Where], PlantHireReturnsHead.HireRNumber, PlantHireDetail.HireFlag, PlantHireFlag.HireFName, PlantHireDetail.PeRate1, 
																	 PlantHireDetail.PeRate2, PlantHireDetail.PeRate3, PlantHireDetail.PeRate4, PlantHireDetail.PeRate5, PlantHireDetail.HireRDayMin
										   FROM            PlantHireDetail INNER JOIN
																	 PlantHireReturnsHead ON PlantHireDetail.HireHNumber = PlantHireReturnsHead.HireHNumber AND 
																	 PlantHireDetail.PeNumber = PlantHireReturnsHead.PeNumber INNER JOIN
																	 PlantHireFlag ON PlantHireDetail.HireFlag = PlantHireFlag.HireFID) AS ReqRates ON PlantViewReadings.ID = ReqRates.HireRNumber AND 
									 PlantViewReadings.[Where] = ReqRates.[Where] LEFT OUTER JOIN
										 (SELECT        'PlantBased' AS [Where], PlantHirePBReturnsHead.PBRHid, PlantHirePBReturnsHead.HireFlag, PlantHireFlag_1.HireFName, 
																	 PlantHirePBReturnsHead.PBRHRate1, PlantHirePBReturnsHead.PBRHRate2, PlantHirePBReturnsHead.PBRHRate3, 
																	 PlantHirePBReturnsHead.PBRHRate4, PlantHirePBReturnsHead.PBRHRate5, PlantHirePBReturnsHead.PBRHDayMin
										   FROM            PlantHirePBReturnsHead INNER JOIN
																	 PlantHireFlag AS PlantHireFlag_1 ON PlantHirePBReturnsHead.HireFlag = PlantHireFlag_1.HireFID) AS PlantRates ON 
									 PlantRates.PBRHid = PlantViewReadings.ID AND PlantRates.[Where] = PlantViewReadings.[Where]
			ORDER BY PlantViewReadings.PeNumber
			SELECT @holdError = @@error IF @holdError <> 0 BEGIN ROLLBACK TRANSACTION RETURN @holdError END
	end 
	else
	begin
		-- Use the view PlantViewReadingsALL 
		-- This will show all plant readings
		select @OnlySMR as OnlySMR, 'All'
		INSERT INTO BSBS_Temp.dbo.PlantLastLocation
							  (LineIndex, ReportDate, PeNumber, SMRUnit, PltMeterNum, SMR, Date, IsService, ID, [Where], USERNAME, AllocTO, AllocName, Alloc, HireFlag, HireFName, 
							  Rate1, Rate2, Rate3, Rate4, Rate5, Unit1, Unit2, Unit3, Unit4, Unit5, MinPerDay, PeName, PeRegNo, CatName, PeLocation, CatID, BorgID, PeStatus)
			SELECT        @holdIndex, CONVERT(DATETIME, @ToDate, 103) AS Expr1, PlantViewReadingsAll.PeNumber, PlantViewReadingsAll.SMRUnit, PlantViewReadingsAll.PltMeterNum, 
									 PlantViewReadingsAll.PBHRCloseSMR AS SMR, PlantViewReadingsAll.PBRHDate AS Date, PlantViewReadingsAll.IsService, PlantViewReadingsAll.ID, 
									 PlantViewReadingsAll.[Where], PlantViewReadingsAll.USERNAME, PlantViewReadingsAll.AllocTO, PlantViewReadingsAll.AllocName, 
									 PlantViewReadingsAll.Alloc, ISNULL(ReqRates.HireFlag, PlantRates.HireFlag) AS HireFlag, ISNULL(ReqRates.HireFName, PlantRates.HireFName) 
									 AS HireFName, ISNULL(ReqRates.PeRate1, PlantRates.PBRHRate1) AS Rate1, ISNULL(ReqRates.PeRate2, PlantRates.PBRHRate2) AS Rate2, 
									 ISNULL(ReqRates.PeRate3, PlantRates.PBRHRate3) AS Rate3, ISNULL(ReqRates.PeRate4, PlantRates.PBRHRate4) AS Rate4, ISNULL(ReqRates.PeRate5, 
									 PlantRates.PBRHRate5) AS Rate5,
									 CatUnit1, CatUnit2, CatUnit3, CatUnit4, CatUnit5,
									 ISNULL(ReqRates.HireRDayMin, PlantRates.PBRHDayMin) AS MinPerDay, PLANTANDEQ.PeName, 
									 PLANTANDEQ.PeRegNo, PLANTCATEGORIES.CatNumber, PLANTANDEQ.PeLocation, PLANTANDEQ.CatID, PLANTANDEQ.BorgID, 
									 PLANTANDEQ.PeStatus
			FROM            PlantViewReadingsAll INNER JOIN
										 (SELECT        PlantViewReadings_2.PeNumber, PlantViewReadings_2.PBRHDate, MAX(PlantViewReadings_2.ID) AS MaxID, MaxDateSMR.MaxSMR
										   FROM            PlantViewReadingsAll AS PlantViewReadings_2 INNER JOIN
																		 (SELECT        PlantViewReadings_1.PeNumber, PlantViewReadings_1.PBRHDate AS MaxDate, MAX(PlantViewReadings_1.PBHRCloseSMR) 
																									 AS MaxSMR
																		   FROM            PlantViewReadingsAll AS PlantViewReadings_1 INNER JOIN
																										 (SELECT        PeNumber, MAX(PBRHDate) AS MaxDate
																										   FROM            PlantViewReadingsAll AS PlantViewReadings_1
																										   WHERE        (NOT (AllocTO = N'N/A')) AND (NOT (PltFID = 5)) AND (PBRHDate <= CONVERT(DATETIME, @ToDate, 103))
																										   GROUP BY PeNumber) AS MaxDate ON MaxDate.MaxDate = PlantViewReadings_1.PBRHDate AND 
																									 PlantViewReadings_1.PeNumber = MaxDate.PeNumber
																		   WHERE        (NOT (PlantViewReadings_1.AllocTO = N'N/A')) AND (NOT (PlantViewReadings_1.PltFID = 5))
																		   GROUP BY PlantViewReadings_1.PeNumber, PlantViewReadings_1.PBRHDate) AS MaxDateSMR ON 
																	 PlantViewReadings_2.PeNumber = MaxDateSMR.PeNumber AND PlantViewReadings_2.PBRHDate = MaxDateSMR.MaxDate AND 
																	 PlantViewReadings_2.PBHRCloseSMR = MaxDateSMR.MaxSMR
										   GROUP BY PlantViewReadings_2.PeNumber, PlantViewReadings_2.PBRHDate, MaxDateSMR.MaxSMR) AS FindMaxID ON 
									 PlantViewReadingsAll.PeNumber = FindMaxID.PeNumber AND PlantViewReadingsAll.ID = FindMaxID.MaxID AND 
									 PlantViewReadingsAll.PBRHDate = FindMaxID.PBRHDate INNER JOIN
									 PLANTANDEQ ON PlantViewReadingsAll.PeNumber = PLANTANDEQ.PeNumber INNER JOIN
									 PLANTCATEGORIES ON PLANTANDEQ.CatID = PLANTCATEGORIES.CatID LEFT OUTER JOIN
										 (SELECT        'ReqBased' AS [Where], PlantHireReturnsHead.HireRNumber, PlantHireDetail.HireFlag, PlantHireFlag.HireFName, PlantHireDetail.PeRate1, 
																	 PlantHireDetail.PeRate2, PlantHireDetail.PeRate3, PlantHireDetail.PeRate4, PlantHireDetail.PeRate5, PlantHireDetail.HireRDayMin
										   FROM            PlantHireDetail INNER JOIN
																	 PlantHireReturnsHead ON PlantHireDetail.HireHNumber = PlantHireReturnsHead.HireHNumber AND 
																	 PlantHireDetail.PeNumber = PlantHireReturnsHead.PeNumber INNER JOIN
																	 PlantHireFlag ON PlantHireDetail.HireFlag = PlantHireFlag.HireFID) AS ReqRates ON PlantViewReadingsAll.ID = ReqRates.HireRNumber AND 
									 PlantViewReadingsAll.[Where] = ReqRates.[Where] LEFT OUTER JOIN
										 (SELECT        'PlantBased' AS [Where], PlantHirePBReturnsHead.PBRHid, PlantHirePBReturnsHead.HireFlag, PlantHireFlag_1.HireFName, 
																	 PlantHirePBReturnsHead.PBRHRate1, PlantHirePBReturnsHead.PBRHRate2, PlantHirePBReturnsHead.PBRHRate3, 
																	 PlantHirePBReturnsHead.PBRHRate4, PlantHirePBReturnsHead.PBRHRate5, PlantHirePBReturnsHead.PBRHDayMin
										   FROM            PlantHirePBReturnsHead INNER JOIN
																	 PlantHireFlag AS PlantHireFlag_1 ON PlantHirePBReturnsHead.HireFlag = PlantHireFlag_1.HireFID) AS PlantRates ON 
									 PlantRates.PBRHid = PlantViewReadingsAll.ID AND PlantRates.[Where] = PlantViewReadingsAll.[Where]
			ORDER BY PlantViewReadingsAll.PeNumber

	end

	if @holdIndex <> 0 and @IsTADoc = 1 
	begin
		set @holdIndex = SCOPE_IDENTITY() + @holdIndex

		UPDATE    BORGS
		SET PltHireRetDocNum = @holdIndex
		WHERE     (BORGID = @OrgID)
		SELECT @holdError = @@error IF @holdError <> 0 BEGIN ROLLBACK TRANSACTION RETURN @holdError END
	end

	If @holdError <> 0 
	begin 
		ROLLBACK TRANSACTION
		RETURN @holdError
	end 
	else 
	begin  	
		Commit transaction 
		RETURN 0
	end
end
		
		