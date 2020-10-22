/****** Object:  Table [BT].[ProjectMaterialBudgetDetail]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BT].[ProjectMaterialBudgetDetail](
	[ProjectMaterialBudgetDetailCode] [int] NOT NULL,
	[ProjectMaterialBudgetID] [int] NULL,
	[MonthID] [int] NULL,
	[BudgetQty] [decimal](18, 4) NULL,
	[BudgetRate] [decimal](18, 4) NULL,
	[BudgetAmount] [decimal](18, 2) NULL,
	[Status] [int] NULL,
	[RevisionID] [decimal](6, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[ProjectMaterialBudgetDetailCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [BT].[ProjectMaterialBudgetDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_ProjectMaterialBudgetDetail_ProjectMaterialBudgetMaster] FOREIGN KEY([ProjectMaterialBudgetID])
REFERENCES [BT].[ProjectMaterialBudgetMaster] ([ProjectMaterialBudgetCode])
ALTER TABLE [BT].[ProjectMaterialBudgetDetail] CHECK CONSTRAINT [FK_ProjectMaterialBudgetDetail_ProjectMaterialBudgetMaster]