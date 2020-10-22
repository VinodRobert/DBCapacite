/****** Object:  Table [dbo].[PlantHireReturns]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PlantHireReturns](
	[HireRNumber] [char](10) NOT NULL,
	[GlCode] [char](10) NOT NULL,
	[HireHNumber] [char](10) NOT NULL,
	[PeNumber] [char](10) NOT NULL,
	[HireRFromDate] [datetime] NOT NULL,
	[HireRToDate] [datetime] NOT NULL,
	[HireRPeriod] [int] NOT NULL,
	[HireRQ1] [numeric](18, 4) NOT NULL,
	[HireRQ2] [numeric](18, 4) NOT NULL,
	[HireRQ3] [numeric](18, 4) NOT NULL,
	[HireRQ4] [numeric](18, 4) NOT NULL,
	[HireRQ5] [numeric](18, 4) NOT NULL,
	[HireRRevRate1] [money] NOT NULL,
	[HireRRevRate2] [money] NOT NULL,
	[HireRRevRate3] [money] NOT NULL,
	[HireRRevRate4] [money] NOT NULL,
	[HireRRevRate5] [money] NOT NULL,
	[HireRFactor1] [numeric](18, 4) NOT NULL,
	[HireRFactor2] [numeric](18, 4) NOT NULL,
	[HireRFactor3] [numeric](18, 4) NOT NULL,
	[HireRFactor4] [numeric](18, 4) NOT NULL,
	[HireRFactor5] [numeric](18, 4) NOT NULL,
	[HireRWeekDays] [decimal](18, 2) NOT NULL,
	[HireRHolyday] [decimal](18, 2) NOT NULL,
	[HireRPenaltyHours] [decimal](18, 2) NOT NULL,
	[HireRRevPenaltyPerc] [numeric](18, 4) NOT NULL,
	[HireRPenaltyAmount] [money] NOT NULL,
	[HireRAmount] [money] NOT NULL,
	[HireRTotalAmount] [money] NOT NULL,
	[HireRSort] [int] IDENTITY(1,1) NOT NULL,
	[ActNumber] [char](10) NULL,
	[HireRSMRReading] [numeric](18, 4) NULL,
	[HireRSMRDate] [datetime] NULL,
	[HireRInvoiceNumber] [char](10) NULL,
	[HireRPostFlag] [int] NOT NULL,
	[HireRPostAmount] [numeric](18, 4) NULL,
	[HireRPostDate] [datetime] NULL,
	[HireRPostUserID] [int] NULL,
	[VATTYPE] [nvarchar](10) NOT NULL,
	[VATAMOUNT] [money] NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[PlantHireReturns] ADD  CONSTRAINT [DF_PlantHireReturns_HireRQ1]  DEFAULT ('0') FOR [HireRQ1]
ALTER TABLE [dbo].[PlantHireReturns] ADD  CONSTRAINT [DF_PlantHireReturns_HireRQ2]  DEFAULT ('0') FOR [HireRQ2]
ALTER TABLE [dbo].[PlantHireReturns] ADD  CONSTRAINT [DF_PlantHireReturns_HireRQ3]  DEFAULT ('0') FOR [HireRQ3]
ALTER TABLE [dbo].[PlantHireReturns] ADD  CONSTRAINT [DF_PlantHireReturns_HireRQ4]  DEFAULT ('0') FOR [HireRQ4]
ALTER TABLE [dbo].[PlantHireReturns] ADD  CONSTRAINT [DF_PlantHireReturns_HireRQ5]  DEFAULT ('0') FOR [HireRQ5]
ALTER TABLE [dbo].[PlantHireReturns] ADD  CONSTRAINT [DF_PlantHireReturns_HireRRetRate2]  DEFAULT (0) FOR [HireRRevRate2]
ALTER TABLE [dbo].[PlantHireReturns] ADD  CONSTRAINT [DF_PlantHireReturns_HireRRetRate3]  DEFAULT (0) FOR [HireRRevRate3]
ALTER TABLE [dbo].[PlantHireReturns] ADD  CONSTRAINT [DF_PlantHireReturns_HireRRetRate4]  DEFAULT (0) FOR [HireRRevRate4]
ALTER TABLE [dbo].[PlantHireReturns] ADD  CONSTRAINT [DF_PlantHireReturns_HireRRetRate5]  DEFAULT (0) FOR [HireRRevRate5]
ALTER TABLE [dbo].[PlantHireReturns] ADD  CONSTRAINT [DF_PlantHireReturns_HireRFactor1]  DEFAULT ('1') FOR [HireRFactor1]
ALTER TABLE [dbo].[PlantHireReturns] ADD  CONSTRAINT [DF_PlantHireReturns_HireRFactor2]  DEFAULT ('1') FOR [HireRFactor2]
ALTER TABLE [dbo].[PlantHireReturns] ADD  CONSTRAINT [DF_PlantHireReturns_HireRFactor3]  DEFAULT ('1') FOR [HireRFactor3]
ALTER TABLE [dbo].[PlantHireReturns] ADD  CONSTRAINT [DF_PlantHireReturns_HireRFactor4]  DEFAULT ('1') FOR [HireRFactor4]
ALTER TABLE [dbo].[PlantHireReturns] ADD  CONSTRAINT [DF_PlantHireReturns_HireRFactor5]  DEFAULT ('1') FOR [HireRFactor5]
ALTER TABLE [dbo].[PlantHireReturns] ADD  CONSTRAINT [DF_PlantHireReturns_HireRWeekDays]  DEFAULT (0) FOR [HireRWeekDays]
ALTER TABLE [dbo].[PlantHireReturns] ADD  CONSTRAINT [DF_PlantHireReturns_HireRHolyday]  DEFAULT (0) FOR [HireRHolyday]
ALTER TABLE [dbo].[PlantHireReturns] ADD  CONSTRAINT [DF_PlantHireReturns_HireRMinHours]  DEFAULT (0) FOR [HireRPenaltyHours]
ALTER TABLE [dbo].[PlantHireReturns] ADD  CONSTRAINT [DF_PlantHireReturns_HireRRevPenaltyPerc]  DEFAULT ('1') FOR [HireRRevPenaltyPerc]
ALTER TABLE [dbo].[PlantHireReturns] ADD  CONSTRAINT [DF__PlantHire__HireR__7F841646]  DEFAULT (0) FOR [HireRPostFlag]
ALTER TABLE [dbo].[PlantHireReturns] ADD  CONSTRAINT [DF_PLANTHIRERETURNS_VATTYPE]  DEFAULT ('Z|0') FOR [VATTYPE]
ALTER TABLE [dbo].[PlantHireReturns] ADD  CONSTRAINT [DF_PLANTHIRERETURNS_VATAMOUNT]  DEFAULT ((0)) FOR [VATAMOUNT]
ALTER TABLE [dbo].[PlantHireReturns]  WITH CHECK ADD  CONSTRAINT [FK_PlantHireReturns_ACTIVITIES1] FOREIGN KEY([ActNumber])
REFERENCES [dbo].[ACTIVITIES] ([ActNumber])
ON UPDATE CASCADE
ALTER TABLE [dbo].[PlantHireReturns] CHECK CONSTRAINT [FK_PlantHireReturns_ACTIVITIES1]
ALTER TABLE [dbo].[PlantHireReturns]  WITH CHECK ADD  CONSTRAINT [FK_PlantHireReturns_PlantHireReturnsFlag] FOREIGN KEY([HireRPostFlag])
REFERENCES [dbo].[PlantHireReturnsFlag] ([HireRPostFlagID])
ON UPDATE CASCADE
ALTER TABLE [dbo].[PlantHireReturns] CHECK CONSTRAINT [FK_PlantHireReturns_PlantHireReturnsFlag]
ALTER TABLE [dbo].[PlantHireReturns]  WITH CHECK ADD  CONSTRAINT [FK_PlantHireReturns_PlantHireReturnsHead] FOREIGN KEY([HireRNumber])
REFERENCES [dbo].[PlantHireReturnsHead] ([HireRNumber])
ON UPDATE CASCADE
ON DELETE CASCADE
ALTER TABLE [dbo].[PlantHireReturns] CHECK CONSTRAINT [FK_PlantHireReturns_PlantHireReturnsHead]
ALTER TABLE [dbo].[PlantHireReturns]  WITH CHECK ADD  CONSTRAINT [FK_PlantHireReturns_USERS] FOREIGN KEY([HireRPostUserID])
REFERENCES [dbo].[USERS] ([USERID])
ALTER TABLE [dbo].[PlantHireReturns] CHECK CONSTRAINT [FK_PlantHireReturns_USERS]
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON


-- =============================================
-- Author:		Okker Botes
-- Create date: 20/12/2006
-- Description:	Calls the Plant Maintenance Stored Procedure
-- =============================================
CREATE TRIGGER [tg_PlantHireReturns_PlantMaintenance] 
   ON  [dbo].[PlantHireReturns]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


-- Variables to hold the values for the inserted or updated record tp = temp
	declare @tptRID char(10), 
			@tptPeNumber char(10), 
			@tptRUnit char(10), 
			@tptSMR decimal(18,1), 
			@tptDateOfR datetime, 
			@tptTypeID char(10)

	select	@tptRID = HireRNumber,
			@tptPeNumber = PeNumber,
			@tptRUnit = SMRUnit,
			@tptSMR = HireRSMRReading,
			@tptDateOfR = HireRSMRDate,
			@tptTypeID = 9
	from (
		SELECT  inserted.HireRNumber, inserted.PeNumber, PLANTCATEGORIES.SMRUnit, inserted.HireRSMRReading, 
				inserted.HireRSMRDate
		FROM  PLANTCATEGORIES 
		INNER JOIN PLANTANDEQ ON PLANTCATEGORIES.CatID = PLANTANDEQ.CatID 
		INNER JOIN inserted ON PLANTANDEQ.PeNumber = inserted.PeNumber) Result 


-- Delete 
-- OAB 19-12-2006 I have to still take care of the deleting of a record  
--		union all
--		select PltRID, PeNumber, PltRUnit, PltRSMR, PltRDateOfReading, PltRIsService, JobCardID, ServID, PltFalgID, 'update' as type
--		from deleted
--		
	

--INSERT INTO PlantTest(Test1, Test2, Test3, Test4, Test5, Test6)
--VALUES ('triger call Req Based', @tptRID, @tptPeNumber, @tptRUnit, @tptSMR, @tptDateOfR)

DECLARE	@return_value int

EXEC	@return_value = [dbo].[spPlantUpdateServiceData]
		@tpRID = @tptRID,
		@tpPeNumber = @tptPeNumber,
		@tpRUnit = @tptRUnit,
		@tpSMR = @tptSMR,
		@tpDateOfR = @tptDateOfR,
		@tpTypeID = @tptTypeID

END
	
		
ALTER TABLE [dbo].[PlantHireReturns] ENABLE TRIGGER [tg_PlantHireReturns_PlantMaintenance]