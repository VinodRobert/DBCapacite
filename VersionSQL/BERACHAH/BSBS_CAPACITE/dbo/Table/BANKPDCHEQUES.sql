/****** Object:  Table [dbo].[BANKPDCHEQUES]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[BANKPDCHEQUES](
	[BankID] [int] NOT NULL,
	[DueDate] [datetime] NOT NULL,
	[credno] [char](10) NOT NULL,
	[period] [int] NOT NULL,
	[year] [int] NOT NULL,
	[posted] [bit] NOT NULL,
	[Description] [char](255) NOT NULL,
	[Amount] [money] NOT NULL,
	[Currency] [char](3) NOT NULL,
	[ExchRate] [numeric](18, 4) NOT NULL,
	[PDCID] [int] IDENTITY(1,1) NOT NULL,
	[Transref] [char](10) NOT NULL,
	[MASTERTYPE] [nvarchar](25) NOT NULL,
	[ISSYS] [bit] NOT NULL,
	[USERID] [int] NOT NULL,
	[CHEQUESTATUS] [nvarchar](30) NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[BANKPDCHEQUES] ADD  CONSTRAINT [DF_BANKPDCHEQUES_BankID]  DEFAULT ((-1)) FOR [BankID]
ALTER TABLE [dbo].[BANKPDCHEQUES] ADD  CONSTRAINT [DF_BANKPDCHEQUES_DueDate]  DEFAULT (getdate()) FOR [DueDate]
ALTER TABLE [dbo].[BANKPDCHEQUES] ADD  CONSTRAINT [DF_BANKPDCHEQUES_credno]  DEFAULT ('') FOR [credno]
ALTER TABLE [dbo].[BANKPDCHEQUES] ADD  CONSTRAINT [DF_BANKPDCHEQUES_period]  DEFAULT ((1)) FOR [period]
ALTER TABLE [dbo].[BANKPDCHEQUES] ADD  CONSTRAINT [DF_BANKPDCHEQUES_year]  DEFAULT ('') FOR [year]
ALTER TABLE [dbo].[BANKPDCHEQUES] ADD  CONSTRAINT [DF_BANKPDCHEQUES_posted]  DEFAULT ((0)) FOR [posted]
ALTER TABLE [dbo].[BANKPDCHEQUES] ADD  CONSTRAINT [DF_BANKPDCHEQUES_Description]  DEFAULT ('') FOR [Description]
ALTER TABLE [dbo].[BANKPDCHEQUES] ADD  CONSTRAINT [DF_BANKPDCHEQUES_Amount]  DEFAULT ((0)) FOR [Amount]
ALTER TABLE [dbo].[BANKPDCHEQUES] ADD  CONSTRAINT [DF_BANKPDCHEQUES_Currency]  DEFAULT ('ZAR') FOR [Currency]
ALTER TABLE [dbo].[BANKPDCHEQUES] ADD  CONSTRAINT [DF_BANKPDCHEQUES_ExchRate]  DEFAULT ((1)) FOR [ExchRate]
ALTER TABLE [dbo].[BANKPDCHEQUES] ADD  CONSTRAINT [DF_BANKPDCHEQUES_Transref]  DEFAULT ('') FOR [Transref]
ALTER TABLE [dbo].[BANKPDCHEQUES] ADD  CONSTRAINT [DF_BANKPDCHEQUES_MASTERTYPE]  DEFAULT ('Creditor') FOR [MASTERTYPE]
ALTER TABLE [dbo].[BANKPDCHEQUES] ADD  CONSTRAINT [DF_BANKPDCHEQUES_ISSYS]  DEFAULT ('0') FOR [ISSYS]
ALTER TABLE [dbo].[BANKPDCHEQUES] ADD  CONSTRAINT [DF_BANKPDCHEQUES_USERID]  DEFAULT ((-1)) FOR [USERID]
ALTER TABLE [dbo].[BANKPDCHEQUES] ADD  CONSTRAINT [DF_BANKPDCHEQUES_CHEQUESTATUS]  DEFAULT ('US') FOR [CHEQUESTATUS]