/****** Object:  Table [dbo].[EVENTS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EVENTS](
	[EVENTID] [int] IDENTITY(1,1) NOT NULL,
	[EVENTDATE] [datetime] NOT NULL,
	[PAYROLLID] [int] NOT NULL,
	[USERID] [int] NOT NULL,
	[EVENTTEXT] [text] NOT NULL,
	[PERSONAL] [bit] NOT NULL,
	[PGRMID] [smallint] NOT NULL,
	[EID] [char](10) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[EVENTS] ADD  DEFAULT ('') FOR [EID]