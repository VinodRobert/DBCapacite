/****** Object:  Table [dbo].[CONTRA_180817]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CONTRA_180817](
	[ContraID] [int] IDENTITY(1,1) NOT NULL,
	[ContraAlloc] [nvarchar](10) NOT NULL,
	[ContraAct] [nvarchar](10) NOT NULL,
	[ContraDesc] [nvarchar](250) NOT NULL,
	[ContraUnit] [nvarchar](10) NOT NULL,
	[ContraRate] [numeric](18, 4) NOT NULL,
	[ContraQty] [numeric](18, 4) NOT NULL,
	[ContraTot] [numeric](18, 4) NOT NULL,
	[ContraThisMonth] [numeric](18, 4) NOT NULL,
	[ContraPrevious] [numeric](18, 4) NOT NULL,
	[ContraReconID] [int] NOT NULL,
	[ContraBorgID] [int] NOT NULL,
	[ContraVATType] [nvarchar](100) NOT NULL,
	[ContraVATAmnt] [money] NOT NULL,
	[ContraStatus] [bit] NOT NULL,
	[ContraRecur] [bit] NOT NULL,
	[CANDYID] [int] NOT NULL,
	[ReconHistID] [int] NOT NULL,
	[INVQTY] [decimal](22, 8) NOT NULL,
	[Remarks] [nvarchar](255) NULL,
	[IsSysEntry] [bit] NOT NULL,
	[INVAMOUNT] [money] NOT NULL,
	[INVRATE] [decimal](22, 8) NOT NULL
) ON [PRIMARY]