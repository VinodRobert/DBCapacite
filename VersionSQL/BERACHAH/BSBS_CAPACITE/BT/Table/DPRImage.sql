/****** Object:  Table [BT].[DPRImage]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BT].[DPRImage](
	[DPRID] [int] IDENTITY(1,1) NOT NULL,
	[ProjectID] [int] NULL,
	[DPRDate] [datetime] NULL,
	[Narration] [varchar](100) NULL,
	[Picture] [image] NULL,
	[Path] [varchar](100) NULL,
 CONSTRAINT [PK_DPRImage] PRIMARY KEY CLUSTERED 
(
	[DPRID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]