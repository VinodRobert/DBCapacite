/****** Object:  Table [dbo].[CHEQUESR]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CHEQUESR](
	[BorgID] [int] NOT NULL,
	[CREDNO] [char](10) NOT NULL,
	[CREDNAME] [char](155) NOT NULL,
	[AMNT] [money] NOT NULL,
	[DISC] [money] NOT NULL,
	[CHEQUEDATE] [datetime] NULL,
	[CHEQUEAMOUNT] [varchar](250) NULL,
	[CHEQUEDAY] [char](2) NULL,
	[CHEQUEMONTH] [char](2) NULL,
	[CHEQUEYEAR] [char](4) NULL
) ON [PRIMARY]