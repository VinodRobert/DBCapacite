/****** Object:  Table [dbo].[UOM_Before_ACC1102]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[UOM_Before_ACC1102](
	[UOMID] [int] IDENTITY(1,1) NOT NULL,
	[UOMCODE] [varchar](10) NOT NULL,
	[UOMDESCR] [nvarchar](120) NOT NULL,
	[OURCODE] [varchar](10) NOT NULL,
	[OURDESCR] [nvarchar](120) NOT NULL,
	[ISACTIVE] [bit] NOT NULL
) ON [PRIMARY]