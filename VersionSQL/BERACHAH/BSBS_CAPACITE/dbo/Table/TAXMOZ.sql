/****** Object:  Table [dbo].[TAXMOZ]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TAXMOZ](
	[TAXID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[TABLETYPE] [nvarchar](3) NOT NULL,
	[UPTOAMOUNT] [money] NOT NULL,
	[ND0] [decimal](18, 2) NOT NULL,
	[ND1] [decimal](18, 2) NOT NULL,
	[ND2] [decimal](18, 2) NOT NULL,
	[ND3] [decimal](18, 2) NOT NULL,
	[ND4] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_TAXMOZ] PRIMARY KEY CLUSTERED 
(
	[TAXID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TAXMOZ] ADD  CONSTRAINT [DF_TAXMOZ_ND0]  DEFAULT ((0)) FOR [ND0]
ALTER TABLE [dbo].[TAXMOZ] ADD  CONSTRAINT [DF_TAXMOZ_ND1]  DEFAULT ((0)) FOR [ND1]
ALTER TABLE [dbo].[TAXMOZ] ADD  CONSTRAINT [DF_TAXMOZ_ND2]  DEFAULT ((0)) FOR [ND2]
ALTER TABLE [dbo].[TAXMOZ] ADD  CONSTRAINT [DF_TAXMOZ_ND3]  DEFAULT ((0)) FOR [ND3]
ALTER TABLE [dbo].[TAXMOZ] ADD  CONSTRAINT [DF_TAXMOZ_ND4]  DEFAULT ((0)) FOR [ND4]