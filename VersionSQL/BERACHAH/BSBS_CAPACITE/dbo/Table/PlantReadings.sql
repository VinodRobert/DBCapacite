/****** Object:  Table [dbo].[PlantReadings]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PlantReadings](
	[PltRID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[PeNumber] [char](10) NOT NULL,
	[PltRContrNum] [nvarchar](10) NULL,
	[PltRActNum] [char](10) NULL,
	[PltRUnit] [char](10) NOT NULL,
	[PltRSMR] [numeric](18, 4) NOT NULL,
	[PltRDateOfReading] [datetime] NOT NULL,
	[PltREntrDate] [datetime] NOT NULL,
	[PltRRefNum] [char](10) NULL,
	[PltRIsService] [bit] NOT NULL,
	[JobCardID] [int] NULL,
	[ServID] [int] NULL,
	[UserID] [int] NULL,
	[PltRLitres] [decimal](18, 4) NULL,
	[PltRAmount] [decimal](18, 4) NULL,
	[PltRPosted] [bit] NOT NULL,
	[PltFalgID] [int] NOT NULL,
 CONSTRAINT [PK_PlantReadings] PRIMARY KEY CLUSTERED 
(
	[PltRID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PlantReadings] ADD  CONSTRAINT [DF_PlantReadings_PltRSMR]  DEFAULT ('0') FOR [PltRSMR]
ALTER TABLE [dbo].[PlantReadings] ADD  CONSTRAINT [DF_PlantReadings_PltREntrDate]  DEFAULT (getdate()) FOR [PltREntrDate]
ALTER TABLE [dbo].[PlantReadings] ADD  CONSTRAINT [DF_PlantReadings_PltRIsService]  DEFAULT (0) FOR [PltRIsService]
ALTER TABLE [dbo].[PlantReadings] ADD  CONSTRAINT [DF__PlantRead__PltRP__1376005A]  DEFAULT (0) FOR [PltRPosted]
ALTER TABLE [dbo].[PlantReadings] ADD  CONSTRAINT [DF__PlantRead__PltFa__4DA2A1EF]  DEFAULT (1) FOR [PltFalgID]
ALTER TABLE [dbo].[PlantReadings]  WITH CHECK ADD  CONSTRAINT [FK_PlantReadings_ACTIVITIES] FOREIGN KEY([PltRActNum])
REFERENCES [dbo].[ACTIVITIES] ([ActNumber])
ON UPDATE CASCADE
ALTER TABLE [dbo].[PlantReadings] CHECK CONSTRAINT [FK_PlantReadings_ACTIVITIES]
ALTER TABLE [dbo].[PlantReadings]  WITH CHECK ADD  CONSTRAINT [FK_PlantReadings_JobCardHeader] FOREIGN KEY([JobCardID])
REFERENCES [dbo].[JobCardHeader] ([JobCardID])
ALTER TABLE [dbo].[PlantReadings] CHECK CONSTRAINT [FK_PlantReadings_JobCardHeader]
ALTER TABLE [dbo].[PlantReadings]  WITH CHECK ADD  CONSTRAINT [FK_PlantReadings_PLANTANDEQ] FOREIGN KEY([PeNumber])
REFERENCES [dbo].[PLANTANDEQ] ([PeNumber])
ON UPDATE CASCADE
ALTER TABLE [dbo].[PlantReadings] CHECK CONSTRAINT [FK_PlantReadings_PLANTANDEQ]
ALTER TABLE [dbo].[PlantReadings]  WITH CHECK ADD  CONSTRAINT [FK_PlantReadings_PlantReadingsFlags] FOREIGN KEY([PltFalgID])
REFERENCES [dbo].[PlantReadingsFlags] ([PltFID])
ON UPDATE CASCADE
ALTER TABLE [dbo].[PlantReadings] CHECK CONSTRAINT [FK_PlantReadings_PlantReadingsFlags]
ALTER TABLE [dbo].[PlantReadings]  WITH CHECK ADD  CONSTRAINT [FK_PlantReadings_PlantServiceTypes] FOREIGN KEY([ServID])
REFERENCES [dbo].[PlantServiceTypes] ([ServID])
ON UPDATE CASCADE
ALTER TABLE [dbo].[PlantReadings] CHECK CONSTRAINT [FK_PlantReadings_PlantServiceTypes]
ALTER TABLE [dbo].[PlantReadings]  WITH CHECK ADD  CONSTRAINT [FK_PlantReadings_USERS] FOREIGN KEY([UserID])
REFERENCES [dbo].[USERS] ([USERID])
ON UPDATE CASCADE
ALTER TABLE [dbo].[PlantReadings] CHECK CONSTRAINT [FK_PlantReadings_USERS]
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON


-- =============================================
-- Author:		Okker Botes
-- Create date: 20/12/2006
-- Description:	Calls the Plant Maintenance Stored Procedure
-- =============================================
CREATE TRIGGER [tg_PlantReading_Maintenance] 
   ON  [dbo].[PlantReadings] 
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN --1
SET XACT_ABORT ON 
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for trigger here

-- Variables to hold the values for the inserted or updated record tp = temp
	declare @tptRID int, 
			@tptPeNumber char(10), 
			@tptRUnit char(10), 
			@tptSMR decimal(18,1), 
			@tptDateOfR datetime, 
			@tptIsService bit,
			@tptServID int,
			@tptTypeID char(10)

	select	@tptRID = PltRID,
			@tptPeNumber = PeNumber,
			@tptRUnit = PltRUnit,
			@tptSMR = PltRSMR,
			@tptDateOfR = PltRDateOfReading,
			@tptIsService = PltRIsService,
			@tptServID = ServID,
			@tptTypeID = PltFalgID
	from (
		select PltRID, PeNumber, PltRUnit, PltRSMR, PltRDateOfReading, PltRIsService, JobCardID, ServID, PltFalgID, 'insert' as type
		from inserted ) Result 

-- Delete 
-- OAB 19-12-2006 I have to still take care of the deleting of a record  
--		union all
--		select PltRID, PeNumber, PltRUnit, PltRSMR, PltRDateOfReading, PltRIsService, JobCardID, ServID, PltFalgID, 'update' as type
--		from deleted
--		
	

--INSERT INTO PlantTest(Test1, Test2)
--VALUES ('triger call sp', @tptRID)



DECLARE	@return_value int

EXEC	@return_value = [dbo].[spPlantUpdateServiceData]
		@tpRID = @tptRID,
		@tpPeNumber = @tptPeNumber,
		@tpRUnit = @tptRUnit,
		@tpSMR = @tptSMR,
		@tpDateOfR = @tptDateOfR,
		@tpIsService = @tptIsService,
		@tpServID = @tptServID,
		@tpTypeID = @tptTypeID

END --1
		
		
ALTER TABLE [dbo].[PlantReadings] ENABLE TRIGGER [tg_PlantReading_Maintenance]