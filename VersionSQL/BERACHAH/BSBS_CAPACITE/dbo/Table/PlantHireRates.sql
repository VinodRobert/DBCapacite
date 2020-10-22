/****** Object:  Table [dbo].[PlantHireRates]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PlantHireRates](
	[HireRID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HireFlag] [int] NOT NULL,
	[PeNumber] [char](10) NULL,
	[DebtNumber] [char](10) NULL,
	[SubNumber] [char](10) NULL,
	[ContractNum] [nvarchar](10) NULL,
	[HireRate1] [money] NULL,
	[HireRate2] [money] NULL,
	[HireRate3] [money] NULL,
	[HireRate4] [money] NULL,
	[HireRate5] [money] NULL,
	[HireRDayMin] [numeric](18, 1) NULL,
	[HireRWeekMin] [numeric](18, 1) NULL,
	[HireRMonthMin] [numeric](18, 1) NULL,
	[HireROrdNum] [char](25) NULL,
	[HireRNote] [nvarchar](200) NULL,
	[DivID] [int] NULL,
 CONSTRAINT [PK_PlantHireRates] PRIMARY KEY CLUSTERED 
(
	[HireRID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PlantHireRates]  WITH CHECK ADD  CONSTRAINT [FK_PlantHireRates_CONTRACTS] FOREIGN KEY([ContractNum])
REFERENCES [dbo].[CONTRACTS] ([CONTRNUMBER])
ON UPDATE CASCADE
ALTER TABLE [dbo].[PlantHireRates] CHECK CONSTRAINT [FK_PlantHireRates_CONTRACTS]
ALTER TABLE [dbo].[PlantHireRates]  WITH CHECK ADD  CONSTRAINT [FK_PlantHireRates_DEBTORS] FOREIGN KEY([DebtNumber])
REFERENCES [dbo].[DEBTORS] ([DebtNumber])
ON UPDATE CASCADE
ALTER TABLE [dbo].[PlantHireRates] CHECK CONSTRAINT [FK_PlantHireRates_DEBTORS]
ALTER TABLE [dbo].[PlantHireRates]  WITH CHECK ADD  CONSTRAINT [FK_PlantHireRates_DIVISIONS] FOREIGN KEY([DivID])
REFERENCES [dbo].[DIVISIONS] ([DivID])
ALTER TABLE [dbo].[PlantHireRates] CHECK CONSTRAINT [FK_PlantHireRates_DIVISIONS]
ALTER TABLE [dbo].[PlantHireRates]  WITH CHECK ADD  CONSTRAINT [FK_PlantHireRates_PLANTANDEQ1] FOREIGN KEY([PeNumber])
REFERENCES [dbo].[PLANTANDEQ] ([PeNumber])
ON UPDATE CASCADE
ALTER TABLE [dbo].[PlantHireRates] CHECK CONSTRAINT [FK_PlantHireRates_PLANTANDEQ1]
ALTER TABLE [dbo].[PlantHireRates]  WITH CHECK ADD  CONSTRAINT [FK_PlantHireRates_PlantHireFalg1] FOREIGN KEY([HireFlag])
REFERENCES [dbo].[PlantHireFlag] ([HireFID])
ON UPDATE CASCADE
ALTER TABLE [dbo].[PlantHireRates] CHECK CONSTRAINT [FK_PlantHireRates_PlantHireFalg1]
ALTER TABLE [dbo].[PlantHireRates]  WITH CHECK ADD  CONSTRAINT [FK_PlantHireRates_SUBCONTRACTORS] FOREIGN KEY([SubNumber])
REFERENCES [dbo].[SUBCONTRACTORS] ([SubNumber])
ON UPDATE CASCADE
ALTER TABLE [dbo].[PlantHireRates] CHECK CONSTRAINT [FK_PlantHireRates_SUBCONTRACTORS]