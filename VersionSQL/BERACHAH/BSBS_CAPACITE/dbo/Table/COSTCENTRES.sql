/****** Object:  Table [dbo].[COSTCENTRES]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[COSTCENTRES](
	[CCID] [int] IDENTITY(1,1) NOT NULL,
	[CostCentreName] [char](35) NULL
) ON [PRIMARY]