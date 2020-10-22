/****** Object:  Table [dbo].[CONTRACTPGEVAL]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CONTRACTPGEVAL](
	[ConID] [int] IDENTITY(1,1) NOT NULL,
	[ReconID] [int] NOT NULL,
	[LedgerID] [int] NOT NULL,
	[EstValue] [money] NOT NULL,
	[ProvCTC] [money] NOT NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[ContactID] [int] NULL,
	[DateCompleted] [datetime] NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[CONTRACTPGEVAL] ADD  CONSTRAINT [DF_CONTRACTPGEVAL_LedgerID]  DEFAULT ((-1)) FOR [LedgerID]
ALTER TABLE [dbo].[CONTRACTPGEVAL] ADD  CONSTRAINT [DF_CONTRACTPGEVAL_EstValue]  DEFAULT (0) FOR [EstValue]
ALTER TABLE [dbo].[CONTRACTPGEVAL] ADD  CONSTRAINT [DF_CONTRACTPGEVAL_ProvCTC]  DEFAULT (0) FOR [ProvCTC]