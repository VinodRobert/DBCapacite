/****** Object:  Table [dbo].[ACCBOQHEADER_180817]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ACCBOQHEADER_180817](
	[HeaderId] [int] IDENTITY(1,1) NOT NULL,
	[ReconID] [int] NOT NULL,
	[OrgID] [int] NULL,
	[ContractID] [int] NULL
) ON [PRIMARY]