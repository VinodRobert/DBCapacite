/****** Object:  Table [dbo].[CODES]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CODES](
	[SHORTDESCR] [nvarchar](55) NOT NULL,
	[LONGDESCR] [nvarchar](500) NOT NULL,
	[CODETYPE] [char](3) NOT NULL,
	[ISACTIVE] [bit] NOT NULL,
	[CODEID] [int] NULL,
 CONSTRAINT [PK_CODES] PRIMARY KEY NONCLUSTERED 
(
	[SHORTDESCR] ASC,
	[CODETYPE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CODES] ADD  CONSTRAINT [DF_PAYMENTTYPES_LONGDESCR]  DEFAULT ('') FOR [LONGDESCR]
ALTER TABLE [dbo].[CODES] ADD  CONSTRAINT [DF_CODES_TYPE]  DEFAULT ('PMT') FOR [CODETYPE]
ALTER TABLE [dbo].[CODES] ADD  CONSTRAINT [DF_CODES_ISACTIVE]  DEFAULT (1) FOR [ISACTIVE]