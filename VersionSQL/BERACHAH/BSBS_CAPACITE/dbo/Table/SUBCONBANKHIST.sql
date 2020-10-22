/****** Object:  Table [dbo].[SUBCONBANKHIST]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[SUBCONBANKHIST](
	[CredBankOrgID] [int] NOT NULL,
	[CredNumber] [char](10) NOT NULL,
	[CredBank] [int] NOT NULL,
	[CredBranch] [nvarchar](10) NOT NULL,
	[CredAccNumber] [nvarchar](50) NOT NULL,
	[CredAccType] [nchar](1) NOT NULL,
	[CredBankID] [int] IDENTITY(1,1) NOT NULL,
	[CredAccName] [char](30) NOT NULL,
	[CredRef] [char](30) NOT NULL,
	[STANDARDBANK_PROFILE] [nvarchar](16) NOT NULL,
	[SWIFT] [nvarchar](12) NOT NULL,
	[IFSC] [nvarchar](11) NOT NULL,
	[SYSDATE] [datetime] NOT NULL,
	[USERID] [int] NOT NULL,
	[ACT] [nvarchar](10) NOT NULL,
	[SYSDATEPREV] [datetime] NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[SUBCONBANKHIST] ADD  CONSTRAINT [DF_SUBCONBANKHIST_CredBank]  DEFAULT ((-1)) FOR [CredBank]
ALTER TABLE [dbo].[SUBCONBANKHIST] ADD  CONSTRAINT [DF_SUBCONBANKHIST_CREDACCNUMBER]  DEFAULT ('') FOR [CredAccNumber]
ALTER TABLE [dbo].[SUBCONBANKHIST] ADD  CONSTRAINT [DF_SUBCONBANKHIST_SWIFT]  DEFAULT ('') FOR [SWIFT]
ALTER TABLE [dbo].[SUBCONBANKHIST] ADD  CONSTRAINT [DF_SUBCONBANKHIST_IFSC]  DEFAULT ('') FOR [IFSC]