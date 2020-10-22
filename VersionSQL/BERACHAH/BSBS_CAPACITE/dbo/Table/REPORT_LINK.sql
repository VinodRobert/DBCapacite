/****** Object:  Table [dbo].[REPORT_LINK]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[REPORT_LINK](
	[LinkId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[OrgId] [int] NOT NULL,
	[Report] [nvarchar](50) NULL,
	[RepOrg] [int] NOT NULL,
	[HeadPicLogo] [nvarchar](50) NULL,
	[OrgPicLLogo] [nvarchar](50) NULL,
	[OrgPicRLogo] [nvarchar](50) NULL,
	[CustLink] [nvarchar](50) NULL,
	[CustRpt] [nvarchar](50) NULL,
 CONSTRAINT [PK_REPORT_LINK] PRIMARY KEY CLUSTERED 
(
	[LinkId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[REPORT_LINK] ADD  CONSTRAINT [DF_REPORT_LINK_OrgId]  DEFAULT ('-1') FOR [OrgId]
ALTER TABLE [dbo].[REPORT_LINK] ADD  CONSTRAINT [DF_REPORT_LINK_Report]  DEFAULT ('') FOR [Report]
ALTER TABLE [dbo].[REPORT_LINK] ADD  CONSTRAINT [DF_REPORT_LINK_RepOrg]  DEFAULT ('0') FOR [RepOrg]
ALTER TABLE [dbo].[REPORT_LINK] ADD  CONSTRAINT [DF_REPORT_LINK_HeadPicLogo]  DEFAULT ('') FOR [HeadPicLogo]
ALTER TABLE [dbo].[REPORT_LINK] ADD  CONSTRAINT [DF_REPORT_LINK_OrgPicLLogo]  DEFAULT ('') FOR [OrgPicLLogo]
ALTER TABLE [dbo].[REPORT_LINK] ADD  CONSTRAINT [DF_REPORT_LINK_OrgPicRLogo]  DEFAULT ('') FOR [OrgPicRLogo]