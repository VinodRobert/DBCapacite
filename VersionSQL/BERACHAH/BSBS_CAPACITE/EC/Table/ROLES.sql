/****** Object:  Table [EC].[ROLES]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [EC].[ROLES](
	[ROLEID] [int] NOT NULL,
	[ROLENAME] [varchar](50) NULL,
	[REMARKS] [varchar](255) NULL,
 CONSTRAINT [PK_ROLES] PRIMARY KEY CLUSTERED 
(
	[ROLEID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]