/****** Object:  Table [dbo].[VINODSICSSRDUMP]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[VINODSICSSRDUMP](
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
	[CREDNO] [char](10) NOT NULL,
	[TRANGRP] [int] NULL,
	[TRANSID] [int] IDENTITY(1,1) NOT NULL,
	[DEBIT] [money] NOT NULL,
	[CREDIT] [money] NOT NULL
) ON [PRIMARY]