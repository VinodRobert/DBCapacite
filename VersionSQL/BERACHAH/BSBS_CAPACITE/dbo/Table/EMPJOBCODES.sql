/****** Object:  Table [dbo].[EMPJOBCODES]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EMPJOBCODES](
	[JOBNUMBER] [nvarchar](10) NOT NULL,
	[JOBNAME] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_EMPJOBCODES] PRIMARY KEY CLUSTERED 
(
	[JOBNUMBER] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]