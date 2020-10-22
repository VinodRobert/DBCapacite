/****** Object:  Table [dbo].[TEMPDUMP2019]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TEMPDUMP2019](
	[ORGID] [int] NOT NULL,
	[YEAR] [char](10) NOT NULL,
	[PERIOD] [int] NOT NULL,
	[PDATE] [datetime] NULL,
	[BATCHREF] [char](10) NOT NULL,
	[TRANSREF] [char](10) NOT NULL,
	[TRANSTYPE] [char](10) NOT NULL,
	[ALLOCATION] [char](25) NOT NULL,
	[LEDGERCODE] [char](10) NOT NULL,
	[CONTRACT] [nvarchar](10) NOT NULL,
	[DESCRIPTION] [char](255) NOT NULL,
	[CURRENCY] [nvarchar](3) NOT NULL,
	[DEBIT] [money] NOT NULL,
	[CREDIT] [money] NOT NULL,
	[CREDNO] [char](10) NOT NULL,
	[STORE] [char](20) NOT NULL,
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