/****** Object:  Table [dbo].[JOURNALS20JULY2020]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[JOURNALS20JULY2020](
	[JnlLedgerCode] [char](10) NOT NULL,
	[JnlDescription] [char](255) NOT NULL,
	[JnlContract] [char](10) NOT NULL,
	[JnlActivity] [char](10) NOT NULL,
	[JnlDivision] [char](10) NOT NULL,
	[JnlDebit] [money] NOT NULL,
	[JnlCredit] [money] NOT NULL,
	[JnlID] [int] IDENTITY(1,1) NOT NULL,
	[JnlOrg] [int] NOT NULL,
	[JnlAge] [int] NOT NULL,
	[JnlSubConTran] [char](25) NOT NULL,
	[JnlVatDebit] [money] NOT NULL,
	[JnlVatCredit] [money] NOT NULL,
	[JnlHomeCurrency] [money] NOT NULL,
	[JnlPlant] [char](10) NOT NULL,
	[JnlCredno] [char](10) NOT NULL,
	[JnlHeadID] [int] NOT NULL,
	[JnlAlloc] [char](25) NOT NULL,
	[JnlVATType] [nvarchar](100) NOT NULL,
	[JnlExchRate] [float] NOT NULL,
	[JnlContExchRate] [float] NOT NULL,
	[JNLTOORG] [int] NOT NULL,
	[JNLICGLCODE] [char](10) NOT NULL,
	[JnlPlantHeadID] [int] NULL,
	[JNLTRANSREF] [char](10) NOT NULL,
	[WHTID] [int] NULL,
	[PDATE] [datetime] NULL,
	[ASSETNUMBER] [nvarchar](15) NOT NULL,
	[ASSETTYPE] [varchar](3) NOT NULL,
	[RECEIVEDDATE] [datetime] NULL,
	[ORDERNO] [nvarchar](55) NOT NULL,
	[CLASSID] [int] NOT NULL
) ON [PRIMARY]