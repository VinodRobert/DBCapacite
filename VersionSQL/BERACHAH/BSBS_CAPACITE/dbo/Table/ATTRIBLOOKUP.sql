/****** Object:  Table [dbo].[ATTRIBLOOKUP]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ATTRIBLOOKUP](
	[AID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[TABLENAME] [nvarchar](55) NOT NULL,
	[ATTRIBUTE] [nvarchar](55) NOT NULL,
	[VALUE] [nvarchar](55) NOT NULL,
	[DESCR] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_ATTRIBLOOKUP] PRIMARY KEY CLUSTERED 
(
	[TABLENAME] ASC,
	[ATTRIBUTE] ASC,
	[VALUE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ATTRIBLOOKUP] ADD  CONSTRAINT [DF_ATTRIBLOOKUP_TABLENAME]  DEFAULT ('') FOR [TABLENAME]
ALTER TABLE [dbo].[ATTRIBLOOKUP] ADD  CONSTRAINT [DF_ATTRIBLOOKUP_ATTRIBUTE]  DEFAULT ('') FOR [ATTRIBUTE]
ALTER TABLE [dbo].[ATTRIBLOOKUP] ADD  CONSTRAINT [DF_ATTRIBLOOKUP_VALUE]  DEFAULT ('') FOR [VALUE]
ALTER TABLE [dbo].[ATTRIBLOOKUP] ADD  CONSTRAINT [DF_ATTRIBLOOKUP_DESCR]  DEFAULT ('') FOR [DESCR]