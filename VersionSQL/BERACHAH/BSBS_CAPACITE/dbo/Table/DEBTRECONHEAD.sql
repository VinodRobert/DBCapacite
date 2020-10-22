/****** Object:  Table [dbo].[DEBTRECONHEAD]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DEBTRECONHEAD](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CODE] [nvarchar](10) NULL,
	[DESCRIPTION] [nvarchar](250) NULL,
	[MASTA] [nvarchar](50) NULL,
	[MASTB] [nvarchar](50) NULL,
	[MASTC] [nvarchar](50) NULL,
	[MASTD] [nvarchar](50) NULL,
	[MASTE] [nvarchar](50) NULL,
	[ACCSPEC] [int] NULL,
	[POST_ON] [int] NULL,
	[NUM] [int] NULL,
	[TAXIE] [int] NULL,
	[ReconHistID] [int] NOT NULL,
 CONSTRAINT [PK_DEBTRECONHEAD] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[DEBTRECONHEAD] ADD  CONSTRAINT [DF_DEBTRECONHEAD_ReconHistID]  DEFAULT ((-1)) FOR [ReconHistID]