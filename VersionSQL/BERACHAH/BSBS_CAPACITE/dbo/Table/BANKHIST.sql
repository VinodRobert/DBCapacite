/****** Object:  Table [dbo].[BANKHIST]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[BANKHIST](
	[BankAccount] [nvarchar](50) NOT NULL,
	[BankBranch] [nvarchar](10) NOT NULL,
	[BankName] [char](35) NULL,
	[BankAddress1] [char](35) NULL,
	[BankAddress2] [char](35) NULL,
	[BankAddress3] [char](35) NULL,
	[BankPCode] [char](10) NULL,
	[BankTel] [char](25) NULL,
	[BankFax] [char](25) NULL,
	[BankeMail] [char](35) NULL,
	[BankContact] [char](35) NULL,
	[BankManager] [char](35) NULL,
	[BankURL] [char](55) NULL,
	[BankLedger] [char](10) NOT NULL,
	[BankBalance] [money] NULL,
	[BankBalanceClose] [money] NOT NULL,
	[BankPeriod] [char](20) NULL,
	[BankID] [int] IDENTITY(1,1) NOT NULL,
	[BankBorgID] [int] NULL,
	[SWIFT] [nvarchar](12) NOT NULL,
	[IFSC] [nvarchar](11) NOT NULL,
	[SYSDATE] [datetime] NOT NULL,
	[USERID] [int] NOT NULL,
	[ACT] [nvarchar](10) NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[BANKHIST] ADD  CONSTRAINT [DF_BANKHIST_BANKACCOUNT]  DEFAULT ('') FOR [BankAccount]
ALTER TABLE [dbo].[BANKHIST] ADD  CONSTRAINT [DF_BANKHIST_SWIFT]  DEFAULT ('') FOR [SWIFT]
ALTER TABLE [dbo].[BANKHIST] ADD  CONSTRAINT [DF_BANKHIST_IFSC]  DEFAULT ('') FOR [IFSC]