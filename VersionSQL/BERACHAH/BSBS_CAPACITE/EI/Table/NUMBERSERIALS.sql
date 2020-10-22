/****** Object:  Table [EI].[NUMBERSERIALS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [EI].[NUMBERSERIALS](
	[NUMBERID] [int] IDENTITY(1,1) NOT NULL,
	[BORGID] [int] NULL,
	[BORGPREFIX] [char](5) NULL,
	[YEAR] [int] NULL,
	[INVOICE] [int] NULL,
	[CREDITNOTE] [int] NULL,
	[DEBITNOTE] [int] NULL,
 CONSTRAINT [PK__NUMBERSE__EF1D0E77229F471B] PRIMARY KEY CLUSTERED 
(
	[NUMBERID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]