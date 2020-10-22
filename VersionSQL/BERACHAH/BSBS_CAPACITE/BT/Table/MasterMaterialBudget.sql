/****** Object:  Table [BT].[MasterMaterialBudget]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BT].[MasterMaterialBudget](
	[INDEXCODE] [int] NOT NULL,
	[TEMPLATECODE] [varchar](10) NULL,
	[MATERIALMAJORHEAD] [varchar](50) NULL,
	[TEMPLATENAME] [varchar](255) NULL,
	[CATEGORY] [varchar](15) NULL,
	[UOM] [varchar](15) NULL,
 CONSTRAINT [PK_MasterMaterialBudget] PRIMARY KEY CLUSTERED 
(
	[INDEXCODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]