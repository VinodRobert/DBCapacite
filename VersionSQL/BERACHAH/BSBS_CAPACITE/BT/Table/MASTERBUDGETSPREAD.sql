/****** Object:  Table [BT].[MASTERBUDGETSPREAD]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BT].[MASTERBUDGETSPREAD](
	[BUDGETSPREADID] [int] NOT NULL,
	[BUDGETID] [int] NULL,
	[PROJECTCODE] [int] NULL,
	[BUDGETCODE] [varchar](15) NULL,
	[YEARPERIODCODE] [int] NULL,
	[PERIODBUDGET] [decimal](18, 2) NULL,
	[REVISIONID] [int] NULL,
 CONSTRAINT [PK_MASTERBUDGETSPREAD] PRIMARY KEY CLUSTERED 
(
	[BUDGETSPREADID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]