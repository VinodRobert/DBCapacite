/****** Object:  Table [BT].[BUDGETACTUAL]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BT].[BUDGETACTUAL](
	[BOQNUMBER] [varchar](15) NULL,
	[BOQ] [varchar](255) NULL,
	[UOM] [varchar](15) NULL,
	[RATE] [decimal](18, 2) NULL,
	[MONTHBUDGET] [decimal](18, 4) NULL,
	[MONTHACTUAL] [decimal](18, 2) NULL,
	[QUARTERBUDGET] [decimal](18, 4) NULL,
	[QUARTERACTUAL] [decimal](18, 2) NULL,
	[TILLDATEBUDGET] [decimal](18, 4) NULL,
	[TILLDATEACTUAL] [decimal](18, 2) NULL
) ON [PRIMARY]