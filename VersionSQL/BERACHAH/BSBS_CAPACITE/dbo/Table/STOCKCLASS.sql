/****** Object:  Table [dbo].[STOCKCLASS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[STOCKCLASS](
	[ClassNumber] [char](20) NOT NULL,
	[ClassName] [char](55) NOT NULL,
	[ClassFrom] [int] NOT NULL,
	[ClassTo] [int] NOT NULL,
 CONSTRAINT [PK_STOCKCLASS] PRIMARY KEY CLUSTERED 
(
	[ClassNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]