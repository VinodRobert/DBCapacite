/****** Object:  Table [dbo].[ACCBOQDETAIL_180817]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ACCBOQDETAIL_180817](
	[DetailId] [int] IDENTITY(700,1) NOT NULL,
	[HeaderId] [int] NOT NULL,
	[Use] [bit] NOT NULL,
	[dbid] [int] NULL,
	[counter] [int] NOT NULL,
	[isc] [text] NULL,
	[section] [text] NULL,
	[bill] [text] NULL,
	[page no] [int] NULL,
	[item no] [int] NULL,
	[doc ref] [text] NULL,
	[pay ref] [text] NULL,
	[description] [text] NULL,
	[unit] [text] NULL,
	[quantity] [decimal](22, 8) NOT NULL,
	[prog QTY] [decimal](22, 8) NOT NULL,
	[prev QTY] [decimal](22, 8) NOT NULL,
	[final QTY] [decimal](22, 8) NOT NULL,
	[rate] [numeric](18, 4) NOT NULL,
	[amount] [numeric](18, 4) NOT NULL,
	[ACTID] [char](10) NOT NULL,
	[FILETYPE] [varchar](20) NOT NULL,
	[STATUS] [char](1) NOT NULL,
	[DUEQTY] [decimal](22, 8) NOT NULL,
	[INVQTY] [decimal](22, 8) NOT NULL,
	[Remarks] [nvarchar](255) NULL,
	[ReconHistID] [int] NOT NULL,
	[IsSysEntry] [bit] NOT NULL,
	[INVAMOUNT] [money] NOT NULL,
	[INVRATE] [decimal](22, 8) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]