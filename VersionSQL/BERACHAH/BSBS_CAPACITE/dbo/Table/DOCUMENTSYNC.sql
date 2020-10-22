/****** Object:  Table [dbo].[DOCUMENTSYNC]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DOCUMENTSYNC](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SYNCDATE] [datetime] NOT NULL,
	[STATUS] [nvarchar](50) NOT NULL,
	[ERRORDESC] [nvarchar](255) NULL,
	[DID] [int] NULL,
	[DName] [nvarchar](100) NULL,
	[DLastUser] [int] NULL,
	[DLastUpdDate] [datetime] NULL,
	[DAType] [nvarchar](50) NULL,
	[DPgType] [nvarchar](50) NULL,
	[DNo] [nvarchar](50) NULL,
	[DUserBorgID] [int] NULL,
	[DVersion] [numeric](18, 0) NULL,
	[DDownloaded] [bit] NULL,
	[DShowOnly] [bit] NULL,
 CONSTRAINT [PK_DOCUMENTSYNC] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[DOCUMENTSYNC] ADD  CONSTRAINT [DF_DOCUMENTSYNC_SYNCDATE]  DEFAULT (getdate()) FOR [STATUS]