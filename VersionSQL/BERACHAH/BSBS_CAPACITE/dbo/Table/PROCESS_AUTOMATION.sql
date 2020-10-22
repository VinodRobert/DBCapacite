/****** Object:  Table [dbo].[PROCESS_AUTOMATION]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PROCESS_AUTOMATION](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TYPE] [nvarchar](50) NOT NULL,
	[STATUS] [int] NOT NULL,
	[TIMEINTERVAL] [int] NOT NULL,
	[LASTPROCESSEDSTATUS] [int] NOT NULL,
	[LASTPROCESSEDDATE] [datetime] NOT NULL,
	[EID] [nvarchar](50) NOT NULL,
	[ORGID] [int] NOT NULL,
 CONSTRAINT [PK_PROCESS_AUTOMATION] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PROCESS_AUTOMATION] ADD  CONSTRAINT [DF_PROCESS_AUTOMATION_ORGID]  DEFAULT ((-1)) FOR [ORGID]