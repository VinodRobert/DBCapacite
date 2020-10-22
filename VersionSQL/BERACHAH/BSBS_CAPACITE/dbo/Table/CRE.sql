/****** Object:  Table [dbo].[CRE]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CRE](
	[CredNumber] [char](10) NOT NULL,
	[CredAddress1] [char](55) NULL,
	[CredAddress2] [char](55) NULL,
	[CredAddress3] [char](55) NULL,
	[CredPcode] [char](20) NULL,
	[CredTel] [char](35) NULL,
	[CredFax] [char](35) NULL,
	[CredeMail] [char](80) NULL,
	[CredVAT] [char](25) NOT NULL,
	[CredSelect] [char](5) NOT NULL
) ON [PRIMARY]