/****** Object:  Table [dbo].[GC_Translations]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[GC_Translations](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[FieldID] [bigint] NOT NULL,
	[en_za] [nvarchar](100) NOT NULL,
	[en_au] [nvarchar](100) NOT NULL,
	[af] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_GC_Translations] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]