/****** Object:  Table [dbo].[PlantHirePBHeader]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PlantHirePBHeader](
	[PBHid] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[PeNumber] [char](10) NOT NULL,
	[PBHfDate] [datetime] NOT NULL,
	[PBHtDate] [datetime] NOT NULL,
	[PBHPenaltyCalc] [char](10) NOT NULL,
	[PlantDCostGl] [char](10) NULL,
	[UserID] [int] NOT NULL,
	[BorgID] [int] NOT NULL,
	[PBHCreateDate] [datetime] NOT NULL,
	[PBHClosed] [bit] NOT NULL,
	[PBRHhaveOpenSMR] [bit] NOT NULL,
	[PBRHhaveCloseSMR] [bit] NOT NULL,
	[BHRHvarIsZero] [bit] NOT NULL,
	[BHRHActEqToDifSMR] [bit] NOT NULL,
	[BHRHDivOpenCloseEqToAct] [bit] NOT NULL,
	[BHRHDivMinMaxEqToAct] [bit] NOT NULL,
	[BHRHExcFormInv] [bit] NOT NULL,
	[BHRHFinPeriod] [int] NULL,
	[BHRHFinYear] [int] NULL,
	[BHRHAlocation] [char](10) NOT NULL,
	[BHRHContNumber] [char](10) NULL,
	[BHRHDebtNumber] [char](10) NULL,
	[PBRHSite] [nvarchar](100) NULL,
	[PBRHLastUpdate] [datetime] NULL,
	[PBRHFromWhere] [nchar](20) NULL,
	[PBRHOverLG] [char](10) NULL,
 CONSTRAINT [PK_PlantHirePBHeader] PRIMARY KEY CLUSTERED 
(
	[PBHid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PlantHirePBHeader] ADD  CONSTRAINT [DF_PlantHirePBHeader_PBHPenaltyCalc]  DEFAULT ('month') FOR [PBHPenaltyCalc]
ALTER TABLE [dbo].[PlantHirePBHeader] ADD  CONSTRAINT [DF_PlantHirePBHeader_PBCreateDate]  DEFAULT (getdate()) FOR [PBHCreateDate]
ALTER TABLE [dbo].[PlantHirePBHeader] ADD  CONSTRAINT [DF_PlantHirePBHeader_PBHClosed]  DEFAULT (0) FOR [PBHClosed]
ALTER TABLE [dbo].[PlantHirePBHeader] ADD  DEFAULT (0) FOR [PBRHhaveOpenSMR]
ALTER TABLE [dbo].[PlantHirePBHeader] ADD  DEFAULT (0) FOR [PBRHhaveCloseSMR]
ALTER TABLE [dbo].[PlantHirePBHeader] ADD  DEFAULT (0) FOR [BHRHvarIsZero]
ALTER TABLE [dbo].[PlantHirePBHeader] ADD  DEFAULT (0) FOR [BHRHActEqToDifSMR]
ALTER TABLE [dbo].[PlantHirePBHeader] ADD  DEFAULT (0) FOR [BHRHDivOpenCloseEqToAct]
ALTER TABLE [dbo].[PlantHirePBHeader] ADD  DEFAULT (0) FOR [BHRHDivMinMaxEqToAct]
ALTER TABLE [dbo].[PlantHirePBHeader] ADD  DEFAULT (0) FOR [BHRHExcFormInv]
ALTER TABLE [dbo].[PlantHirePBHeader] ADD  DEFAULT ('None') FOR [BHRHAlocation]
ALTER TABLE [dbo].[PlantHirePBHeader]  WITH CHECK ADD  CONSTRAINT [FK_PlantHirePBHeader_BORGS] FOREIGN KEY([BorgID])
REFERENCES [dbo].[BORGS] ([BORGID])
ALTER TABLE [dbo].[PlantHirePBHeader] CHECK CONSTRAINT [FK_PlantHirePBHeader_BORGS]
ALTER TABLE [dbo].[PlantHirePBHeader]  WITH CHECK ADD  CONSTRAINT [FK_PlantHirePBHeader_LEDGERCODES] FOREIGN KEY([PlantDCostGl])
REFERENCES [dbo].[LEDGERCODES] ([LedgerCode])
ALTER TABLE [dbo].[PlantHirePBHeader] CHECK CONSTRAINT [FK_PlantHirePBHeader_LEDGERCODES]
ALTER TABLE [dbo].[PlantHirePBHeader]  WITH CHECK ADD  CONSTRAINT [FK_PlantHirePBHeader_LEDGERCODES1] FOREIGN KEY([PBRHOverLG])
REFERENCES [dbo].[LEDGERCODES] ([LedgerCode])
ALTER TABLE [dbo].[PlantHirePBHeader] CHECK CONSTRAINT [FK_PlantHirePBHeader_LEDGERCODES1]
ALTER TABLE [dbo].[PlantHirePBHeader]  WITH CHECK ADD  CONSTRAINT [FK_PlantHirePBHeader_PLANTANDEQ] FOREIGN KEY([PeNumber])
REFERENCES [dbo].[PLANTANDEQ] ([PeNumber])
ON UPDATE CASCADE
ALTER TABLE [dbo].[PlantHirePBHeader] CHECK CONSTRAINT [FK_PlantHirePBHeader_PLANTANDEQ]
ALTER TABLE [dbo].[PlantHirePBHeader]  WITH CHECK ADD  CONSTRAINT [FK_PlantHirePBHeader_USERS] FOREIGN KEY([UserID])
REFERENCES [dbo].[USERS] ([USERID])
ALTER TABLE [dbo].[PlantHirePBHeader] CHECK CONSTRAINT [FK_PlantHirePBHeader_USERS]
ALTER TABLE [dbo].[PlantHirePBHeader]  WITH NOCHECK ADD  CONSTRAINT [CK_PlantHirePBHeader_PBHPenetry_Values] CHECK  (([PBHPenaltyCalc] = 'Batch' or ([PBHPenaltyCalc] = 'week' or [PBHPenaltyCalc] = 'day')))
ALTER TABLE [dbo].[PlantHirePBHeader] CHECK CONSTRAINT [CK_PlantHirePBHeader_PBHPenetry_Values]