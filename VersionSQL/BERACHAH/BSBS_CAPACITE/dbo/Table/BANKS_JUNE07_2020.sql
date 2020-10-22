/****** Object:  Table [dbo].[BANKS_JUNE07_2020]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[BANKS_JUNE07_2020](
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
	[CHID] [int] NOT NULL,
	[BIC] [nvarchar](12) NULL,
	[COUNTRY] [nvarchar](55) NULL,
	[ISPDCBANK] [bit] NULL,
	[PDCCONTROL] [nvarchar](10) NULL
) ON [PRIMARY]