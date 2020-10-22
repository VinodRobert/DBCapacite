/****** Object:  Table [dbo].[ReqPlantHireReturnsHead]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ReqPlantHireReturnsHead](
	[HireRNumber] [char](10) NOT NULL,
	[HireHNumber] [char](10) NOT NULL,
	[PeNumber] [char](10) NOT NULL,
	[PeRate1] [money] NOT NULL,
	[PeRate2] [money] NOT NULL,
	[PeRate3] [money] NOT NULL,
	[PeRate4] [money] NOT NULL,
	[PeRate5] [money] NOT NULL,
	[HireRDayMin] [numeric](18, 1) NULL,
	[HireRWeekMin] [numeric](18, 1) NULL,
	[HireRMonthMin] [numeric](18, 1) NULL,
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HireRFromDate] [datetime] NULL,
	[HireRToDate] [datetime] NULL,
	[HireRQ1] [numeric](18, 4) NOT NULL,
	[HireRQ2] [numeric](18, 4) NOT NULL,
	[HireRQ3] [numeric](18, 4) NOT NULL,
	[HireRQ4] [numeric](18, 4) NOT NULL,
	[HireRQ5] [numeric](18, 5) NOT NULL,
	[HireRWeekDays] [decimal](18, 2) NOT NULL,
	[HireRHolyday] [decimal](18, 2) NOT NULL,
	[HireRPenaltyHours] [decimal](18, 2) NOT NULL,
	[ActNumber] [char](10) NULL,
	[HireRSMRReading] [numeric](18, 4) NULL,
	[HireRSMRDate] [datetime] NULL,
	[HireRInvoiceNumber] [char](10) NULL,
	[HireRPostFlag] [int] NOT NULL,
	[HireRPostDate] [datetime] NULL,
	[HireRPostUserID] [int] NULL,
	[VATTYPE] [nvarchar](10) NOT NULL,
	[HireFlag] [int] NULL,
	[HireRPeriod] [int] NOT NULL,
	[HireRYear] [int] NOT NULL,
	[SupersedePenHours] [bit] NOT NULL,
	[ADDITIONALNOTES] [nvarchar](255) NULL,
	[MATERIALCODE] [nvarchar](10) NOT NULL,
	[CATPROD1] [decimal](18, 4) NOT NULL,
	[CATPROD2] [decimal](18, 4) NOT NULL,
	[CATPROD3] [decimal](18, 4) NOT NULL,
 CONSTRAINT [PK_ReqPlantHireReturnsHead] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [Index_ID] ON [dbo].[ReqPlantHireReturnsHead]
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
ALTER TABLE [dbo].[ReqPlantHireReturnsHead] ADD  CONSTRAINT [DF_ReqPlantHireReturnsHead_PeRate1]  DEFAULT ((0)) FOR [PeRate1]
ALTER TABLE [dbo].[ReqPlantHireReturnsHead] ADD  CONSTRAINT [DF_ReqPlantHireReturnsHead_PeRate2]  DEFAULT ((0)) FOR [PeRate2]
ALTER TABLE [dbo].[ReqPlantHireReturnsHead] ADD  CONSTRAINT [DF_ReqPlantHireReturnsHead_PeRate3]  DEFAULT ((0)) FOR [PeRate3]
ALTER TABLE [dbo].[ReqPlantHireReturnsHead] ADD  CONSTRAINT [DF_ReqPlantHireReturnsHead_PeRate4]  DEFAULT ((0)) FOR [PeRate4]
ALTER TABLE [dbo].[ReqPlantHireReturnsHead] ADD  CONSTRAINT [DF_ReqPlantHireReturnsHead_PeRate5]  DEFAULT ((0)) FOR [PeRate5]
ALTER TABLE [dbo].[ReqPlantHireReturnsHead] ADD  CONSTRAINT [DF_ReqPlantHireReturnsHead_HireRDayMin]  DEFAULT ((0)) FOR [HireRDayMin]
ALTER TABLE [dbo].[ReqPlantHireReturnsHead] ADD  CONSTRAINT [DF_ReqPlantHireReturnsHead_HireRWeekMin]  DEFAULT ((0)) FOR [HireRWeekMin]
ALTER TABLE [dbo].[ReqPlantHireReturnsHead] ADD  CONSTRAINT [DF_ReqPlantHireReturnsHead_HireRMonthMin]  DEFAULT ((0)) FOR [HireRMonthMin]
ALTER TABLE [dbo].[ReqPlantHireReturnsHead] ADD  CONSTRAINT [DF_ReqPlantHireReturnsHead_HireRQ1]  DEFAULT ((0)) FOR [HireRQ1]
ALTER TABLE [dbo].[ReqPlantHireReturnsHead] ADD  CONSTRAINT [DF_ReqPlantHireReturnsHead_HireRQ2]  DEFAULT ((0)) FOR [HireRQ2]
ALTER TABLE [dbo].[ReqPlantHireReturnsHead] ADD  CONSTRAINT [DF_ReqPlantHireReturnsHead_HireRQ3]  DEFAULT ((0)) FOR [HireRQ3]
ALTER TABLE [dbo].[ReqPlantHireReturnsHead] ADD  CONSTRAINT [DF_ReqPlantHireReturnsHead_HireRQ4]  DEFAULT ((0)) FOR [HireRQ4]
ALTER TABLE [dbo].[ReqPlantHireReturnsHead] ADD  CONSTRAINT [DF_ReqPlantHireReturnsHead_HireRQ5]  DEFAULT ((0)) FOR [HireRQ5]
ALTER TABLE [dbo].[ReqPlantHireReturnsHead] ADD  CONSTRAINT [DF_ReqPlantHireReturnsHead_HireRWeekDays]  DEFAULT ((0)) FOR [HireRWeekDays]
ALTER TABLE [dbo].[ReqPlantHireReturnsHead] ADD  CONSTRAINT [DF_ReqPlantHireReturnsHead_HireRHolyday]  DEFAULT ((0)) FOR [HireRHolyday]
ALTER TABLE [dbo].[ReqPlantHireReturnsHead] ADD  CONSTRAINT [DF_ReqPlantHireReturnsHead_HireRPenaltyHours]  DEFAULT ((0)) FOR [HireRPenaltyHours]
ALTER TABLE [dbo].[ReqPlantHireReturnsHead] ADD  CONSTRAINT [DF_ReqPlantHireReturnsHead_HireRPostFlag]  DEFAULT ((0)) FOR [HireRPostFlag]
ALTER TABLE [dbo].[ReqPlantHireReturnsHead] ADD  CONSTRAINT [DF_ReqPlantHireReturnsHead_VATTYPE]  DEFAULT ('Z|0') FOR [VATTYPE]
ALTER TABLE [dbo].[ReqPlantHireReturnsHead] ADD  CONSTRAINT [DF_ReqPlantHireReturnsHead_HireRPeriod]  DEFAULT ((0)) FOR [HireRPeriod]
ALTER TABLE [dbo].[ReqPlantHireReturnsHead] ADD  CONSTRAINT [DF_ReqPlantHireReturnsHead_HireRYear]  DEFAULT (datepart(year,getdate())) FOR [HireRYear]
ALTER TABLE [dbo].[ReqPlantHireReturnsHead] ADD  CONSTRAINT [DF_ReqPlantHireReturnsHead_SupersedePenHours]  DEFAULT ('0') FOR [SupersedePenHours]
ALTER TABLE [dbo].[ReqPlantHireReturnsHead] ADD  CONSTRAINT [DF_REQPLANTHIRERETURNSHEAD_ADDITIONALNOTES]  DEFAULT ('') FOR [ADDITIONALNOTES]
ALTER TABLE [dbo].[ReqPlantHireReturnsHead] ADD  CONSTRAINT [DF_REQPLANTHIRERETURNSHEAD_MATERIALCODE]  DEFAULT ('') FOR [MATERIALCODE]
ALTER TABLE [dbo].[ReqPlantHireReturnsHead] ADD  CONSTRAINT [DF_REQPLANTHIRERETURNSHEAD_CATPROD1]  DEFAULT ((0)) FOR [CATPROD1]
ALTER TABLE [dbo].[ReqPlantHireReturnsHead] ADD  CONSTRAINT [DF_REQPLANTHIRERETURNSHEAD_CATPROD2]  DEFAULT ((0)) FOR [CATPROD2]
ALTER TABLE [dbo].[ReqPlantHireReturnsHead] ADD  CONSTRAINT [DF_REQPLANTHIRERETURNSHEAD_CATPROD3]  DEFAULT ((0)) FOR [CATPROD3]
ALTER TABLE [dbo].[ReqPlantHireReturnsHead]  WITH CHECK ADD  CONSTRAINT [FK_ReqPlantHireReturnsHead_ACTIVITIES] FOREIGN KEY([ActNumber])
REFERENCES [dbo].[ACTIVITIES] ([ActNumber])
ALTER TABLE [dbo].[ReqPlantHireReturnsHead] CHECK CONSTRAINT [FK_ReqPlantHireReturnsHead_ACTIVITIES]
ALTER TABLE [dbo].[ReqPlantHireReturnsHead]  WITH CHECK ADD  CONSTRAINT [FK_ReqPlantHireReturnsHead_PLANTANDEQ] FOREIGN KEY([PeNumber])
REFERENCES [dbo].[PLANTANDEQ] ([PeNumber])
ALTER TABLE [dbo].[ReqPlantHireReturnsHead] CHECK CONSTRAINT [FK_ReqPlantHireReturnsHead_PLANTANDEQ]
ALTER TABLE [dbo].[ReqPlantHireReturnsHead]  WITH CHECK ADD  CONSTRAINT [FK_ReqPlantHireReturnsHead_PlantHireHeader] FOREIGN KEY([HireHNumber])
REFERENCES [dbo].[PlantHireHeader] ([HireHNumber])
ALTER TABLE [dbo].[ReqPlantHireReturnsHead] CHECK CONSTRAINT [FK_ReqPlantHireReturnsHead_PlantHireHeader]
ALTER TABLE [dbo].[ReqPlantHireReturnsHead]  WITH CHECK ADD  CONSTRAINT [FK_ReqPlantHireReturnsHead_PlantHireReturnsFlag] FOREIGN KEY([HireRPostFlag])
REFERENCES [dbo].[PlantHireReturnsFlag] ([HireRPostFlagID])
ON UPDATE CASCADE
ALTER TABLE [dbo].[ReqPlantHireReturnsHead] CHECK CONSTRAINT [FK_ReqPlantHireReturnsHead_PlantHireReturnsFlag]
ALTER TABLE [dbo].[ReqPlantHireReturnsHead]  WITH CHECK ADD  CONSTRAINT [FK_ReqPlantHireReturnsHead_USERS] FOREIGN KEY([HireRPostUserID])
REFERENCES [dbo].[USERS] ([USERID])
ALTER TABLE [dbo].[ReqPlantHireReturnsHead] CHECK CONSTRAINT [FK_ReqPlantHireReturnsHead_USERS]
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON


-- =============================================
-- Author:		Okker Botes
-- Create date: 20/12/2006
-- Description:	Calls the Plant Maintenance Stored Procedure
-- Copied: 14/11/2011 RS for ReqPlantHireReturnsHead from PlantHireReturns
-- =============================================
CREATE TRIGGER [tg_ReqPlantHireReturnsHead_PlantMaintenance] 
   ON  [dbo].[ReqPlantHireReturnsHead]
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
	
		
ALTER TABLE [dbo].[ReqPlantHireReturnsHead] ENABLE TRIGGER [tg_ReqPlantHireReturnsHead_PlantMaintenance]