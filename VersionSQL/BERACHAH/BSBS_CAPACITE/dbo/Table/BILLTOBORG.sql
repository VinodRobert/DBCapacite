/****** Object:  Table [dbo].[BILLTOBORG]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[BILLTOBORG](
	[BORGID] [int] NOT NULL,
	[BILLTOID] [int] NOT NULL,
 CONSTRAINT [PK_BILLTOBORG] PRIMARY KEY CLUSTERED 
(
	[BORGID] ASC,
	[BILLTOID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]