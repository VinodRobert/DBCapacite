/****** Object:  Table [BI].[LEDGERDUMP2019]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BI].[LEDGERDUMP2019](
	[YEAR] [char](10) NOT NULL,
	[PERIOD] [int] NOT NULL,
	[ORGID] [int] NOT NULL,
	[PDATE] [datetime] NULL,
	[BATCHREF] [char](10) NOT NULL,
	[TRANSREF] [char](10) NOT NULL,
	[TRANSTYPE] [char](10) NOT NULL,
	[LEDGERCODE] [char](10) NOT NULL,
	[CONTRACT] [nvarchar](10) NOT NULL,
	[ACTIVITY] [char](10) NOT NULL,
	[DESCRIPTION] [char](255) NOT NULL,
	[CURRENCY] [nvarchar](3) NOT NULL,
	[DEBIT] [money] NULL,
	[CREDIT] [money] NULL,
	[CREDNO] [char](10) NOT NULL,
	[STORE] [char](20) NOT NULL,
	[PLANTNO] [char](10) NOT NULL,
	[STOCKNO] [char](20) NOT NULL,
	[QUANTITY] [numeric](23, 4) NOT NULL,
	[UNIT] [char](10) NOT NULL,
	[RATE] [money] NOT NULL,
	[ORDERNO] [char](55) NOT NULL,
	[HOMECURRAMOUNT] [money] NULL,
	[CONVERSIONRATE] [money] NOT NULL,
	[TRANGRP] [int] NULL,
	[TRANSID] [int] IDENTITY(1,1) NOT NULL,
	[GRN] [char](55) NOT NULL
) ON [PRIMARY]