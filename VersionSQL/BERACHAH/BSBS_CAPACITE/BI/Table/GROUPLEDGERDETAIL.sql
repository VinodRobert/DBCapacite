/****** Object:  Table [BI].[GROUPLEDGERDETAIL]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BI].[GROUPLEDGERDETAIL](
	[GROUPLEDGERDETAILCODE] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[GROUPLEDGERCODE] [int] NULL,
	[LEDGERCODE] [varchar](10) NULL,
	[LEDGERNAME] [varchar](50) NULL,
 CONSTRAINT [PK_GROUPLEDGERDETAIL] PRIMARY KEY CLUSTERED 
(
	[GROUPLEDGERDETAILCODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]