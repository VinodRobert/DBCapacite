/****** Object:  Table [dbo].[PRLCONTRBONUS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PRLCONTRBONUS](
	[PKLPRLCONTRBONUSID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CONTRNUMBER] [nvarchar](10) NOT NULL,
	[BONUS] [decimal](18, 4) NOT NULL,
	[PERIODNO] [int] NOT NULL,
	[YEARNO] [int] NOT NULL,
	[BORGID] [int] NULL,
 CONSTRAINT [PK_PRLCONTRBONUS] PRIMARY KEY CLUSTERED 
(
	[PKLPRLCONTRBONUSID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]