/****** Object:  Procedure [dbo].[spPlantUpdateServiceData]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Okker Botes
-- Create date: 29/01/2007
-- Description:	Update Service Date
-- =============================================
CREATE PROCEDURE [dbo].[spPlantUpdateServiceData] 
	-- Add the parameters for the stored procedure here
  /*
  2012-09-11 Matthew
   Added context for log Master
  */

	@tpRID char(10) , 
	@tpPeNumber char(10), 
	@tpRUnit char(10), 
	@tpSMR decimal(18,1), 
	@tpDateOfR datetime, 
	@tpIsService bit = 0,
	@tpServID int = NULL,
	@tpTypeID char(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  declare @ContextInfo varbinary(128)
  declare @scope_identity varchar(128)

--Variables to hold the values of the plant item that is updated ls = last
	declare @lsServDate datetime,
			@lsServSMR numeric(19,1),
			@lsServFromWhere char(10),
			@lsServHeadID int,
			@lsServID int,
			@lsLastSMR numeric(18,1),
			@lsLastDate datetime,
			@lsLastFromWhere char(10),
			@lsLastHeadID char(10),
			@lsLastFromWhereID char(10),
			@lsServiceNext numeric(18,0),
			@lsHaveServ bit,
			@lsServWarnig numeric(18,1),
			@lsServCalcType char(15),
			@lsServUnit char(10),
			@lsUpdatePerc numeric(18,0),
			@lsServiceLogID int,
			@lsLastLogID int

	SELECT	@lsServDate = IsNull(PeServiceDate, CONVERT(DATETIME,'01/01/2000',103)),
			@lsServSMR = IsNull(PeServiceSMR, 0),
			@lsServFromWhere = PeServiceFromWhere,
			@lsServHeadID = PeServiceHeadID,
			@lsServID = ServID, 
			@lsLastSMR = IsNull(PeLastSMR, 0),
			@lsLastDate = IsNull(PeLastDate, CONVERT(DATETIME,'01/01/2000',103)), 
			@lsLastFromWhere = PeLastFromWhere, 
			@lsLastHeadID = IsNull(PeLastHeadID,''), 
			@lsLastFromWhereID = PeLastFromWhereID,
			@lsServiceNext = IsNull(PeServiceNextSMR, 0),
			@lsServiceLogID = PeServiceLogID,
			@lsLastLogID = PeLastLogID,
			@lsHaveServ = PLANTCATEGORIES.CatHaveService, 
			@lsServWarnig = PLANTCATEGORIES.CatServWarning, 
			@lsServCalcType = PLANTCATEGORIES.CatServCalcType,
			@lsServUnit = PLANTCATEGORIES.SMRUnit,
			@lsUpdatePerc = PLANTCATEGORIES.CatServUpdatePerc
	FROM PLANTANDEQ INNER JOIN
		  PLANTCATEGORIES ON PLANTANDEQ.CatID = PLANTCATEGORIES.CatID
	WHERE (PeNumber = @tpPeNumber)		

--Calculation Variables cl = calculate 
	DECLARE @clNextServ numeric(18,0),
			@clIncToNextServ numeric(18,0),
			@clFromWhere char(10),
			@clServIncLimit numeric(18,1),
			@clFirstServ numeric(18,0),
			@clLogID int


--	INSERT INTO PlantTest(Test1, Test2, Test3, Test4, Test5)
--	VALUES ('Befoor Start', @tpRID, @lsLastHeadID, @tpSMR, @tpDateOfR )


-- Now  the logic of the Maintenance transaction  
--STEP1: Check to see if it is a service 
IF @lsHaveServ = 1 
--Servicing do apply to this Item
BEGIN --2
	If @tpDateOfR >= @lsServDate and @tpSMR >= @lsServSMR and @lsServUnit = @tpRUnit AND @tpIsService = 1
	BEGIN --3
	--Update the Servicing data in PlanAndQ Table
		
		select @clFromWhere = PltFDisplay from dbo.PlantReadingsFlags where PltFID = @tpTypeID
		SELECT @clIncToNextServ = [ServIncToNextService] FROM  [PlantServiceTypes] WHERE [ServID] = @tpServID
	
		--OAB 07-05/2007 prevent a division by 0
		if @clIncToNextServ = 0
		begin
			set @clIncToNextServ = 1
		end
		
	--Calculate the first Next service >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		if @lsServiceNext is Null or @lsServiceNext = 0 
		begin
			set @clFirstServ = (round((@tpSMR/@clIncToNextServ), 0) ) * @clIncToNextServ
			if @clFirstServ < @TpSMR begin
				set @clFirstServ = @clFirstServ + @clIncToNextServ
			end

			if @lsServCalcType = 'Incremental'
			begin
				set @lsServiceNext = @clFirstServ
			end
			else -- = 'Running'
			begin
				set @lsServiceNext = @tpSMR - @clIncToNextServ
			end			

			
		end 
	-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

		set @clServIncLimit = @lsServiceNext-((1-@lsUpdatePerc/100)*@clIncToNextServ)
	--

		If @TpSMR > @clServIncLimit 
		begin
			if @lsServCalcType = 'Incremental'
			begin
				--
				set @clNextServ = @clIncToNextServ + @lsServiceNext
			end
			else -- = 'Running'
			begin
				set @clNextServ =  @clIncToNextServ + @tpSMR 
			end
		end 
		else
		begin
			set @clNextServ = @lsServiceNext
		end


		INSERT INTO [PlantServiceLog]
			   ([SLFromWhere],[SLFromWhereID],[SLDesc],[SLPeNumber],[SLServiceType],[SLPervSMR],[SLNextSMR],[SLDate], 
				SLPrevServSMR, SLNextServSMR, SLServInterval,SLServIncrementLimit,SLPrefID, SLHeadID)
		 VALUES
			   (@clFromWhere, @tpTypeID,'Update Service',@tpPeNumber,@lsServCalcType,@lsLastSMR, @tpSMR,@tpDateOfR,
				@lsServiceNext, @clNextServ,@clIncToNextServ,@clServIncLimit, @lsServiceLogID, @tpRID )

		set @clLogID = SCOPE_IDENTITY() 

    INSERT INTO LOGCONTEXT (USERID, BORGID, APPLICATION, PAGE, INFO, VERSION) VALUES (-1, -1, 'ACC', 'spPlantUpdateServiceData.xml', '', '')
    set @scope_identity = scope_identity()
    SELECT @ContextInfo = cast(@scope_identity AS varbinary(128))
    SET CONTEXT_INFO @ContextInfo

		UPDATE [PLANTANDEQ]
		SET [PeServiceDate] = @tpDateOfR
			,[PeServiceSMR] = @tpSMR
			,[PeServiceNextSMR] = @clNextServ
			,[ServID] = @tpServID
			,[PeServiceFromWhere] = @clFromWhere
			,[PeServiceFromWhereID] = @tpTypeID
			,[PeServiceHeadID] = @tpRID
			,[PeServiceUnit] = @tpRUnit
			,[PeServiceLogID] = @clLogID
		WHERE PeNumber = @tpPeNumber
		


	END --3

--INSERT INTO PlantTest(Test1, Test2, Test3, Test4, Test5, Test6)
--VALUES ('Befoor LastSMR',@tpRID, @tpDateOfR, @lsLastDate, @tpSMR, @lsLastSMR )

--Now check if this is a newer reading   
	if  (@tpDateOfR >= @lsLastDate and  @tpSMR > @lsLastSMR) OR ( @tpRID = @lsLastHeadID and (@tpDateOfR <> @lsLastDate or @tpSMR <> @lsLastSMR)) --4	Fuel update from fuel system  (@tpTypeID = @lsLastFromWhereID or @tpRID = @lsLastHeadID and @tpTypeID=4 
	begin --4

		select @clFromWhere = convert(char(10),PltFDisplay) from dbo.PlantReadingsFlags where PltFID = @tpTypeID

		INSERT INTO [PlantServiceLog]
			   ([SLFromWhere],[SLFromWhereID],[SLDesc],[SLPeNumber],[SLServiceType],[SLPervSMR],[SLNextSMR],[SLDate],[SLServIncrementLimit],[SLPrefID], SLHeadID )
		 VALUES
			   (@clFromWhere, @tpTypeID,'Update Last SMR',@tpPeNumber,@lsServCalcType,@lsLastSMR, @tpSMR,@tpDateOfR,@clServIncLimit,@lsLastLogID, @tpRID )



		set @clLogID = SCOPE_IDENTITY() 

    INSERT INTO LOGCONTEXT (USERID, BORGID, APPLICATION, PAGE, INFO, VERSION) VALUES (-1, -1, 'ACC', 'spPlantUpdateServiceData.xml', '', '')
    set @scope_identity = scope_identity()
    SELECT @ContextInfo = cast(@scope_identity AS varbinary(128))
    SET CONTEXT_INFO @ContextInfo

		UPDATE [PLANTANDEQ]
		SET	[PeLastSMR] = @tpSMR
			,[PeLastDate] = @tpDateOfR
			,[PeLastFromWhere] = @clFromWhere
			,[PeLastFromWhereID] = @tpTypeID
			,[PeLastHeadID] = @tpRID
			,[PeLastLogID] = @clLogID
		WHERE PeNumber = @tpPeNumber
		

	end --4
END --2

--	INSERT INTO PlantTest(Test1, Test2)
--	VALUES ('from StoredProc', @tpRID)

 return 0
END
		
		