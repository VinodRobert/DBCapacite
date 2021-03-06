/****** Object:  Table [dbo].[UDCOSTCODEGROUP]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[UDCOSTCODEGROUP](
	[LENGTH] [int] NOT NULL,
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[DESCR] [nvarchar](55) NOT NULL,
	[TABLENAME] [nvarchar](55) NOT NULL,
	[COLKEY] [nvarchar](55) NOT NULL,
	[COLUMNNAME] [nvarchar](55) NOT NULL,
	[STARTPOS] [int] NOT NULL,
	[ISDEF] [bit] NOT NULL,
 CONSTRAINT [PK_UDCOSTCODEGROUP] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[UDCOSTCODEGROUP] ADD  CONSTRAINT [DF_UDCOSTCODEGROUP_LENGTH]  DEFAULT ((-1)) FOR [LENGTH]
ALTER TABLE [dbo].[UDCOSTCODEGROUP] ADD  CONSTRAINT [DF_UDCOSTCODEGROUP_DESCR]  DEFAULT ('') FOR [DESCR]
ALTER TABLE [dbo].[UDCOSTCODEGROUP] ADD  CONSTRAINT [DF_UDCOSTCODEGROUP_TABLENAME]  DEFAULT ('') FOR [TABLENAME]
ALTER TABLE [dbo].[UDCOSTCODEGROUP] ADD  CONSTRAINT [DF_UDCOSTCODEGROUP_COLKEY]  DEFAULT ('') FOR [COLKEY]
ALTER TABLE [dbo].[UDCOSTCODEGROUP] ADD  CONSTRAINT [DF_UDCOSTCODEGROUP_COLUMNNAME]  DEFAULT ('') FOR [COLUMNNAME]
ALTER TABLE [dbo].[UDCOSTCODEGROUP] ADD  CONSTRAINT [DF_UDCOSTCODEGROUP_STARTPOS]  DEFAULT ((-1)) FOR [STARTPOS]
ALTER TABLE [dbo].[UDCOSTCODEGROUP] ADD  CONSTRAINT [DF_UDCOSTCODEGROUP_ISDEF]  DEFAULT (N'0') FOR [ISDEF]