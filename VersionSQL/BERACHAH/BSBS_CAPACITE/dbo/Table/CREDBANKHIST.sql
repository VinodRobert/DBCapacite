/****** Object:  Table [dbo].[CREDBANKHIST]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CREDBANKHIST](
	[CredBankOrgID] [int] NOT NULL,
	[CredNumber] [char](10) NOT NULL,
	[CredBank] [int] NOT NULL,
	[CredBranch] [nvarchar](10) NOT NULL,
	[CredAccName] [char](30) NULL,
	[CredAccNumber] [nvarchar](50) NOT NULL,
	[CredAccType] [nchar](1) NOT NULL,
	[CredBankID] [int] IDENTITY(1,1) NOT NULL,
	[CredRef] [char](30) NOT NULL,
	[STANDARDBANK_PROFILE] [nvarchar](16) NOT NULL,
	[SWIFT] [nvarchar](12) NOT NULL,
	[IFSC] [nvarchar](11) NOT NULL,
	[SYSDATE] [datetime] NOT NULL,
	[USERID] [int] NOT NULL,
	[ACT] [nvarchar](10) NOT NULL,
	[SYSDATEPREV] [datetime] NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[CREDBANKHIST] ADD  CONSTRAINT [DF_CREDBANKHIST_CredBank]  DEFAULT ((-1)) FOR [CredBank]
ALTER TABLE [dbo].[CREDBANKHIST] ADD  CONSTRAINT [DF_CREDBANKHIST_CREDACCNUMBER]  DEFAULT ('') FOR [CredAccNumber]
ALTER TABLE [dbo].[CREDBANKHIST] ADD  CONSTRAINT [DF_CREDBANKHIST_SWIFT]  DEFAULT ('') FOR [SWIFT]
ALTER TABLE [dbo].[CREDBANKHIST] ADD  CONSTRAINT [DF_CREDBANKHIST_IFSC]  DEFAULT ('') FOR [IFSC]