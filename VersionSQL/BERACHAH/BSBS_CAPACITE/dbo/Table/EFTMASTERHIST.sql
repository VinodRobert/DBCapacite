/****** Object:  Table [dbo].[EFTMASTERHIST]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EFTMASTERHIST](
	[eftCustomerID] [char](5) NOT NULL,
	[eftBatchNo] [int] NOT NULL,
	[eftDateSent] [datetime] NULL,
	[eftTimeSent] [timestamp] NULL,
	[eftActionDate] [datetime] NULL,
	[eftID] [int] IDENTITY(1,1) NOT NULL,
	[eftService] [char](4) NOT NULL,
	[eftBank] [int] NOT NULL,
	[eftReference] [char](30) NOT NULL,
	[eftMethod] [int] NOT NULL,
	[eftOrgID] [int] NOT NULL,
	[eftBankAcc] [nvarchar](50) NOT NULL,
	[eftBranch] [nvarchar](10) NOT NULL,
	[SYSDATE] [datetime] NOT NULL,
	[USERID] [int] NOT NULL,
	[ACT] [nvarchar](10) NOT NULL,
	[EFTKEY] [nvarchar](32) NULL,
	[EFTENTRYCLASS] [nchar](10) NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[EFTMASTERHIST] ADD  DEFAULT ('') FOR [eftService]
ALTER TABLE [dbo].[EFTMASTERHIST] ADD  CONSTRAINT [DF_EFTMASTERHIST_EFTBANKACC]  DEFAULT ('') FOR [eftBankAcc]
ALTER TABLE [dbo].[EFTMASTERHIST] ADD  CONSTRAINT [DF_EFTMASTERHIST_EFTBRANCH]  DEFAULT ('') FOR [eftBranch]