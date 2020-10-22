/****** Object:  Table [dbo].[ORDHISTORY]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ORDHISTORY](
	[ORDHISTID] [int] IDENTITY(1,1) NOT NULL,
	[HISTDATE] [datetime] NOT NULL,
	[HISTUSERID] [int] NOT NULL,
	[ORDID] [char](10) NOT NULL,
	[BORGID] [int] NOT NULL,
	[ORDNUMBER] [nvarchar](55) NOT NULL,
	[ORDSTATUSID] [int] NOT NULL,
	[ORDSTATUSDATE] [datetime] NOT NULL,
	[USERID] [int] NOT NULL,
	[CREATEDATE] [datetime] NOT NULL,
	[SHORTDESCR] [nvarchar](125) NOT NULL,
	[MIMETYPE] [nvarchar](100) NOT NULL,
	[FILESIZEINKB] [int] NOT NULL,
	[FILEPATH] [nvarchar](255) NOT NULL,
	[ORIGINALFILEPATH] [nvarchar](255) NOT NULL,
	[EID] [char](10) NOT NULL,
	[ATTMESSAGE] [ntext] NOT NULL,
	[SENDATTTOSUPP] [bit] NOT NULL,
	[INVTOID] [int] NOT NULL,
	[LASTCHANGE] [datetime] NULL,
	[LASTCHANGEBY] [int] NULL,
	[REQID] [int] NOT NULL,
	[SUPPID] [int] NOT NULL,
	[CURRENCY] [nvarchar](3) NOT NULL,
	[CHANGENOTE] [ntext] NULL,
	[ISEXTPO] [bit] NOT NULL,
	[RECTYPE] [nvarchar](3) NOT NULL,
	[HOMECURRENCY] [nvarchar](3) NOT NULL,
	[EXCHRATE] [decimal](23, 6) NOT NULL,
	[WHTID] [int] NULL,
	[TERM] [int] NULL,
	[ISBULKORDER] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[ORDHISTORY] ADD  CONSTRAINT [DF_ORDHISTORY_ISEXTPO]  DEFAULT ((0)) FOR [ISEXTPO]
ALTER TABLE [dbo].[ORDHISTORY] ADD  CONSTRAINT [DF_ORDHISTORY_RECTYPE]  DEFAULT ('STD') FOR [RECTYPE]
ALTER TABLE [dbo].[ORDHISTORY] ADD  CONSTRAINT [DF_ORDHISTORY_HOMECURRENCY]  DEFAULT ('') FOR [HOMECURRENCY]
ALTER TABLE [dbo].[ORDHISTORY] ADD  CONSTRAINT [DF_ORDHISTORY_EXCHRATE]  DEFAULT ((1)) FOR [EXCHRATE]