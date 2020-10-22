/****** Object:  Table [dbo].[DEBTRECONDETAIL190920]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DEBTRECONDETAIL190920](
	[RECONID] [int] NOT NULL,
	[VARCODE] [nvarchar](20) NOT NULL,
	[PVALUE] [decimal](18, 4) NOT NULL,
	[MVALUE] [decimal](18, 4) NOT NULL,
	[VVALUE] [decimal](18, 4) NOT NULL,
	[TAXVALUE] [decimal](18, 4) NOT NULL,
	[PERC] [decimal](18, 4) NOT NULL,
	[TAXCODE] [nvarchar](100) NOT NULL,
	[WHTID] [int] NOT NULL,
	[LCALLOCATION] [nvarchar](10) NOT NULL,
	[SUBALLOCATION] [nvarchar](10) NOT NULL,
	[OVERRIDE] [int] NOT NULL,
	[WHTTHISP] [decimal](18, 4) NOT NULL,
	[ReconHistID] [int] NOT NULL
) ON [PRIMARY]