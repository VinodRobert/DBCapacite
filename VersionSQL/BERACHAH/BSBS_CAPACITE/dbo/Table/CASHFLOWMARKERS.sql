/****** Object:  Table [dbo].[CASHFLOWMARKERS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CASHFLOWMARKERS](
	[BORGID] [int] NOT NULL,
	[CFMarkerCode] [char](10) NOT NULL,
	[CFMarkerName] [char](55) NOT NULL,
	[CFMarkerID] [int] NOT NULL,
	[CFType] [int] NOT NULL,
	[CFFromGl] [char](10) NOT NULL,
	[CFToGL] [char](10) NOT NULL
) ON [PRIMARY]