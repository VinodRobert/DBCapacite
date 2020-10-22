/****** Object:  Table [dbo].[PlantHirePBReturnsValues]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PlantHirePBReturnsValues](
	[PBRHid] [int] NOT NULL,
	[GlCode] [char](10) NOT NULL,
	[PBHid] [int] NOT NULL,
	[PBRDRevRate1] [numeric](18, 4) NOT NULL,
	[PBRDRevRate2] [numeric](18, 4) NOT NULL,
	[PBRDRevRate3] [numeric](18, 4) NOT NULL,
	[PBRDRevRate4] [numeric](18, 4) NOT NULL,
	[PBRDRevRate5] [numeric](18, 4) NOT NULL,
	[PBRDPenRate] [numeric](18, 4) NOT NULL,
	[PBRDAmount1] [numeric](18, 4) NOT NULL,
	[PBRDAmount2] [numeric](18, 4) NOT NULL,
	[PBRDAmount3] [numeric](18, 4) NOT NULL,
	[PBRDAmount4] [numeric](18, 4) NOT NULL,
	[PBRDAmount5] [numeric](18, 4) NOT NULL,
	[PBRDAmount] [numeric](18, 4) NOT NULL,
	[PBRDPenaltyAmount] [numeric](18, 4) NOT NULL,
	[PBRDTotalAmount] [numeric](18, 4) NOT NULL,
	[HireRPostAmount] [numeric](18, 4) NOT NULL,
	[PBRDVatAmount] [numeric](18, 4) NOT NULL,
	[PBRDVatType] [char](10) NOT NULL,
	[PBRDVatRate] [numeric](18, 4) NOT NULL,
 CONSTRAINT [PK_PlantHirePBReturnsValues] PRIMARY KEY CLUSTERED 
(
	[PBRHid] ASC,
	[GlCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PlantHirePBReturnsValues] ADD  CONSTRAINT [DF_PlantHirePBReturnsValues_PBHid]  DEFAULT (0) FOR [PBHid]
ALTER TABLE [dbo].[PlantHirePBReturnsValues] ADD  CONSTRAINT [DF_PlantHirePBReturnsValues_PBRDRevRate1]  DEFAULT ('0') FOR [PBRDRevRate1]
ALTER TABLE [dbo].[PlantHirePBReturnsValues] ADD  CONSTRAINT [DF_PlantHirePBReturnsValues_PBRDRevRate2]  DEFAULT ('0') FOR [PBRDRevRate2]
ALTER TABLE [dbo].[PlantHirePBReturnsValues] ADD  CONSTRAINT [DF_PlantHirePBReturnsValues_PBRDRevRate3]  DEFAULT ('0') FOR [PBRDRevRate3]
ALTER TABLE [dbo].[PlantHirePBReturnsValues] ADD  CONSTRAINT [DF_PlantHirePBReturnsValues_PBRDRevRate4]  DEFAULT ('0') FOR [PBRDRevRate4]
ALTER TABLE [dbo].[PlantHirePBReturnsValues] ADD  CONSTRAINT [DF_PlantHirePBReturnsValues_PBRDRevRate5]  DEFAULT ('0') FOR [PBRDRevRate5]
ALTER TABLE [dbo].[PlantHirePBReturnsValues] ADD  CONSTRAINT [DF_PlantHirePBReturnsValues_PBRDPenRate]  DEFAULT ('0') FOR [PBRDPenRate]
ALTER TABLE [dbo].[PlantHirePBReturnsValues] ADD  CONSTRAINT [DF_PlantHirePBReturnsValues_PBRDAmount1]  DEFAULT ('0') FOR [PBRDAmount1]
ALTER TABLE [dbo].[PlantHirePBReturnsValues] ADD  CONSTRAINT [DF_PlantHirePBReturnsValues_PBRDAmount2]  DEFAULT ('0') FOR [PBRDAmount2]
ALTER TABLE [dbo].[PlantHirePBReturnsValues] ADD  CONSTRAINT [DF_PlantHirePBReturnsValues_PBRDAmount3]  DEFAULT ('0') FOR [PBRDAmount3]
ALTER TABLE [dbo].[PlantHirePBReturnsValues] ADD  CONSTRAINT [DF_PlantHirePBReturnsValues_PBRDAmount4]  DEFAULT ('0') FOR [PBRDAmount4]
ALTER TABLE [dbo].[PlantHirePBReturnsValues] ADD  CONSTRAINT [DF_PlantHirePBReturnsValues_PBRDAmount5]  DEFAULT ('0') FOR [PBRDAmount5]
ALTER TABLE [dbo].[PlantHirePBReturnsValues] ADD  CONSTRAINT [DF_PlantHirePBReturnsValues_PBRDAmount]  DEFAULT ('0') FOR [PBRDAmount]
ALTER TABLE [dbo].[PlantHirePBReturnsValues] ADD  CONSTRAINT [DF_PlantHirePBReturnsValues_PBRDPenaltyAmount]  DEFAULT ('0') FOR [PBRDPenaltyAmount]
ALTER TABLE [dbo].[PlantHirePBReturnsValues] ADD  CONSTRAINT [DF_PlantHirePBReturnsValues_PBRDTotalAmount]  DEFAULT ('0') FOR [PBRDTotalAmount]
ALTER TABLE [dbo].[PlantHirePBReturnsValues] ADD  CONSTRAINT [DF_PlantHirePBReturnsValues_HireRPostAmount]  DEFAULT ('0') FOR [HireRPostAmount]
ALTER TABLE [dbo].[PlantHirePBReturnsValues] ADD  CONSTRAINT [DF_PlantHirePBReturnsValues_PBRDVatAmount]  DEFAULT ('0') FOR [PBRDVatAmount]
ALTER TABLE [dbo].[PlantHirePBReturnsValues] ADD  DEFAULT ('') FOR [PBRDVatType]
ALTER TABLE [dbo].[PlantHirePBReturnsValues] ADD  CONSTRAINT [DF_PlantHirePBReturnsValues_PBRDVatRate]  DEFAULT ('0') FOR [PBRDVatRate]
ALTER TABLE [dbo].[PlantHirePBReturnsValues]  WITH CHECK ADD  CONSTRAINT [FK_PlantHirePBReturnsValues_PlantHirePBReturnsHead] FOREIGN KEY([PBRHid])
REFERENCES [dbo].[PlantHirePBReturnsHead] ([PBRHid])
ON UPDATE CASCADE
ON DELETE CASCADE
ALTER TABLE [dbo].[PlantHirePBReturnsValues] CHECK CONSTRAINT [FK_PlantHirePBReturnsValues_PlantHirePBReturnsHead]