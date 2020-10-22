/****** Object:  Table [dbo].[BANKLIST]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[BANKLIST](
	[BankID] [int] IDENTITY(1,1) NOT NULL,
	[BankName] [char](55) NOT NULL,
	[BIC] [nvarchar](25) NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[BANKLIST] ADD  CONSTRAINT [DF_BANKLIST_BankName]  DEFAULT (' ') FOR [BankName]
ALTER TABLE [dbo].[BANKLIST] ADD  CONSTRAINT [DF_BANKLIST_BIC]  DEFAULT ('') FOR [BIC]