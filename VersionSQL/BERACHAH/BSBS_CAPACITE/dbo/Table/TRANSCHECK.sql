/****** Object:  Table [dbo].[TRANSCHECK]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TRANSCHECK](
	[Credno] [char](10) NOT NULL,
	[Debtno] [char](10) NOT NULL,
	[SubNo] [char](10) NOT NULL,
	[Transref] [char](10) NOT NULL,
	[OrgID] [int] NOT NULL,
	[TransType] [char](10) NOT NULL
) ON [PRIMARY]