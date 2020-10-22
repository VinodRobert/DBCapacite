/****** Object:  Table [dbo].[TENDER150619_1]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TENDER150619_1](
	[ITEMID] [int] IDENTITY(1,1) NOT NULL,
	[RESCODE] [nvarchar](20) NOT NULL,
	[DESCR] [ntext] NOT NULL,
	[RATE] [money] NOT NULL,
	[UNIT] [nvarchar](15) NOT NULL,
	[QTY] [decimal](18, 4) NOT NULL,
	[BORG] [int] NOT NULL,
	[PROJECT] [int] NOT NULL,
	[CONTRACT] [int] NOT NULL,
	[ORDEREDQTY] [decimal](18, 4) NOT NULL,
	[EID] [char](10) NOT NULL,
	[LEDGERCODE] [nvarchar](10) NOT NULL,
	[CURRENCY] [nvarchar](3) NOT NULL,
	[SUPPCODE] [nvarchar](10) NOT NULL,
	[CATEGORY] [nvarchar](55) NOT NULL,
	[PERIODQTY] [decimal](18, 4) NOT NULL,
	[ORDEREDAMOUNT] [decimal](18, 4) NOT NULL,
	[FINALWASTE] [decimal](18, 4) NOT NULL,
	[REMARK] [nvarchar](255) NOT NULL,
	[PERIODWASTE] [decimal](18, 4) NOT NULL,
	[COSTRATE] [decimal](18, 4) NOT NULL,
	[COSTQTY] [decimal](18, 4) NOT NULL,
	[BILLQTY] [decimal](18, 4) NOT NULL,
	[COSTWASTE] [decimal](18, 4) NOT NULL,
	[EXCHRATE] [decimal](23, 6) NOT NULL,
	[ACTNUMBER] [nvarchar](10) NOT NULL,
	[ISACTDETAIL] [bit] NOT NULL,
	[ACTUALUSAGE] [decimal](18, 4) NOT NULL,
	[ACTUALWASTE] [decimal](18, 4) NOT NULL,
	[SYSDATE] [datetime] NOT NULL,
	[ORDEREDDISCOUNT] [decimal](18, 4) NOT NULL,
	[TEMP6] [nvarchar](10) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]