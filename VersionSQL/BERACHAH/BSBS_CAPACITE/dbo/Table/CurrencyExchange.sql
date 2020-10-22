/****** Object:  Table [dbo].[CurrencyExchange]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CurrencyExchange](
	[CurrencyExchangeGroupID] [int] NOT NULL,
	[FromCurrencyCode] [nvarchar](3) NOT NULL,
	[ToCurrencyCode] [nvarchar](3) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[ConversionRate] [decimal](12, 6) NOT NULL
) ON [PRIMARY]