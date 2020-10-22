/****** Object:  Table [dbo].[DOCUMENTS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DOCUMENTS](
	[DID] [int] IDENTITY(1,1) NOT NULL,
	[DName] [nvarchar](100) NOT NULL,
	[DLastUser] [int] NOT NULL,
	[DLastUpdDate] [datetime] NOT NULL,
	[DAType] [nvarchar](50) NOT NULL,
	[DPgType] [nvarchar](50) NOT NULL,
	[DNo] [nvarchar](50) NOT NULL,
	[DUserBorgID] [int] NOT NULL,
	[DVersion] [numeric](18, 0) NOT NULL,
	[DDownloaded] [bit] NOT NULL,
	[DShowOnly] [bit] NOT NULL
) ON [PRIMARY]