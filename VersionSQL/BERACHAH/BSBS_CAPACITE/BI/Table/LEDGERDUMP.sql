/****** Object:  Table [BI].[LEDGERDUMP]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BI].[LEDGERDUMP](
	[ORGID] [int] NOT NULL,
	[BORGNAME] [varchar](100) NULL,
	[PDATE] [datetime] NULL,
	[BATCHREF] [char](10) NOT NULL,
	[TRANSREF] [char](10) NOT NULL,
	[TRANSTYPE] [char](10) NOT NULL,
	[LEDGERCODE] [char](10) NOT NULL,
	[LEDGERNAME] [varchar](250) NULL,
	[CONTRACT] [nvarchar](10) NOT NULL,
	[CONTRACTNAME] [varchar](100) NULL,
	[ACTIVITY] [char](10) NOT NULL,
	[ACTIVITIYNAME] [varchar](100) NULL,
	[DESCRIPTION] [char](255) NOT NULL,
	[CURRENCY] [nvarchar](3) NOT NULL,
	[DEBIT] [money] NOT NULL,
	[CREDIT] [money] NOT NULL,
	[CREDNO] [char](10) NOT NULL,
	[PARTY] [varchar](255) NULL,
	[STORE] [char](20) NOT NULL,
	[PLANTNO] [char](10) NOT NULL,
	[PLANTNAME] [varchar](200) NULL,
	[STOCKNO] [char](20) NOT NULL,
	[STOCKNAME] [varchar](200) NULL,
	[QUANTITY] [numeric](23, 4) NOT NULL,
	[UNIT] [char](10) NOT NULL,
	[RATE] [money] NOT NULL,
	[ORDERNO] [char](55) NOT NULL,
	[HOMECURRAMOUNT] [money] NULL,
	[CONVERSIONRATE] [money] NOT NULL,
	[TRANGRP] [int] NULL
) ON [PRIMARY]