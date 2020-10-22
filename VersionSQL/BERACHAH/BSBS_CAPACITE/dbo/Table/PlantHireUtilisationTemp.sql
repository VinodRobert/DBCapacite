/****** Object:  Table [dbo].[PlantHireUtilisationTemp]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PlantHireUtilisationTemp](
	[CatID] [int] NOT NULL,
	[PeNumber] [char](10) NOT NULL,
	[YearNum] [int] NULL,
	[ActHr1] [decimal](38, 1) NULL,
	[AvlHr1] [numeric](38, 3) NULL,
	[ActHr2] [decimal](38, 1) NULL,
	[AvlHr2] [numeric](38, 3) NULL,
	[ActHr3] [decimal](38, 1) NULL,
	[AvlHr3] [numeric](38, 3) NULL,
	[ActHr4] [decimal](38, 1) NULL,
	[AvlHr4] [numeric](38, 3) NULL,
	[ActHr5] [decimal](38, 1) NULL,
	[AvlHr5] [numeric](38, 3) NULL,
	[ActHr6] [decimal](38, 1) NULL,
	[AvlHr6] [numeric](38, 3) NULL,
	[ActHr7] [decimal](38, 1) NULL,
	[AvlHr7] [numeric](38, 3) NULL,
	[ActHr8] [decimal](38, 1) NULL,
	[AvlHr8] [numeric](38, 3) NULL,
	[ActHr9] [decimal](38, 1) NULL,
	[AvlHr9] [numeric](38, 3) NULL,
	[ActHr10] [decimal](38, 1) NULL,
	[AvlHr10] [numeric](38, 3) NULL,
	[ActHr11] [decimal](38, 1) NULL,
	[AvlHr11] [numeric](38, 3) NULL,
	[ActHr12] [decimal](38, 1) NULL,
	[AvlHr12] [numeric](38, 3) NULL,
	[HireRPostFlag] [int] NULL
) ON [PRIMARY]