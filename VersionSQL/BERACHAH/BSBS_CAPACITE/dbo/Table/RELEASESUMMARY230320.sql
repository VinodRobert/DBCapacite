/****** Object:  Table [dbo].[RELEASESUMMARY230320]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[RELEASESUMMARY230320](
	[RELEASESUMMARYID] [bigint] NOT NULL,
	[RELEASEDATE] [datetime] NULL,
	[PROJECTCODE] [int] NULL,
	[TOOLCODE] [varchar](10) NULL,
	[RELEASEQTY] [decimal](18, 4) NULL
) ON [PRIMARY]