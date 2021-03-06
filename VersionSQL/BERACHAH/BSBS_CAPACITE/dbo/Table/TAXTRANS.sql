/****** Object:  Table [dbo].[TAXTRANS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TAXTRANS](
	[TRANSID] [int] NOT NULL,
	[VATGC] [nvarchar](3) NOT NULL,
	[NAME] [nvarchar](50) NOT NULL,
	[SEQUENCE] [int] NOT NULL,
	[PERC] [numeric](18, 4) NOT NULL,
	[ISACCUM] [bit] NOT NULL,
	[ISREIMB] [bit] NOT NULL,
	[LEDGERCODE] [nvarchar](10) NOT NULL,
	[TAX] [numeric](18, 4) NOT NULL,
	[CUMCOST] [numeric](18, 4) NOT NULL,
	[CUMTAX] [numeric](18, 4) NOT NULL,
	[VATTYPE] [nvarchar](2) NOT NULL,
	[BORGID] [int] NOT NULL,
	[PROVINCEIDS] [int] NULL,
	[PROVINCEIDO] [int] NULL,
	[PROVINCEIDD] [int] NULL,
	[ISSURCHARGE] [bit] NOT NULL,
	[SURCHARGEAPPLIES] [bit] NOT NULL,
 CONSTRAINT [PK_TAXTRANS] PRIMARY KEY CLUSTERED 
(
	[TRANSID] ASC,
	[VATGC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TAXTRANS] ADD  CONSTRAINT [DF_TAXTRANS_VATGC]  DEFAULT ('') FOR [VATGC]
ALTER TABLE [dbo].[TAXTRANS] ADD  CONSTRAINT [DF_TAXTRANS_ISSURCHARGE]  DEFAULT ((0)) FOR [ISSURCHARGE]
ALTER TABLE [dbo].[TAXTRANS] ADD  CONSTRAINT [DF_TAXTRANS_SURCHARGEAPPLIES]  DEFAULT ((0)) FOR [SURCHARGEAPPLIES]