/****** Object:  Table [dbo].[CURRENCIESBU]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CURRENCIESBU](
	[CURRCODE] [nvarchar](3) NOT NULL,
	[CURRNAME] [nvarchar](50) NOT NULL,
	[LOCALE] [decimal](23, 0) NOT NULL,
	[TOJOINC] [int] NOT NULL
) ON [PRIMARY]