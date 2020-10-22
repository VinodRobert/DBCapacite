/****** Object:  Table [dbo].[OTHERORGS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[OTHERORGS](
	[BORGID] [char](15) NOT NULL,
	[BORGNAME] [char](75) NULL,
	[BORGNAME1] [char](75) NULL,
	[BORGNAME2] [char](75) NULL,
	[ADDRESS] [char](75) NULL,
	[ADDRESS1] [char](75) NULL,
	[ADDRESS2] [char](75) NULL,
	[ADDRESS3] [char](75) NULL,
	[ADDRESS4] [char](75) NULL,
	[ADDRESS5] [char](75) NULL,
	[CITY] [char](25) NULL,
	[PROVINCE] [char](50) NULL,
	[LOCALE] [char](50) NULL,
	[COUNTRY] [char](50) NULL,
	[COMMENT] [text] NULL,
	[HOMEORG] [char](15) NULL,
	[POSTCODE] [char](10) NULL,
	[ACTIVE] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]