/****** Object:  Table [dbo].[EMPJOBRATE]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EMPJOBRATE](
	[JOBCODE] [nvarchar](3) NOT NULL,
	[JOBNAME] [nvarchar](250) NOT NULL,
	[ISACTIVE] [bit] NOT NULL,
 CONSTRAINT [PK_EMPJOBRATE] PRIMARY KEY CLUSTERED 
(
	[JOBCODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[EMPJOBRATE] ADD  CONSTRAINT [DF_EMPJOBRATE_ISACTIVE]  DEFAULT ((1)) FOR [ISACTIVE]