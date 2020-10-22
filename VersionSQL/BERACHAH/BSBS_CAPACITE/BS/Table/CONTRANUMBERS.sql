/****** Object:  Table [BS].[CONTRANUMBERS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BS].[CONTRANUMBERS](
	[CONTRANUMERID] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CONTRABORGID] [int] NULL,
	[FINYEAR] [int] NULL,
	[NEXTINVNO] [int] NULL,
	[CONTRARECONID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CONTRANUMERID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]