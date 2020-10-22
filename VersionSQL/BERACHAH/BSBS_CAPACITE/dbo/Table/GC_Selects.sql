/****** Object:  Table [dbo].[GC_Selects]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[GC_Selects](
	[LookupName] [nvarchar](100) NOT NULL,
	[TableName] [nvarchar](100) NULL,
	[ValueField] [nvarchar](100) NULL,
	[TextField] [nvarchar](100) NULL,
	[FilterField] [nvarchar](100) NULL,
 CONSTRAINT [PK_GC_Selects] PRIMARY KEY CLUSTERED 
(
	[LookupName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]