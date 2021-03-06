/****** Object:  Table [dbo].[ROLEHEADERE]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ROLEHEADERE](
	[ROLEID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ROLENAME] [nvarchar](50) NULL,
	[EID] [char](10) NOT NULL,
 CONSTRAINT [PK_ROLEHEADERE] PRIMARY KEY CLUSTERED 
(
	[ROLEID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ROLEHEADERE] ADD  CONSTRAINT [DF_ROLEHEADERE_ROLENAME]  DEFAULT (N'( '')') FOR [ROLENAME]
ALTER TABLE [dbo].[ROLEHEADERE] ADD  CONSTRAINT [DF_ROLEHEADERE_EID]  DEFAULT ('') FOR [EID]