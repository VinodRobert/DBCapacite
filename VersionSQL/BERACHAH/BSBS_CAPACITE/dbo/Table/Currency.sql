/****** Object:  Table [dbo].[Currency]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Currency](
	[CurrencyCode] [nvarchar](3) NOT NULL,
	[CurrencyName] [nvarchar](50) NOT NULL,
	[CurrencyDescription] [nvarchar](255) NOT NULL,
	[LocaleID] [int] NOT NULL,
	[IsEMU] [bit] NOT NULL
) ON [PRIMARY]