/****** Object:  Table [BT].[MATERIALBUDGET280120]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BT].[MATERIALBUDGET280120](
	[MonthlyMaterialBudgetCode] [int] NOT NULL,
	[ProjectCode] [int] NOT NULL,
	[ToolCode] [varchar](10) NOT NULL,
	[CategoryType] [char](1) NOT NULL,
	[BudgetCategoryName] [varchar](200) NOT NULL,
	[UOM] [varchar](15) NULL,
	[CumulativeQty] [decimal](18, 4) NULL,
	[BudgetRate] [decimal](18, 2) NULL,
	[BudgetAmount] [decimal](18, 2) NULL,
	[OrderedQty] [decimal](18, 4) NULL,
	[OrderValue] [decimal](18, 2) NULL
) ON [PRIMARY]