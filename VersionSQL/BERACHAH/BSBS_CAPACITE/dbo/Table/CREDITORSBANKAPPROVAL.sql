/****** Object:  Table [dbo].[CREDITORSBANKAPPROVAL]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CREDITORSBANKAPPROVAL](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SOURCEID] [int] NOT NULL,
	[CredBankOrgID] [int] NOT NULL,
	[CredNumber] [nvarchar](10) NOT NULL,
	[CredBank] [int] NOT NULL,
	[CredBranch] [nvarchar](10) NOT NULL,
	[CredAccName] [nvarchar](30) NOT NULL,
	[CredAccNumber] [nvarchar](50) NOT NULL,
	[CredAccType] [nvarchar](1) NOT NULL,
	[CredRef] [nvarchar](30) NOT NULL,
	[STANDARDBANK_PROFILE] [nvarchar](16) NOT NULL,
	[SWIFT] [nvarchar](12) NOT NULL,
	[IFSC] [nvarchar](30) NOT NULL,
	[COUNTRY] [nvarchar](55) NOT NULL,
	[REQUESTUSERID] [int] NOT NULL,
	[SUBMITDATE] [datetime] NULL,
	[SUBMITCOMMENT] [nvarchar](250) NOT NULL,
	[APPROVERUSERID] [int] NULL,
	[APPROVEDATE] [datetime] NULL,
	[STATUS] [int] NOT NULL,
	[STATUSDATE] [datetime] NULL,
	[APPROVECOMMENT] [nvarchar](250) NOT NULL,
	[SUSPEND] [bit] NOT NULL,
	[COMPLETE] [bit] NOT NULL,
 CONSTRAINT [PK_CREDITORSBANKAPPROVAL] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CREDITORSBANKAPPROVAL] ADD  CONSTRAINT [DF_CREDITORSBANKAPPROVAL_SOURCEID]  DEFAULT ((-1)) FOR [SOURCEID]
ALTER TABLE [dbo].[CREDITORSBANKAPPROVAL] ADD  CONSTRAINT [DF_CREDITORSBANKAPPROVAL_CredBankOrgID]  DEFAULT ((-1)) FOR [CredBankOrgID]
ALTER TABLE [dbo].[CREDITORSBANKAPPROVAL] ADD  CONSTRAINT [DF_CREDITORSBANKAPPROVAL_CredNumber]  DEFAULT ('') FOR [CredNumber]
ALTER TABLE [dbo].[CREDITORSBANKAPPROVAL] ADD  CONSTRAINT [DF_CREDITORSBANKAPPROVAL_CredBank]  DEFAULT ((-1)) FOR [CredBank]
ALTER TABLE [dbo].[CREDITORSBANKAPPROVAL] ADD  CONSTRAINT [DF_CREDITORSBANKAPPROVAL_CredBranch]  DEFAULT ('') FOR [CredBranch]
ALTER TABLE [dbo].[CREDITORSBANKAPPROVAL] ADD  CONSTRAINT [DF_CREDITORSBANKAPPROVAL_CredAccName]  DEFAULT ('') FOR [CredAccName]
ALTER TABLE [dbo].[CREDITORSBANKAPPROVAL] ADD  CONSTRAINT [DF_CREDITORSBANKAPPROVAL_CredAccNumber]  DEFAULT ('') FOR [CredAccNumber]
ALTER TABLE [dbo].[CREDITORSBANKAPPROVAL] ADD  CONSTRAINT [DF_CREDITORSBANKAPPROVAL_CredAccType]  DEFAULT ('1') FOR [CredAccType]
ALTER TABLE [dbo].[CREDITORSBANKAPPROVAL] ADD  CONSTRAINT [DF_CREDITORSBANKAPPROVAL_CredRef]  DEFAULT ('') FOR [CredRef]
ALTER TABLE [dbo].[CREDITORSBANKAPPROVAL] ADD  CONSTRAINT [DF_CREDITORSBANKAPPROVAL_STANDARDBANK_PROFILE]  DEFAULT ('') FOR [STANDARDBANK_PROFILE]
ALTER TABLE [dbo].[CREDITORSBANKAPPROVAL] ADD  CONSTRAINT [DF_CREDITORSBANKAPPROVAL_SWIFT]  DEFAULT ('') FOR [SWIFT]
ALTER TABLE [dbo].[CREDITORSBANKAPPROVAL] ADD  CONSTRAINT [DF_CREDITORSBANKAPPROVAL_IFSC]  DEFAULT ('') FOR [IFSC]
ALTER TABLE [dbo].[CREDITORSBANKAPPROVAL] ADD  CONSTRAINT [DF_CREDITORSBANKAPPROVAL_COUNTRY]  DEFAULT ('') FOR [COUNTRY]
ALTER TABLE [dbo].[CREDITORSBANKAPPROVAL] ADD  CONSTRAINT [DF_CREDITORSBANKAPPROVAL_REQUESTUSERID]  DEFAULT ((-1)) FOR [REQUESTUSERID]
ALTER TABLE [dbo].[CREDITORSBANKAPPROVAL] ADD  CONSTRAINT [DF_CREDITORSBANKAPPROVAL_SUBMITCOMMENT]  DEFAULT ('') FOR [SUBMITCOMMENT]
ALTER TABLE [dbo].[CREDITORSBANKAPPROVAL] ADD  CONSTRAINT [DF_CREDITORSBANKAPPROVAL_APPROVERUSERID]  DEFAULT ((-1)) FOR [APPROVERUSERID]
ALTER TABLE [dbo].[CREDITORSBANKAPPROVAL] ADD  CONSTRAINT [DF_CREDITORSBANKAPPROVAL_STATUS]  DEFAULT ((0)) FOR [STATUS]
ALTER TABLE [dbo].[CREDITORSBANKAPPROVAL] ADD  CONSTRAINT [DF_CREDITORSBANKAPPROVAL_APPROVECOMMENT]  DEFAULT ('') FOR [APPROVECOMMENT]
ALTER TABLE [dbo].[CREDITORSBANKAPPROVAL] ADD  CONSTRAINT [DF_CREDITORSBANKAPPROVAL_SUSPEND]  DEFAULT (N'0') FOR [SUSPEND]
ALTER TABLE [dbo].[CREDITORSBANKAPPROVAL] ADD  CONSTRAINT [DF_CREDITORSBANKAPPROVAL_COMPLETE]  DEFAULT (N'0') FOR [COMPLETE]