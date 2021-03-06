/****** Object:  Table [dbo].[SUBCRECONDETAIL]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[SUBCRECONDETAIL](
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
	[ReconHistID] [int] NOT NULL,
 CONSTRAINT [PK_SUBCRECONDETAIL] PRIMARY KEY CLUSTERED 
(
	[RECONID] ASC,
	[VARCODE] ASC,
	[ReconHistID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[SUBCRECONDETAIL] ADD  CONSTRAINT [DF_SUBCRECONDETAIL_RECONID]  DEFAULT ('0') FOR [RECONID]
ALTER TABLE [dbo].[SUBCRECONDETAIL] ADD  CONSTRAINT [DF_SUBCRECONDETAIL_VARCODE]  DEFAULT ('') FOR [VARCODE]
ALTER TABLE [dbo].[SUBCRECONDETAIL] ADD  CONSTRAINT [DF_SUBCRECONDETAIL_PVALUE]  DEFAULT ('0') FOR [PVALUE]
ALTER TABLE [dbo].[SUBCRECONDETAIL] ADD  CONSTRAINT [DF_SUBCRECONDETAIL_MVALUE]  DEFAULT ('0') FOR [MVALUE]
ALTER TABLE [dbo].[SUBCRECONDETAIL] ADD  CONSTRAINT [DF_SUBCRECONDETAIL_VVALUE]  DEFAULT ('0') FOR [VVALUE]
ALTER TABLE [dbo].[SUBCRECONDETAIL] ADD  CONSTRAINT [DF_SUBCRECONDETAIL_TAXVALUE]  DEFAULT ('0') FOR [TAXVALUE]
ALTER TABLE [dbo].[SUBCRECONDETAIL] ADD  CONSTRAINT [DF_SUBCRECONDETAIL_PERC]  DEFAULT ('0') FOR [PERC]
ALTER TABLE [dbo].[SUBCRECONDETAIL] ADD  CONSTRAINT [DF_SUBCRECONDETAIL_TAXCODE]  DEFAULT ('') FOR [TAXCODE]
ALTER TABLE [dbo].[SUBCRECONDETAIL] ADD  CONSTRAINT [DF_SUBCRECONDETAIL_WHTID]  DEFAULT ('-1') FOR [WHTID]
ALTER TABLE [dbo].[SUBCRECONDETAIL] ADD  CONSTRAINT [DF_SUBCRECONDETAIL_LCALLOCATION]  DEFAULT ('') FOR [LCALLOCATION]
ALTER TABLE [dbo].[SUBCRECONDETAIL] ADD  CONSTRAINT [DF_SUBCRECONDETAIL_SUBALLOCATION]  DEFAULT ('') FOR [SUBALLOCATION]
ALTER TABLE [dbo].[SUBCRECONDETAIL] ADD  CONSTRAINT [DF_SUBCRECONDETAIL_OVERRIDE]  DEFAULT ('0') FOR [OVERRIDE]
ALTER TABLE [dbo].[SUBCRECONDETAIL] ADD  CONSTRAINT [DF_SUBCRECONDETAIL_WHTTHISP]  DEFAULT ('0') FOR [WHTTHISP]
ALTER TABLE [dbo].[SUBCRECONDETAIL] ADD  CONSTRAINT [DF_SUBCRECONDETAIL_ReconHistID]  DEFAULT ((-1)) FOR [ReconHistID]