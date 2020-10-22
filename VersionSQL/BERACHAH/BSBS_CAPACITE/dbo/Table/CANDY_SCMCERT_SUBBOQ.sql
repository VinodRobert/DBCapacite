/****** Object:  Table [dbo].[CANDY_SCMCERT_SUBBOQ]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CANDY_SCMCERT_SUBBOQ](
	[SUBBOQID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[UploadListID] [int] NOT NULL,
	[ID] [int] NULL,
	[PAGE] [nvarchar](50) NULL,
	[ITEM] [nvarchar](50) NULL,
	[DESC] [nvarchar](255) NULL,
	[Unit] [nvarchar](50) NULL,
	[SUBRATEB] [decimal](18, 4) NULL,
	[AWDQTYB] [decimal](22, 8) NULL,
	[PAYQTYB] [decimal](22, 8) NULL,
	[PERIODPAYQTYB] [decimal](22, 8) NULL,
	[AWARDEDAMTB] [decimal](18, 4) NULL,
	[PAYAMTB] [decimal](18, 4) NULL,
	[PERIODPAYAMTB] [decimal](18, 4) NULL,
	[COSTCODE] [nvarchar](50) NULL,
	[TASKCODE] [nvarchar](50) NULL,
	[VOCODE] [nvarchar](50) NULL,
	[VOSTATUS] [int] NULL,
	[COMPARISONRATEB] [decimal](18, 4) NOT NULL,
	[DUEQTYB] [decimal](18, 4) NOT NULL,
	[SUBBYUNIT] [nvarchar](50) NULL,
	[SUBBYDESC] [nvarchar](255) NULL,
	[INVQTYB] [decimal](22, 8) NULL,
	[INVAMTB] [decimal](18, 4) NULL,
	[OVERVALUEDQTYB] [decimal](22, 8) NULL,
	[OVERVALUEDAMTB] [decimal](18, 4) NULL,
	[SUBBYREMARK] [nvarchar](255) NULL,
 CONSTRAINT [PK_CANDY_SCMCERT_SUBBOQ] PRIMARY KEY CLUSTERED 
(
	[SUBBOQID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CANDY_SCMCERT_SUBBOQ] ADD  CONSTRAINT [DF_CANDY_SCMCERT_SUBBOQ_DESC]  DEFAULT ('') FOR [DESC]
ALTER TABLE [dbo].[CANDY_SCMCERT_SUBBOQ] ADD  CONSTRAINT [DF_CANDY_SCMCERT_SUBBOQ_AWDQTYB]  DEFAULT ((0)) FOR [AWDQTYB]
ALTER TABLE [dbo].[CANDY_SCMCERT_SUBBOQ] ADD  CONSTRAINT [DF_CANDY_SCMCERT_SUBBOQ_PAYQTYB]  DEFAULT ((0)) FOR [PAYQTYB]
ALTER TABLE [dbo].[CANDY_SCMCERT_SUBBOQ] ADD  CONSTRAINT [DF_CANDY_SCMCERT_SUBBOQ_PERIODPAYQTYB]  DEFAULT ((0)) FOR [PERIODPAYQTYB]
ALTER TABLE [dbo].[CANDY_SCMCERT_SUBBOQ] ADD  CONSTRAINT [DF_CANDY_SCMCERT_SUBBOQ_COMPARISONRATEB]  DEFAULT ((0)) FOR [COMPARISONRATEB]
ALTER TABLE [dbo].[CANDY_SCMCERT_SUBBOQ] ADD  CONSTRAINT [DF_CANDY_SCMCERT_SUBBOQ_DUEQTYB]  DEFAULT ((0)) FOR [DUEQTYB]
ALTER TABLE [dbo].[CANDY_SCMCERT_SUBBOQ] ADD  CONSTRAINT [DF_CANDY_SCMCERT_SUBBOQ_SUBBYUNIT]  DEFAULT ('') FOR [SUBBYUNIT]
ALTER TABLE [dbo].[CANDY_SCMCERT_SUBBOQ] ADD  CONSTRAINT [DF_CANDY_SCMCERT_SUBBOQ_SUBBYDESC]  DEFAULT ('') FOR [SUBBYDESC]
ALTER TABLE [dbo].[CANDY_SCMCERT_SUBBOQ] ADD  CONSTRAINT [DF_CANDY_SCMCERT_SUBBOQ_INVQTYB]  DEFAULT ((0)) FOR [INVQTYB]
ALTER TABLE [dbo].[CANDY_SCMCERT_SUBBOQ] ADD  CONSTRAINT [DF_CANDY_SCMCERT_SUBBOQ_INVAMTB]  DEFAULT ((0)) FOR [INVAMTB]
ALTER TABLE [dbo].[CANDY_SCMCERT_SUBBOQ] ADD  CONSTRAINT [DF_CANDY_SCMCERT_SUBBOQ_OVERVALUEDQTYB]  DEFAULT ((0)) FOR [OVERVALUEDQTYB]
ALTER TABLE [dbo].[CANDY_SCMCERT_SUBBOQ] ADD  CONSTRAINT [DF_CANDY_SCMCERT_SUBBOQ_OVERVALUEDAMTB]  DEFAULT ((0)) FOR [OVERVALUEDAMTB]
ALTER TABLE [dbo].[CANDY_SCMCERT_SUBBOQ] ADD  CONSTRAINT [DF_CANDY_SCMCERT_SUBBOQ_SUBBYREMARK]  DEFAULT ('') FOR [SUBBYREMARK]
ALTER TABLE [dbo].[CANDY_SCMCERT_SUBBOQ]  WITH CHECK ADD  CONSTRAINT [FK_CANDY_SCMCERT_SUBBOQ_CANDY_UPLOADLIST] FOREIGN KEY([UploadListID])
REFERENCES [dbo].[CANDY_UPLOADLIST] ([ID])
ALTER TABLE [dbo].[CANDY_SCMCERT_SUBBOQ] CHECK CONSTRAINT [FK_CANDY_SCMCERT_SUBBOQ_CANDY_UPLOADLIST]