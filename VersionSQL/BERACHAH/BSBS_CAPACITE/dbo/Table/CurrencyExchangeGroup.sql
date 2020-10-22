/****** Object:  Table [dbo].[CurrencyExchangeGroup]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CurrencyExchangeGroup](
	[CurrencyExchangeGroupID] [int] NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL
) ON [PRIMARY]