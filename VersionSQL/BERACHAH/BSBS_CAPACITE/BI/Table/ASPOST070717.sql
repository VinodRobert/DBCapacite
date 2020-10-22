/****** Object:  Table [BI].[ASPOST070717]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BI].[ASPOST070717](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[YEAR] [int] NULL,
	[PERIOD] [int] NULL,
	[ASSETID] [int] NULL,
	[ASSETNUMBER] [varchar](15) NULL,
	[LEDGERCODE] [varchar](10) NULL,
	[DEBIT] [decimal](18, 2) NULL,
	[CURRNETCOUNT] [int] NULL,
	[BOOKINGDATE] [datetime] NULL,
	[DEPTYPE] [nchar](10) NULL
) ON [PRIMARY]