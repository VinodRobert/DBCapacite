/****** Object:  Table [EI].[UOM]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [EI].[UOM](
	[UOMID] [int] NOT NULL,
	[UOM] [varchar](3) NULL,
	[DESCRIPTION] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[UOMID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]