/****** Object:  Table [dbo].[PlantHireDetail]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PlantHireDetail](
	[HireHNumber] [char](10) NOT NULL,
	[PeNumber] [char](10) NOT NULL,
	[HireDDateOnSite] [datetime] NOT NULL,
	[HireDDateOfSite] [datetime] NULL,
	[CatID] [int] NOT NULL,
	[HireFlag] [int] NULL,
	[PeRate1] [money] NOT NULL,
	[PeRate2] [money] NULL,
	[PeRate3] [money] NULL,
	[PeRate4] [money] NULL,
	[PeRate5] [money] NULL,
	[HireRDayMin] [numeric](18, 1) NULL,
	[HireRWeekMin] [numeric](18, 1) NULL,
	[HireRMonthMin] [numeric](18, 1) NULL,
	[PlantDCostGl] [char](10) NULL,
	[HireRRemove] [bit] NOT NULL,
	[REFERENCE] [char](10) NULL,
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MATERIALCODE] [nvarchar](10) NOT NULL,
 CONSTRAINT [PK_PlantHireDitail] PRIMARY KEY CLUSTERED 
(
	[HireHNumber] ASC,
	[PeNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PlantHireDetail] ADD  CONSTRAINT [DF_PlantHireDetail_HireRRemove]  DEFAULT ((0)) FOR [HireRRemove]
ALTER TABLE [dbo].[PlantHireDetail] ADD  CONSTRAINT [DF_PLANTHIREDETAIL_MATERIALCODE]  DEFAULT ('') FOR [MATERIALCODE]
ALTER TABLE [dbo].[PlantHireDetail]  WITH CHECK ADD  CONSTRAINT [FK_PlantHireDitail_PLANTANDEQ] FOREIGN KEY([PeNumber])
REFERENCES [dbo].[PLANTANDEQ] ([PeNumber])
ON UPDATE CASCADE
ALTER TABLE [dbo].[PlantHireDetail] CHECK CONSTRAINT [FK_PlantHireDitail_PLANTANDEQ]
ALTER TABLE [dbo].[PlantHireDetail]  WITH CHECK ADD  CONSTRAINT [FK_PlantHireDitail_PLANTCATEGORIES] FOREIGN KEY([CatID])
REFERENCES [dbo].[PLANTCATEGORIES] ([CatID])
ON UPDATE CASCADE
ALTER TABLE [dbo].[PlantHireDetail] CHECK CONSTRAINT [FK_PlantHireDitail_PLANTCATEGORIES]
ALTER TABLE [dbo].[PlantHireDetail]  WITH CHECK ADD  CONSTRAINT [FK_PlantHireDitail_PlantHireFalg] FOREIGN KEY([HireFlag])
REFERENCES [dbo].[PlantHireFlag] ([HireFID])
ON UPDATE CASCADE
ALTER TABLE [dbo].[PlantHireDetail] CHECK CONSTRAINT [FK_PlantHireDitail_PlantHireFalg]
ALTER TABLE [dbo].[PlantHireDetail]  WITH CHECK ADD  CONSTRAINT [FK_PlantHireDitail_PlantHireHeader1] FOREIGN KEY([HireHNumber])
REFERENCES [dbo].[PlantHireHeader] ([HireHNumber])
ON UPDATE CASCADE
ON DELETE CASCADE
ALTER TABLE [dbo].[PlantHireDetail] CHECK CONSTRAINT [FK_PlantHireDitail_PlantHireHeader1]