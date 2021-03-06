/****** Object:  Table [dbo].[EDSUSAGE]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EDSUSAGE](
	[UID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[DESCR] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_EDSUSAGE] PRIMARY KEY CLUSTERED 
(
	[UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [IX_EDSUSAGE] UNIQUE NONCLUSTERED 
(
	[DESCR] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[EDSUSAGE] ADD  CONSTRAINT [DF_EDSUSAGE_DESCR]  DEFAULT ('') FOR [DESCR]