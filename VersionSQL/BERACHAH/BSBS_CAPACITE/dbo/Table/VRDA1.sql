/****** Object:  Table [dbo].[VRDA1]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[VRDA1](
	[ORGID] [int] NULL,
	[YEAR] [int] NULL,
	[PERIOD] [int] NULL,
	[PDATE] [datetime] NULL,
	[BATCHREF] [varchar](10) NULL,
	[TRANSREF] [varchar](10) NULL,
	[TRANSTYPE] [varchar](3) NULL,
	[DESCRIPTION] [varchar](50) NULL,
	[CURRENCY] [varchar](3) NULL,
	[DEBIT] [decimal](18, 2) NULL,
	[CREDIT] [decimal](18, 2) NULL,
	[CREDNO] [varchar](10) NULL,
	[TRANGRP] [int] NULL,
	[HOMECURRAMOUNT] [decimal](18, 2) NULL,
	[RECEIVEDDATE] [datetime] NULL,
	[NETAMOUNT] [decimal](18, 2) NULL,
	[AGEINDAYS] [int] NULL,
	[ORGNAME] [varchar](75) NULL,
	[SUPPLIERNAME] [varchar](55) NULL
) ON [PRIMARY]