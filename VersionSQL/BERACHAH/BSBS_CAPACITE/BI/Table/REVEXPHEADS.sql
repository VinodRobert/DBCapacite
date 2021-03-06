/****** Object:  Table [BI].[REVEXPHEADS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BI].[REVEXPHEADS](
	[HEADID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HEADNAME] [varchar](20) NULL,
	[POSITION] [int] NULL,
	[CATEGORY] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[HEADID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]