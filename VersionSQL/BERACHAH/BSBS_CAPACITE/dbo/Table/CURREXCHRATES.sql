/****** Object:  Table [dbo].[CURREXCHRATES]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CURREXCHRATES](
	[EXCHRID] [decimal](23, 0) IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[FROMCURR] [nvarchar](3) NOT NULL,
	[TOCURR] [nvarchar](3) NOT NULL,
	[RATE] [decimal](23, 6) NOT NULL,
	[AVRATE] [numeric](23, 6) NOT NULL,
 CONSTRAINT [PK_CURREXCHRATES] PRIMARY KEY NONCLUSTERED 
(
	[EXCHRID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CURREXCHRATES] ADD  CONSTRAINT [DF_CURREXCHRATES_AVRATE]  DEFAULT ('0') FOR [AVRATE]