/****** Object:  Table [dbo].[CHEQUEFORMATHEADER]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CHEQUEFORMATHEADER](
	[CHID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[NAME] [nvarchar](55) NOT NULL,
	[BORGID] [int] NOT NULL,
	[ISLASER] [bit] NOT NULL,
	[CHEQUESPERPAGE] [int] NOT NULL,
	[PRINTERNAME] [nvarchar](250) NOT NULL,
	[PRINTMILLIONS] [bit] NOT NULL,
	[CBCREMITTANCETMPL] [nvarchar](255) NULL,
	[GENERICCHEQUETMPL] [nvarchar](255) NULL,
 CONSTRAINT [PK_CHEQUEFORMATHEADER] PRIMARY KEY CLUSTERED 
(
	[CHID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CHEQUEFORMATHEADER] ADD  CONSTRAINT [DF_CHEQUEFORMATHEADER_NAME]  DEFAULT ('') FOR [NAME]
ALTER TABLE [dbo].[CHEQUEFORMATHEADER] ADD  DEFAULT ((-1)) FOR [BORGID]
ALTER TABLE [dbo].[CHEQUEFORMATHEADER] ADD  DEFAULT ((0)) FOR [ISLASER]
ALTER TABLE [dbo].[CHEQUEFORMATHEADER] ADD  DEFAULT ((3)) FOR [CHEQUESPERPAGE]
ALTER TABLE [dbo].[CHEQUEFORMATHEADER] ADD  CONSTRAINT [DF_CHEQUEFORMATHEADER_PRINTERNAME]  DEFAULT ('') FOR [PRINTERNAME]
ALTER TABLE [dbo].[CHEQUEFORMATHEADER] ADD  DEFAULT ((0)) FOR [PRINTMILLIONS]