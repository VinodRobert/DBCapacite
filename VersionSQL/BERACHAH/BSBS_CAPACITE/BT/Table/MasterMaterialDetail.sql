/****** Object:  Table [BT].[MasterMaterialDetail]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BT].[MasterMaterialDetail](
	[INDEXCODE] [int] IDENTITY(1,1) NOT NULL,
	[TEMPLATEID] [int] NULL,
	[MATERIALCODE] [varchar](35) NULL,
	[TEMPLATECODE] [varchar](25) NULL,
	[MATERIALNAME] [varchar](250) NULL,
	[UOM] [varchar](10) NULL,
	[STOCKID] [int] NULL,
	[CONVERSIONFATCTOR] [decimal](18, 2) NULL,
	[LASTPURCHASERATE] [decimal](18, 2) NULL,
 CONSTRAINT [PK_MasterMaterialDetail] PRIMARY KEY CLUSTERED 
(
	[INDEXCODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [BT].[MasterMaterialDetail]  WITH CHECK ADD  CONSTRAINT [FK_MasterMaterialDetail_MasterMaterialBudget] FOREIGN KEY([TEMPLATEID])
REFERENCES [BT].[MasterMaterialBudget] ([INDEXCODE])
ALTER TABLE [BT].[MasterMaterialDetail] CHECK CONSTRAINT [FK_MasterMaterialDetail_MasterMaterialBudget]