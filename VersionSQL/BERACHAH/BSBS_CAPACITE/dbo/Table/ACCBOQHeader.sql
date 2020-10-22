/****** Object:  Table [dbo].[ACCBOQHeader]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ACCBOQHeader](
	[HeaderId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ReconID] [int] NOT NULL,
	[OrgID] [int] NULL,
	[ContractID] [int] NULL,
 CONSTRAINT [PK_ACCBOQHeader] PRIMARY KEY CLUSTERED 
(
	[HeaderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]