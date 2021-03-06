/****** Object:  Table [dbo].[AUTOMATCSS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[AUTOMATCSS](
	[ACID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[NAME] [nvarchar](55) NOT NULL,
	[DETAIL] [text] NOT NULL,
 CONSTRAINT [PK_AUTOMATCSS] PRIMARY KEY CLUSTERED 
(
	[ACID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]