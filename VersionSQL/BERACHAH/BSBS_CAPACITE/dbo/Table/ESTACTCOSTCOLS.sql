/****** Object:  Table [dbo].[ESTACTCOSTCOLS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ESTACTCOSTCOLS](
	[ESTID] [int] NOT NULL,
	[ACTNUMBER] [nvarchar](10) NOT NULL,
	[CCD1] [nvarchar](15) NOT NULL,
	[CCD2] [nvarchar](15) NOT NULL,
	[CCD3] [nvarchar](15) NOT NULL,
	[CCD4] [nvarchar](15) NOT NULL,
	[CCD5] [nvarchar](15) NOT NULL,
	[CCD6] [nvarchar](15) NOT NULL,
	[CCD7] [nvarchar](15) NOT NULL,
	[CCD8] [nvarchar](15) NOT NULL,
	[CCD9] [nvarchar](15) NOT NULL,
 CONSTRAINT [PK_ESTACTCOSTCOLS] PRIMARY KEY CLUSTERED 
(
	[ESTID] ASC,
	[ACTNUMBER] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ESTACTCOSTCOLS] ADD  CONSTRAINT [DF_ESTACTCOSTCOLS_CCD1]  DEFAULT ('') FOR [CCD1]
ALTER TABLE [dbo].[ESTACTCOSTCOLS] ADD  CONSTRAINT [DF_ESTACTCOSTCOLS_CCD2]  DEFAULT ('') FOR [CCD2]
ALTER TABLE [dbo].[ESTACTCOSTCOLS] ADD  CONSTRAINT [DF_ESTACTCOSTCOLS_CCD3]  DEFAULT ('') FOR [CCD3]
ALTER TABLE [dbo].[ESTACTCOSTCOLS] ADD  CONSTRAINT [DF_ESTACTCOSTCOLS_CCD4]  DEFAULT ('') FOR [CCD4]
ALTER TABLE [dbo].[ESTACTCOSTCOLS] ADD  CONSTRAINT [DF_ESTACTCOSTCOLS_CCD5]  DEFAULT ('') FOR [CCD5]
ALTER TABLE [dbo].[ESTACTCOSTCOLS] ADD  CONSTRAINT [DF_ESTACTCOSTCOLS_CCD6]  DEFAULT ('') FOR [CCD6]
ALTER TABLE [dbo].[ESTACTCOSTCOLS] ADD  CONSTRAINT [DF_ESTACTCOSTCOLS_CCD7]  DEFAULT ('') FOR [CCD7]
ALTER TABLE [dbo].[ESTACTCOSTCOLS] ADD  CONSTRAINT [DF_ESTACTCOSTCOLS_CCD8]  DEFAULT ('') FOR [CCD8]
ALTER TABLE [dbo].[ESTACTCOSTCOLS] ADD  CONSTRAINT [DF_ESTACTCOSTCOLS_CCD9]  DEFAULT ('') FOR [CCD9]