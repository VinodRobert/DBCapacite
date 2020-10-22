/****** Object:  Table [dbo].[KEYCOMM]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[KEYCOMM](
	[KcommNumber] [nvarchar](20) NOT NULL,
	[KcommName] [char](35) NULL,
	[KcommUnit] [nvarchar](15) NOT NULL,
	[KcommEstRate] [money] NOT NULL,
	[KcommEstQuant] [numeric](18, 0) NOT NULL,
	[KcommActQuant] [numeric](18, 0) NOT NULL,
	[KcommProj] [char](10) NULL,
	[KcommCont] [char](10) NULL,
	[KcommAct] [char](10) NULL,
	[KcommLedgerCode] [char](10) NULL,
	[KCommID] [int] IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[KEYCOMM] ADD  CONSTRAINT [DF_KEYCOMM_KCOMMNUMBER]  DEFAULT ('') FOR [KcommNumber]
ALTER TABLE [dbo].[KEYCOMM] ADD  CONSTRAINT [DF_KEYCOMM_KcommUnit]  DEFAULT ('') FOR [KcommUnit]
ALTER TABLE [dbo].[KEYCOMM] ADD  CONSTRAINT [DF_KEYCOMM_KcommEstRate]  DEFAULT (0) FOR [KcommEstRate]
ALTER TABLE [dbo].[KEYCOMM] ADD  CONSTRAINT [DF_KEYCOMM_KcommEstQuant]  DEFAULT (0) FOR [KcommEstQuant]
ALTER TABLE [dbo].[KEYCOMM] ADD  CONSTRAINT [DF_KEYCOMM_KcommActQuant]  DEFAULT (0) FOR [KcommActQuant]