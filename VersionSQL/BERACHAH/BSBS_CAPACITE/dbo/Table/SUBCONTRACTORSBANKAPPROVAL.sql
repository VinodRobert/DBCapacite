/****** Object:  Table [dbo].[SUBCONTRACTORSBANKAPPROVAL]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[SUBCONTRACTORSBANKAPPROVAL](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SOURCEID] [int] NOT NULL,
	[CredBankOrgID] [int] NOT NULL,
	[CredNumber] [nvarchar](10) NOT NULL,
	[CredBank] [int] NOT NULL,
	[CredBranch] [nvarchar](10) NOT NULL,
	[CredAccNumber] [nvarchar](50) NOT NULL,
	[CredAccType] [nvarchar](1) NOT NULL,
	[CredAccName] [nvarchar](30) NOT NULL,
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
 CONSTRAINT [PK_SUBCONTRACTORSBANKAPPROVAL] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[SUBCONTRACTORSBANKAPPROVAL] ADD  CONSTRAINT [DF_SUBCONTRACTORSBANKAPPROVAL_SOURCEID]  DEFAULT ((-1)) FOR [SOURCEID]
ALTER TABLE [dbo].[SUBCONTRACTORSBANKAPPROVAL] ADD  CONSTRAINT [DF_SUBCONTRACTORSBANKAPPROVAL_CredBankOrgID]  DEFAULT ((-1)) FOR [CredBankOrgID]
ALTER TABLE [dbo].[SUBCONTRACTORSBANKAPPROVAL] ADD  CONSTRAINT [DF_SUBCONTRACTORSBANKAPPROVAL_CredNumber]  DEFAULT ('') FOR [CredNumber]
ALTER TABLE [dbo].[SUBCONTRACTORSBANKAPPROVAL] ADD  CONSTRAINT [DF_SUBCONTRACTORSBANKAPPROVAL_CredBank]  DEFAULT ((-1)) FOR [CredBank]
ALTER TABLE [dbo].[SUBCONTRACTORSBANKAPPROVAL] ADD  CONSTRAINT [DF_SUBCONTRACTORSBANKAPPROVAL_CredBranch]  DEFAULT ('') FOR [CredBranch]
ALTER TABLE [dbo].[SUBCONTRACTORSBANKAPPROVAL] ADD  CONSTRAINT [DF_SUBCONTRACTORSBANKAPPROVAL_CredAccNumber]  DEFAULT ('') FOR [CredAccNumber]
ALTER TABLE [dbo].[SUBCONTRACTORSBANKAPPROVAL] ADD  CONSTRAINT [DF_SUBCONTRACTORSBANKAPPROVAL_CredAccType]  DEFAULT ('') FOR [CredAccType]
ALTER TABLE [dbo].[SUBCONTRACTORSBANKAPPROVAL] ADD  CONSTRAINT [DF_SUBCONTRACTORSBANKAPPROVAL_CredAccName]  DEFAULT ('') FOR [CredAccName]
ALTER TABLE [dbo].[SUBCONTRACTORSBANKAPPROVAL] ADD  CONSTRAINT [DF_SUBCONTRACTORSBANKAPPROVAL_CredRef]  DEFAULT ('') FOR [CredRef]
ALTER TABLE [dbo].[SUBCONTRACTORSBANKAPPROVAL] ADD  CONSTRAINT [DF_SUBCONTRACTORSBANKAPPROVAL_STANDARDBANK_PROFILE]  DEFAULT ('') FOR [STANDARDBANK_PROFILE]
ALTER TABLE [dbo].[SUBCONTRACTORSBANKAPPROVAL] ADD  CONSTRAINT [DF_SUBCONTRACTORSBANKAPPROVAL_SWIFT]  DEFAULT ('') FOR [SWIFT]
ALTER TABLE [dbo].[SUBCONTRACTORSBANKAPPROVAL] ADD  CONSTRAINT [DF_SUBCONTRACTORSBANKAPPROVAL_IFSC]  DEFAULT ('') FOR [IFSC]
ALTER TABLE [dbo].[SUBCONTRACTORSBANKAPPROVAL] ADD  CONSTRAINT [DF_SUBCONTRACTORSBANKAPPROVAL_COUNTRY]  DEFAULT ('') FOR [COUNTRY]
ALTER TABLE [dbo].[SUBCONTRACTORSBANKAPPROVAL] ADD  CONSTRAINT [DF_SUBCONTRACTORSBANKAPPROVAL_REQUESTUSERID]  DEFAULT ((-1)) FOR [REQUESTUSERID]
ALTER TABLE [dbo].[SUBCONTRACTORSBANKAPPROVAL] ADD  CONSTRAINT [DF_SUBCONTRACTORSBANKAPPROVAL_SUBMITCOMMENT]  DEFAULT ('') FOR [SUBMITCOMMENT]
ALTER TABLE [dbo].[SUBCONTRACTORSBANKAPPROVAL] ADD  CONSTRAINT [DF_SUBCONTRACTORSBANKAPPROVAL_APPROVERUSERID]  DEFAULT ((-1)) FOR [APPROVERUSERID]
ALTER TABLE [dbo].[SUBCONTRACTORSBANKAPPROVAL] ADD  CONSTRAINT [DF_SUBCONTRACTORSBANKAPPROVAL_STATUS]  DEFAULT ((0)) FOR [STATUS]
ALTER TABLE [dbo].[SUBCONTRACTORSBANKAPPROVAL] ADD  CONSTRAINT [DF_SUBCONTRACTORSBANKAPPROVAL_APPROVECOMMENT]  DEFAULT ('') FOR [APPROVECOMMENT]
ALTER TABLE [dbo].[SUBCONTRACTORSBANKAPPROVAL] ADD  CONSTRAINT [DF_SUBCONTRACTORSBANKAPPROVAL_SUSPEND]  DEFAULT (N'0') FOR [SUSPEND]
ALTER TABLE [dbo].[SUBCONTRACTORSBANKAPPROVAL] ADD  CONSTRAINT [DF_SUBCONTRACTORSBANKAPPROVAL_COMPLETE]  DEFAULT (N'0') FOR [COMPLETE]