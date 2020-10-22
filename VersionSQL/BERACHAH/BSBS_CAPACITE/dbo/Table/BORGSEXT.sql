/****** Object:  Table [dbo].[BORGSEXT]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[BORGSEXT](
	[BORGID] [int] NOT NULL,
	[REQUISITIONCLIENTID] [int] NOT NULL,
	[ERFQCLIENTID] [int] NOT NULL,
	[ERFQCLOSEDATE] [datetime] NULL,
	[ERFQTENDERCLOSEDATE] [datetime] NULL,
	[UIFREFERENCENUMBER] [nvarchar](30) NULL,
 CONSTRAINT [PK_BORGSEXT] PRIMARY KEY CLUSTERED 
(
	[BORGID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[BORGSEXT] ADD  CONSTRAINT [DF_BORGSEXT_REQUISITIONCLIENTID]  DEFAULT ((-1)) FOR [REQUISITIONCLIENTID]
ALTER TABLE [dbo].[BORGSEXT] ADD  DEFAULT ((-1)) FOR [ERFQCLIENTID]