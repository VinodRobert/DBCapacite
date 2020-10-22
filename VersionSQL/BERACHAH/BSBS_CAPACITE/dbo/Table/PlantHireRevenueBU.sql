/****** Object:  Table [dbo].[PlantHireRevenueBU]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PlantHireRevenueBU](
	[CatID] [int] NOT NULL,
	[LedgerCode] [char](10) NOT NULL,
	[HireRevRate1] [money] NOT NULL,
	[HireRevRate2] [money] NOT NULL,
	[HireRevRate3] [money] NOT NULL,
	[HireRevRate4] [money] NOT NULL,
	[HireRevRate5] [money] NOT NULL,
	[HireRevPenaltyPerc] [numeric](18, 4) NOT NULL,
 CONSTRAINT [PK_PlantHireRevenueBU] PRIMARY KEY CLUSTERED 
(
	[CatID] ASC,
	[LedgerCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PlantHireRevenueBU] ADD  CONSTRAINT [DF_PlantHireRevenueBU_HireRevRate]  DEFAULT (0) FOR [HireRevRate1]
ALTER TABLE [dbo].[PlantHireRevenueBU] ADD  CONSTRAINT [DF_PlantHireRevenueBU_HireRevRate2]  DEFAULT (0) FOR [HireRevRate2]
ALTER TABLE [dbo].[PlantHireRevenueBU] ADD  CONSTRAINT [DF_PlantHireRevenueBU_HireRevRate3]  DEFAULT (0) FOR [HireRevRate3]
ALTER TABLE [dbo].[PlantHireRevenueBU] ADD  CONSTRAINT [DF_PlantHireRevenueBU_HireRevRate4]  DEFAULT (0) FOR [HireRevRate4]
ALTER TABLE [dbo].[PlantHireRevenueBU] ADD  CONSTRAINT [DF_PlantHireRevenueBU_HireRevRate5]  DEFAULT (0) FOR [HireRevRate5]
ALTER TABLE [dbo].[PlantHireRevenueBU] ADD  CONSTRAINT [DF_PlantHireRevenueBU_HireRevPenaltyPerc]  DEFAULT ('0') FOR [HireRevPenaltyPerc]
ALTER TABLE [dbo].[PlantHireRevenueBU]  WITH CHECK ADD  CONSTRAINT [FK_PlantHireRevenueBU_LEDGERCODES] FOREIGN KEY([LedgerCode])
REFERENCES [dbo].[LEDGERCODES] ([LedgerCode])
ON UPDATE CASCADE
ON DELETE CASCADE
ALTER TABLE [dbo].[PlantHireRevenueBU] CHECK CONSTRAINT [FK_PlantHireRevenueBU_LEDGERCODES]
ALTER TABLE [dbo].[PlantHireRevenueBU]  WITH CHECK ADD  CONSTRAINT [FK_PlantHireRevenueBU_PLANTCATEGORIES] FOREIGN KEY([CatID])
REFERENCES [dbo].[PLANTCATEGORIES] ([CatID])
ON UPDATE CASCADE
ON DELETE CASCADE
ALTER TABLE [dbo].[PlantHireRevenueBU] CHECK CONSTRAINT [FK_PlantHireRevenueBU_PLANTCATEGORIES]