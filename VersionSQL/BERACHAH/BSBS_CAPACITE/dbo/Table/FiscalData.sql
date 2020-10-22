/****** Object:  Table [dbo].[FiscalData]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[FiscalData](
	[FiscalCode] [nvarchar](10) NOT NULL,
	[FiscalDescr] [nvarchar](75) NOT NULL,
	[FiscalID] [int] NOT NULL
) ON [PRIMARY]