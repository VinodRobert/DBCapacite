/****** Object:  Table [dbo].[BATCHLOCK]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[BATCHLOCK](
	[LOCKID] [int] NOT NULL,
	[USERID] [int] NOT NULL,
	[BATCHID] [int] NOT NULL,
	[BATCHPROCESS] [nvarchar](1) NOT NULL,
	[ORGID] [int] NOT NULL,
	[LOCKDATE] [datetime] NOT NULL,
	[SESSIONID] [int] NOT NULL,
 CONSTRAINT [PK_BATCHLOCK] PRIMARY KEY CLUSTERED 
(
	[LOCKID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[BATCHLOCK] ADD  CONSTRAINT [DF_BATCHLOCK_USERID]  DEFAULT ((-1)) FOR [USERID]
ALTER TABLE [dbo].[BATCHLOCK] ADD  CONSTRAINT [DF_BATCHLOCK_BATCHID]  DEFAULT ((-1)) FOR [BATCHID]
ALTER TABLE [dbo].[BATCHLOCK] ADD  CONSTRAINT [DF_BATCHLOCK_ORGID]  DEFAULT ((-1)) FOR [ORGID]
ALTER TABLE [dbo].[BATCHLOCK] ADD  CONSTRAINT [DF_BATCHLOCK_LOCKDATE]  DEFAULT (getdate()) FOR [LOCKDATE]
ALTER TABLE [dbo].[BATCHLOCK] ADD  CONSTRAINT [DF_BATCHLOCK_SESSIONID]  DEFAULT ((-1)) FOR [SESSIONID]