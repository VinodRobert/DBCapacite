/****** Object:  Table [dbo].[TRANSACTIONSSOURCE]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TRANSACTIONSSOURCE](
	[TSID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SCODE] [nvarchar](10) NOT NULL,
	[SID] [int] NOT NULL,
	[STRANID] [int] NOT NULL,
	[STRANGROUP] [int] NOT NULL,
	[PTRANID] [int] NULL,
	[PTRANGROUP] [int] NULL,
 CONSTRAINT [PK_TRANSACTIONSSOURCE] PRIMARY KEY CLUSTERED 
(
	[TSID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TRANSACTIONSSOURCE] ADD  CONSTRAINT [DF_TRANSACTIONSSOURCE_SCODE]  DEFAULT ('') FOR [SCODE]
ALTER TABLE [dbo].[TRANSACTIONSSOURCE] ADD  CONSTRAINT [DF_TRANSACTIONSSOURCE_SID]  DEFAULT ((-1)) FOR [SID]
ALTER TABLE [dbo].[TRANSACTIONSSOURCE] ADD  CONSTRAINT [DF_TRANSACTIONSSOURCE_STRANID]  DEFAULT ((-1)) FOR [STRANID]
ALTER TABLE [dbo].[TRANSACTIONSSOURCE] ADD  CONSTRAINT [DF_TRANSACTIONSSOURCE_STRANGROUP]  DEFAULT ((-1)) FOR [STRANGROUP]