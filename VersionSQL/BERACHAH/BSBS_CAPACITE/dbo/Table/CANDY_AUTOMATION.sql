/****** Object:  Table [dbo].[CANDY_AUTOMATION]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CANDY_AUTOMATION](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[TYPE] [nvarchar](50) NOT NULL,
	[STATUS] [int] NOT NULL,
	[TIMEINTERVAL] [int] NOT NULL,
	[LASTPROCESSEDSTATUS] [int] NOT NULL,
	[LASTPROCESSEDDATE] [datetime] NOT NULL,
	[UPLOADSAVAILABLE] [int] NOT NULL,
	[EID] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_CANDY_AUTOMATION] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]