/****** Object:  Table [dbo].[EventLog]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EventLog](
	[EventId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[EventDesc] [nvarchar](25) NOT NULL,
	[EventBorgID] [int] NULL,
	[EventPayRollID] [int] NULL,
	[EventDate] [datetime] NOT NULL,
 CONSTRAINT [PK_EventLog] PRIMARY KEY CLUSTERED 
(
	[EventDesc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[EventLog] ADD  CONSTRAINT [DF_EventLog_EventDate]  DEFAULT (getdate()) FOR [EventDate]