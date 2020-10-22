/****** Object:  Table [dbo].[PLANTANDEQNOTES]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PLANTANDEQNOTES](
	[PNID] [int] IDENTITY(1,1) NOT NULL,
	[PNPeNumber] [char](10) NOT NULL,
	[PNUserID] [char](10) NULL,
	[PNDate] [datetime] NOT NULL,
	[PNSMR] [numeric](18, 4) NULL,
	[PNDesTitle] [nvarchar](50) NULL,
	[PNDescription] [ntext] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]