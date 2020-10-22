/****** Object:  Table [BI].[INDICATORMASTER]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BI].[INDICATORMASTER](
	[INDEXCODE] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[INDICATORCODE] [int] NULL,
	[INDICATORNAME] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[INDEXCODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]