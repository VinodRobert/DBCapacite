/****** Object:  Table [BI].[ASSETDEPHISTORY]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BI].[ASSETDEPHISTORY](
	[HISTORYID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[DEPYEAR] [int] NULL,
	[DEPMONTH] [int] NULL,
	[DEPMONTHNAME] [varchar](20) NULL,
	[ACTIVEMONTH] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[HISTORYID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]