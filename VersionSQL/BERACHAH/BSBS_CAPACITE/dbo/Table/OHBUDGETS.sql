/****** Object:  Table [dbo].[OHBUDGETS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[OHBUDGETS](
	[BorgID] [int] NOT NULL,
	[LedgerID] [int] NOT NULL,
	[YearNo] [char](10) NOT NULL,
	[Period] [int] NOT NULL,
	[Budget] [money] NULL,
	[BudgetID] [int] IDENTITY(1,1) NOT NULL,
	[DIVID] [int] NOT NULL
) ON [PRIMARY]