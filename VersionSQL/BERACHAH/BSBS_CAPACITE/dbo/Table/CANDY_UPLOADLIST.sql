/****** Object:  Table [dbo].[CANDY_UPLOADLIST]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CANDY_UPLOADLIST](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[XmlID] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Contract] [nvarchar](50) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[XmlUploadType] [nvarchar](50) NOT NULL,
	[XmlSize] [decimal](18, 4) NOT NULL,
	[BinZipSize] [decimal](18, 4) NOT NULL,
	[XmlDone] [bit] NOT NULL,
	[XmlFileName] [nvarchar](100) NOT NULL,
	[ComputerName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_CANDY_UPLOADLIST] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CANDY_UPLOADLIST] ADD  CONSTRAINT [DF_CANDY_UPLOADLIST_ComputerName]  DEFAULT ('') FOR [ComputerName]