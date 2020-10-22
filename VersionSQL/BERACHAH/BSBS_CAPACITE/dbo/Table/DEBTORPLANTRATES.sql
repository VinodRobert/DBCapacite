/****** Object:  Table [dbo].[DEBTORPLANTRATES]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DEBTORPLANTRATES](
	[PeNumber] [char](10) NULL,
	[debtcode] [char](10) NULL,
	[debtrate1] [money] NULL,
	[debtrate2] [money] NULL,
	[debtrate3] [money] NULL,
	[debtrate4] [money] NULL,
	[debtrate5] [money] NULL,
	[BorgID] [int] NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[DEBTORPLANTRATES] ADD  CONSTRAINT [DF_DEBTORPLANTRATES_BorgID]  DEFAULT ((-1)) FOR [BorgID]