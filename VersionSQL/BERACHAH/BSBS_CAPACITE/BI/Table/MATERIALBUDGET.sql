/****** Object:  Table [BI].[MATERIALBUDGET]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BI].[MATERIALBUDGET](
	[BUDGETID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ORGID] [int] NULL,
	[STOCKID] [varchar](15) NULL,
	[QTY] [decimal](18, 3) NULL,
	[RATE] [decimal](18, 2) NULL,
	[UOM] [varchar](15) NULL,
	[UPLOADDATE] [datetime] NULL,
	[SNAPSHOTID] [int] NULL,
 CONSTRAINT [PK__MATERIAL__D45231309D059AC0] PRIMARY KEY CLUSTERED 
(
	[BUDGETID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]