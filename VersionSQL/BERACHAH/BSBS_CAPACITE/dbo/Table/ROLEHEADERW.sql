/****** Object:  Table [dbo].[ROLEHEADERW]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ROLEHEADERW](
	[ROLEID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ROLENAME] [nvarchar](50) NULL,
	[EID] [char](10) NOT NULL,
	[PAYROLLID] [int] NOT NULL,
 CONSTRAINT [PK_RELEHEADERW] PRIMARY KEY CLUSTERED 
(
	[ROLEID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ROLEHEADERW] ADD  CONSTRAINT [DF_RELEHEADERW_ROLENAME]  DEFAULT (N'( '')') FOR [ROLENAME]
ALTER TABLE [dbo].[ROLEHEADERW] ADD  CONSTRAINT [DF_ROLEHEADERW_EID]  DEFAULT ('') FOR [EID]
ALTER TABLE [dbo].[ROLEHEADERW] ADD  CONSTRAINT [DF_ROLEHEADERW_PAYROLLID]  DEFAULT ((-1)) FOR [PAYROLLID]