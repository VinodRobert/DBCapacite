/****** Object:  Table [dbo].[USERMENUPOS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[USERMENUPOS](
	[SEQ] [nvarchar](6) NOT NULL,
	[DESCR] [nvarchar](20) NOT NULL,
	[LINK] [nvarchar](50) NOT NULL,
	[NEWWIN] [bit] NOT NULL,
	[UMLEVEL] [smallint] NOT NULL,
	[ISPARENT] [bit] NOT NULL,
	[CLASSNAME] [nvarchar](10) NOT NULL,
	[MYVALUES] [nvarchar](5) NOT NULL,
	[EID] [char](10) NOT NULL,
 CONSTRAINT [PK_USERMENUPOS] PRIMARY KEY CLUSTERED 
(
	[SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[USERMENUPOS] ADD  CONSTRAINT [DF_USERMENUPOS_DESCR]  DEFAULT ('') FOR [DESCR]
ALTER TABLE [dbo].[USERMENUPOS] ADD  CONSTRAINT [DF_USERMENUPOS_LINK]  DEFAULT ('') FOR [LINK]
ALTER TABLE [dbo].[USERMENUPOS] ADD  CONSTRAINT [DF_USERMENUPOS_NEWWIN]  DEFAULT (0) FOR [NEWWIN]
ALTER TABLE [dbo].[USERMENUPOS] ADD  CONSTRAINT [DF_USERMENUPOS_UMLEVEL]  DEFAULT (2) FOR [UMLEVEL]
ALTER TABLE [dbo].[USERMENUPOS] ADD  CONSTRAINT [DF_USERMENUPOS_PARENT]  DEFAULT (0) FOR [ISPARENT]
ALTER TABLE [dbo].[USERMENUPOS] ADD  CONSTRAINT [DF_USERMENUPOS_CLASSNAME]  DEFAULT ('BLUELINK') FOR [CLASSNAME]
ALTER TABLE [dbo].[USERMENUPOS] ADD  CONSTRAINT [DF_USERMENUPOS_MYVALUES]  DEFAULT (0) FOR [MYVALUES]
ALTER TABLE [dbo].[USERMENUPOS] ADD  DEFAULT ('') FOR [EID]