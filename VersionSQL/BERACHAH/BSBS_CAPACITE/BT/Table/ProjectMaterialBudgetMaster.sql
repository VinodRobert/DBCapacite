/****** Object:  Table [BT].[ProjectMaterialBudgetMaster]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BT].[ProjectMaterialBudgetMaster](
	[ProjectMaterialBudgetCode] [int] NOT NULL,
	[ProjectCode] [int] NOT NULL,
	[ToolCode] [varchar](10) NULL,
	[BudgetQty] [decimal](18, 4) NULL,
	[BudgetRate] [decimal](18, 2) NULL,
	[BudgetAmount] [decimal](18, 2) NULL,
	[Status] [int] NULL,
	[RevisionID] [decimal](6, 2) NULL,
	[MajorRevision] [int] NULL,
	[MinorRevision] [int] NULL,
 CONSTRAINT [PK_ProjectMaterialBudgetMaster] PRIMARY KEY CLUSTERED 
(
	[ProjectMaterialBudgetCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]