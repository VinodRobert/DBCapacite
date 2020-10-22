/****** Object:  Table [dbo].[TAXINDIA]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TAXINDIA](
	[FROMAMOUNT] [money] NOT NULL,
	[TOAMOUNT] [money] NOT NULL,
	[BASE] [money] NOT NULL,
	[PERCOVER] [decimal](18, 4) NOT NULL,
	[TAXALLOC] [nvarchar](3) NOT NULL,
	[TAXID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
 CONSTRAINT [PK_TAXINDIA] PRIMARY KEY CLUSTERED 
(
	[TAXID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TAXINDIA] ADD  CONSTRAINT [DF_TAXINDIA_TAXALLOC]  DEFAULT ('') FOR [TAXALLOC]