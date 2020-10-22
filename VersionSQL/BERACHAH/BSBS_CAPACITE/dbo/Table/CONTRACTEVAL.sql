/****** Object:  Table [dbo].[CONTRACTEVAL]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CONTRACTEVAL](
	[ConID] [int] IDENTITY(1,1) NOT NULL,
	[ReconID] [int] NOT NULL,
	[ActID] [int] NOT NULL,
	[LedgerID] [int] NOT NULL,
	[EstValue] [money] NOT NULL,
	[ProvCTC] [money] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[ContactID] [int] NOT NULL,
	[DateCompleted] [datetime] NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[CONTRACTEVAL] ADD  CONSTRAINT [DF_CONTRACTEVAL_ActID]  DEFAULT ((-1)) FOR [ActID]
ALTER TABLE [dbo].[CONTRACTEVAL] ADD  CONSTRAINT [DF_CONTRACTEVAL_LedgerID]  DEFAULT ((-1)) FOR [LedgerID]
ALTER TABLE [dbo].[CONTRACTEVAL] ADD  CONSTRAINT [DF_CONTRACTEVAL_EstValue]  DEFAULT (0) FOR [EstValue]
ALTER TABLE [dbo].[CONTRACTEVAL] ADD  CONSTRAINT [DF_CONTRACTEVAL_ProvCTC]  DEFAULT (0) FOR [ProvCTC]
ALTER TABLE [dbo].[CONTRACTEVAL] ADD  CONSTRAINT [DF_CONTRACTEVAL_StartDate]  DEFAULT (getdate()) FOR [StartDate]
ALTER TABLE [dbo].[CONTRACTEVAL] ADD  CONSTRAINT [DF_CONTRACTEVAL_EndDate]  DEFAULT (getdate() + 1) FOR [EndDate]
ALTER TABLE [dbo].[CONTRACTEVAL] ADD  CONSTRAINT [DF_CONTRACTEVAL_ContactID]  DEFAULT ((-1)) FOR [ContactID]
ALTER TABLE [dbo].[CONTRACTEVAL] ADD  CONSTRAINT [DF_CONTRACTEVAL_DateCompleted]  DEFAULT (getdate()) FOR [DateCompleted]