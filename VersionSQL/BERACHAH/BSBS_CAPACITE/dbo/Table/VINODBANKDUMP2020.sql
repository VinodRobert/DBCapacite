/****** Object:  Table [dbo].[VINODBANKDUMP2020]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[VINODBANKDUMP2020](
	[TRANGRP] [int] NULL,
	[TRANSID] [int] NULL,
	[ORGID] [int] NULL,
	[ORGNAME] [varchar](100) NULL,
	[FINYEAR] [int] NULL,
	[PERIOD] [int] NULL,
	[PERIODNAME] [varchar](25) NULL,
	[PDATE] [datetime] NULL,
	[BATCHREF] [varchar](15) NULL,
	[TRANSREF] [varchar](25) NULL,
	[TRANSTYPE] [varchar](20) NULL,
	[PARTYCODE] [varchar](15) NULL,
	[PARTYNAME] [varchar](150) NULL,
	[LEDGERCODE] [varchar](10) NULL,
	[LEDGERNAME] [varchar](200) NULL,
	[DESCRIPTION] [varchar](255) NULL,
	[DEBIT] [decimal](18, 2) NULL,
	[CREDIT] [decimal](18, 2) NULL
) ON [PRIMARY]