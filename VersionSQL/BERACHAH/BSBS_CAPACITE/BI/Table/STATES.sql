/****** Object:  Table [BI].[STATES]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BI].[STATES](
	[STATENAME] [varchar](50) NULL,
	[STATECODE] [char](2) NULL,
	[SHORTNAME] [char](2) NULL,
	[PROVINCEID] [int] NULL
) ON [PRIMARY]