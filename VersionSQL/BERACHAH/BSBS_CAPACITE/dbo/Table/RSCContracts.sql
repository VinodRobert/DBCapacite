/****** Object:  Table [dbo].[RSCContracts]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[RSCContracts](
	[AreaCode] [nvarchar](10) NOT NULL,
	[ContractNumber] [nvarchar](10) NOT NULL,
	[ContractPercentage] [decimal](6, 2) NOT NULL,
 CONSTRAINT [PK_RSCContract] PRIMARY KEY CLUSTERED 
(
	[AreaCode] ASC,
	[ContractNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[RSCContracts] ADD  CONSTRAINT [DF_RSCContracts_ContractPercentage]  DEFAULT (100) FOR [ContractPercentage]