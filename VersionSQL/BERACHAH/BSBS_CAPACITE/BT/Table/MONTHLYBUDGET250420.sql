/****** Object:  Table [BT].[MONTHLYBUDGET250420]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BT].[MONTHLYBUDGET250420](
	[MonthlyMaterialBudgetCode] [int] NOT NULL,
	[ProjectCode] [int] NOT NULL,
	[ToolCode] [varchar](35) NOT NULL,
	[CategoryType] [char](1) NOT NULL,
	[BudgetCategoryName] [varchar](400) NOT NULL,
	[UOM] [varchar](25) NULL,
	[CumulativeQty] [decimal](18, 4) NULL,
	[BudgetRate] [decimal](18, 4) NULL,
	[BudgetAmount] [decimal](18, 4) NULL,
	[OrderedQty] [decimal](18, 4) NULL,
	[OrderValue] [decimal](18, 4) NULL
) ON [PRIMARY]