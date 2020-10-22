/****** Object:  Table [dbo].[PlantHirePBReturnsHead]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PlantHirePBReturnsHead](
	[PBRHid] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[PBHid] [int] NOT NULL,
	[PBRHDate] [datetime] NOT NULL,
	[PBRHSortFlag] [int] NULL,
	[ContrNumber] [nvarchar](10) NULL,
	[DebtNumber] [char](10) NULL,
	[ActNumber] [char](10) NULL,
	[PBRHOpenSMR] [numeric](18, 4) NULL,
	[PBHRCloseSMR] [numeric](18, 2) NULL,
	[PBRHq1] [numeric](18, 4) NOT NULL,
	[PBRHq2] [numeric](18, 4) NOT NULL,
	[PBRHq3] [numeric](18, 4) NOT NULL,
	[PBRHq4] [numeric](18, 4) NOT NULL,
	[PBRHq5] [numeric](18, 4) NOT NULL,
	[PBRHIsWeekday] [bit] NOT NULL,
	[PBRHIsHoliday] [bit] NOT NULL,
	[PBRHIsPenDay] [bit] NULL,
	[PBHRActulWorkHr] [numeric](18, 4) NULL,
	[PBHRBreakdownHr] [numeric](18, 4) NULL,
	[PBHRDifSMR] [numeric](18, 4) NULL,
	[PBHRVariance] [numeric](18, 4) NULL,
	[PBRHPenaltyHours] [numeric](18, 4) NULL,
	[CatID] [int] NULL,
	[HireFlag] [int] NULL,
	[PBRHRate1] [money] NULL,
	[PBRHRate2] [money] NULL,
	[PBRHRate3] [money] NULL,
	[PBRHRate4] [money] NULL,
	[PBRHRate5] [money] NULL,
	[PBRHRatePenalty] [money] NULL,
	[PBRHCatRateFactor1] [numeric](18, 4) NULL,
	[PBRHCatRateFactor2] [numeric](18, 4) NULL,
	[PBRHCatRateFactor3] [numeric](18, 4) NULL,
	[PBRHCatRateFactor4] [numeric](18, 4) NULL,
	[PBRHCatRateFactor5] [numeric](18, 4) NULL,
	[PBRHFixedRateNum] [int] NULL,
	[PBRHFixedDays] [int] NULL,
	[PBRHDayMin] [numeric](18, 2) NULL,
	[PBRHWeekMin] [numeric](18, 2) NULL,
	[PBRHMonthMin] [numeric](18, 2) NULL,
	[PBHRUser] [int] NULL,
	[PBRHCreationDate] [datetime] NULL,
	[PBRHTimestamp] [timestamp] NULL,
	[PBRHPostFlag] [int] NOT NULL,
	[PBRHPostTheDate] [datetime] NULL,
	[PBRHPostUserID] [int] NULL,
	[PBRHInvoiceNum] [char](10) NULL,
	[PBRHOrdNum] [char](25) NULL,
	[PBRHNote] [nvarchar](200) NULL,
	[PlOID] [int] NULL,
	[DivToID] [int] NULL,
	[AdditionalNotes] [nvarchar](150) NULL,
 CONSTRAINT [PK_PlantHirePBReturnsHead] PRIMARY KEY CLUSTERED 
(
	[PBRHid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PlantHirePBReturnsHead] ADD  CONSTRAINT [DF_PlantHirePBReturnsHead_PBRHq1]  DEFAULT (0) FOR [PBRHq1]
ALTER TABLE [dbo].[PlantHirePBReturnsHead] ADD  CONSTRAINT [DF_PlantHirePBReturnsHead_PBHRq2]  DEFAULT (0) FOR [PBRHq2]
ALTER TABLE [dbo].[PlantHirePBReturnsHead] ADD  CONSTRAINT [DF_PlantHirePBReturnsHead_PBHRq3]  DEFAULT (0) FOR [PBRHq3]
ALTER TABLE [dbo].[PlantHirePBReturnsHead] ADD  CONSTRAINT [DF_PlantHirePBReturnsHead_PBHRq4]  DEFAULT (0) FOR [PBRHq4]
ALTER TABLE [dbo].[PlantHirePBReturnsHead] ADD  CONSTRAINT [DF_PlantHirePBReturnsHead_PBHRq5]  DEFAULT (0) FOR [PBRHq5]
ALTER TABLE [dbo].[PlantHirePBReturnsHead] ADD  CONSTRAINT [DF_PlantHirePBReturnsHead_PBRHWeekdays]  DEFAULT (1) FOR [PBRHIsWeekday]
ALTER TABLE [dbo].[PlantHirePBReturnsHead] ADD  CONSTRAINT [DF_PlantHirePBReturnsHead_HireRHolyday]  DEFAULT (0) FOR [PBRHIsHoliday]
ALTER TABLE [dbo].[PlantHirePBReturnsHead] ADD  CONSTRAINT [DF_PlantHirePBReturnsHead_PBRHIsPenDay]  DEFAULT (1) FOR [PBRHIsPenDay]
ALTER TABLE [dbo].[PlantHirePBReturnsHead] ADD  CONSTRAINT [DF_PlantHirePBReturnsHead_PeRate1]  DEFAULT (0) FOR [PBRHRate1]
ALTER TABLE [dbo].[PlantHirePBReturnsHead] ADD  CONSTRAINT [DF_PlantHirePBReturnsHead_PeRate2]  DEFAULT (0) FOR [PBRHRate2]
ALTER TABLE [dbo].[PlantHirePBReturnsHead] ADD  CONSTRAINT [DF_PlantHirePBReturnsHead_PeRate3]  DEFAULT (0) FOR [PBRHRate3]
ALTER TABLE [dbo].[PlantHirePBReturnsHead] ADD  CONSTRAINT [DF_PlantHirePBReturnsHead_PeRate4]  DEFAULT (0) FOR [PBRHRate4]
ALTER TABLE [dbo].[PlantHirePBReturnsHead] ADD  CONSTRAINT [DF_PlantHirePBReturnsHead_PeRate5]  DEFAULT (0) FOR [PBRHRate5]
ALTER TABLE [dbo].[PlantHirePBReturnsHead] ADD  CONSTRAINT [DF_PlantHirePBReturnsHead_PBRHCreationDate]  DEFAULT (getdate()) FOR [PBRHCreationDate]
ALTER TABLE [dbo].[PlantHirePBReturnsHead] ADD  CONSTRAINT [DF_PlantHirePBReturnsHead_HireRPostFlag]  DEFAULT (0) FOR [PBRHPostFlag]
ALTER TABLE [dbo].[PlantHirePBReturnsHead]  WITH CHECK ADD  CONSTRAINT [FK_PlantHirePBReturnsHead_ACTIVITIES] FOREIGN KEY([ActNumber])
REFERENCES [dbo].[ACTIVITIES] ([ActNumber])
ON UPDATE CASCADE
ALTER TABLE [dbo].[PlantHirePBReturnsHead] CHECK CONSTRAINT [FK_PlantHirePBReturnsHead_ACTIVITIES]
ALTER TABLE [dbo].[PlantHirePBReturnsHead]  WITH CHECK ADD  CONSTRAINT [FK_PlantHirePBReturnsHead_CONTRACTS] FOREIGN KEY([ContrNumber])
REFERENCES [dbo].[CONTRACTS] ([CONTRNUMBER])
ALTER TABLE [dbo].[PlantHirePBReturnsHead] CHECK CONSTRAINT [FK_PlantHirePBReturnsHead_CONTRACTS]
ALTER TABLE [dbo].[PlantHirePBReturnsHead]  WITH CHECK ADD  CONSTRAINT [FK_PlantHirePBReturnsHead_DEBTORS] FOREIGN KEY([DebtNumber])
REFERENCES [dbo].[DEBTORS] ([DebtNumber])
ALTER TABLE [dbo].[PlantHirePBReturnsHead] CHECK CONSTRAINT [FK_PlantHirePBReturnsHead_DEBTORS]
ALTER TABLE [dbo].[PlantHirePBReturnsHead]  WITH CHECK ADD  CONSTRAINT [FK_PlantHirePBReturnsHead_DIVISIONS] FOREIGN KEY([DivToID])
REFERENCES [dbo].[DIVISIONS] ([DivID])
ALTER TABLE [dbo].[PlantHirePBReturnsHead] CHECK CONSTRAINT [FK_PlantHirePBReturnsHead_DIVISIONS]
ALTER TABLE [dbo].[PlantHirePBReturnsHead]  WITH CHECK ADD  CONSTRAINT [FK_PlantHirePBReturnsHead_PLANTCATEGORIES] FOREIGN KEY([CatID])
REFERENCES [dbo].[PLANTCATEGORIES] ([CatID])
ON UPDATE CASCADE
ALTER TABLE [dbo].[PlantHirePBReturnsHead] CHECK CONSTRAINT [FK_PlantHirePBReturnsHead_PLANTCATEGORIES]
ALTER TABLE [dbo].[PlantHirePBReturnsHead]  WITH CHECK ADD  CONSTRAINT [FK_PlantHirePBReturnsHead_PlantHireFlag] FOREIGN KEY([HireFlag])
REFERENCES [dbo].[PlantHireFlag] ([HireFID])
ON UPDATE CASCADE
ALTER TABLE [dbo].[PlantHirePBReturnsHead] CHECK CONSTRAINT [FK_PlantHirePBReturnsHead_PlantHireFlag]
ALTER TABLE [dbo].[PlantHirePBReturnsHead]  WITH CHECK ADD  CONSTRAINT [FK_PlantHirePBReturnsHead_PlantHirePBHeader] FOREIGN KEY([PBHid])
REFERENCES [dbo].[PlantHirePBHeader] ([PBHid])
ON UPDATE CASCADE
ON DELETE CASCADE
ALTER TABLE [dbo].[PlantHirePBReturnsHead] CHECK CONSTRAINT [FK_PlantHirePBReturnsHead_PlantHirePBHeader]
ALTER TABLE [dbo].[PlantHirePBReturnsHead]  WITH CHECK ADD  CONSTRAINT [FK_PlantHirePBReturnsHead_PlantHireReturnsFlag1] FOREIGN KEY([PBRHPostFlag])
REFERENCES [dbo].[PlantHireReturnsFlag] ([HireRPostFlagID])
ON UPDATE CASCADE
ALTER TABLE [dbo].[PlantHirePBReturnsHead] CHECK CONSTRAINT [FK_PlantHirePBReturnsHead_PlantHireReturnsFlag1]
ALTER TABLE [dbo].[PlantHirePBReturnsHead]  WITH CHECK ADD  CONSTRAINT [FK_PlantHirePBReturnsHead_PlantOperators] FOREIGN KEY([PlOID])
REFERENCES [dbo].[PlantOperators] ([PlOID])
ALTER TABLE [dbo].[PlantHirePBReturnsHead] CHECK CONSTRAINT [FK_PlantHirePBReturnsHead_PlantOperators]
ALTER TABLE [dbo].[PlantHirePBReturnsHead]  WITH CHECK ADD  CONSTRAINT [FK_PlantHirePBReturnsHead_USERS] FOREIGN KEY([PBRHPostUserID])
REFERENCES [dbo].[USERS] ([USERID])
ALTER TABLE [dbo].[PlantHirePBReturnsHead] CHECK CONSTRAINT [FK_PlantHirePBReturnsHead_USERS]
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON


-- =============================================
-- Author:		Okker Botes
-- Create date: 20/12/2006
-- Description:	Calls the Plant Maintenance Stored Procedure
-- =============================================
CREATE TRIGGER [tg_PlantHirePBReturnsHead_PlantMaintenance] 
   ON  [dbo].[PlantHirePBReturnsHead] 
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

-- Variables to hold the values for the inserted or updated record tp = temp
	declare @tptRID int, 
			@tptPeNumber char(10), 
			@tptRUnit char(10), 
			@tptSMR decimal(18,1), 
			@tptDateOfR datetime, 
			@tptTypeID char(10)

	select	@tptRID = PBRHid,
			@tptPeNumber = PeNumber,
			@tptRUnit = SMRUnit,
			@tptSMR = PBHRCloseSMR,
			@tptDateOfR = PBRHDate,
			@tptTypeID = 8
	from (
		SELECT  TOP 100	inserted.PBRHid, PlantHirePBHeader.PeNumber, PLANTCATEGORIES.SMRUnit, 
							inserted.PBHRCloseSMR, inserted.PBRHDate
		FROM    inserted 
		INNER JOIN PlantHirePBHeader ON inserted.PBHid = PlantHirePBHeader.PBHid 
		INNER JOIN PLANTCATEGORIES ON inserted.CatID = PLANTCATEGORIES.CatID
		WHERE     (inserted.PBRHSortFlag = 0) OR (inserted.PBRHSortFlag = 3)
		ORDER BY inserted.PBHRCloseSMR DESC) Result 


-- Delete 
-- OAB 19-12-2006 I have to still take care of the deleting of a record  
--		union all
--		select PltRID, PeNumber, PltRUnit, PltRSMR, PltRDateOfReading, PltRIsService, JobCardID, ServID, PltFalgID, 'update' as type
--		from deleted
--		
	

--INSERT INTO PlantTest(Test1, Test2)
--VALUES ('triger call Plant Based', @tptRID)

DECLARE	@return_value int

EXEC	@return_value = [dbo].[spPlantUpdateServiceData]
		@tpRID = @tptRID,
		@tpPeNumber = @tptPeNumber,
		@tpRUnit = @tptRUnit,
		@tpSMR = @tptSMR,
		@tpDateOfR = @tptDateOfR,
		@tpTypeID = @tptTypeID

END
		
		
ALTER TABLE [dbo].[PlantHirePBReturnsHead] ENABLE TRIGGER [tg_PlantHirePBReturnsHead_PlantMaintenance]