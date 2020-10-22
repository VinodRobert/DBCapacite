/****** Object:  Table [BS].[TEMPTAX]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BS].[TEMPTAX](
	[TRANSID] [int] NOT NULL,
	[CS] [nvarchar](2) NULL,
	[CS Amount] [numeric](38, 4) NULL,
	[EC] [nvarchar](2) NULL,
	[EC Amount] [numeric](38, 4) NULL,
	[EX] [nvarchar](2) NULL,
	[EX Amount] [numeric](38, 4) NULL,
	[SH] [nvarchar](2) NULL,
	[SH Amount] [numeric](38, 4) NULL,
	[ST] [nvarchar](2) NULL,
	[ST Amount] [numeric](38, 4) NULL,
	[VT] [nvarchar](2) NULL,
	[VT Amount] [numeric](38, 4) NULL
) ON [PRIMARY]