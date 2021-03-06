/****** Object:  Table [BT].[RELEASESUMMARY]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BT].[RELEASESUMMARY](
	[RELEASESUMMARYID] [bigint] NOT NULL,
	[RELEASEDATE] [datetime] NULL,
	[PROJECTCODE] [int] NULL,
	[TOOLCODE] [varchar](10) NULL,
	[RELEASEQTY] [decimal](18, 4) NULL,
	[YEARPERIODID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[RELEASESUMMARYID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]