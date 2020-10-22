/****** Object:  Table [dbo].[PLANTBUDGETS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PLANTBUDGETS](
	[BorgID] [int] NOT NULL,
	[LedgerID] [int] NOT NULL,
	[YearNo] [char](10) NOT NULL,
	[Period] [int] NOT NULL,
	[Budget] [money] NULL,
	[BudgetID] [int] IDENTITY(1,1) NOT NULL
) ON [PRIMARY]