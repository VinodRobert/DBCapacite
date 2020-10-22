/****** Object:  Table [dbo].[CANDY_SCMCERT_SUBMOS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CANDY_SCMCERT_SUBMOS](
	[SUBMOSID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[UploadListID] [int] NOT NULL,
	[ID] [int] NULL,
	[DATEDT] [datetime] NULL,
	[CERTNO] [nvarchar](50) NULL,
	[ITEM] [nvarchar](50) NULL,
	[DESC] [nvarchar](100) NULL,
	[UNIT] [nvarchar](50) NULL,
	[QTYB] [decimal](22, 8) NULL,
	[RATEB] [decimal](18, 4) NULL,
	[MOSAMTB] [decimal](18, 4) NULL,
 CONSTRAINT [PK_CANDY_SCMCERT_SUBMOS] PRIMARY KEY CLUSTERED 
(
	[SUBMOSID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CANDY_SCMCERT_SUBMOS] ADD  CONSTRAINT [DF_CANDY_SCMCERT_SUBMOS_QTYB]  DEFAULT ((0)) FOR [QTYB]
ALTER TABLE [dbo].[CANDY_SCMCERT_SUBMOS]  WITH CHECK ADD  CONSTRAINT [FK_CANDY_SCMCERT_SUBMOS_CANDY_UPLOADLIST] FOREIGN KEY([UploadListID])
REFERENCES [dbo].[CANDY_UPLOADLIST] ([ID])
ALTER TABLE [dbo].[CANDY_SCMCERT_SUBMOS] CHECK CONSTRAINT [FK_CANDY_SCMCERT_SUBMOS_CANDY_UPLOADLIST]