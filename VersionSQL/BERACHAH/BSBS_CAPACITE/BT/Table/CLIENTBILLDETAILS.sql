/****** Object:  Table [BT].[CLIENTBILLDETAILS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BT].[CLIENTBILLDETAILS](
	[BILLDETAILID] [int] IDENTITY(1,1) NOT NULL,
	[BILLID] [int] NULL,
	[BOQNUMBER] [varchar](15) NULL,
	[UOM] [varchar](15) NULL,
	[RATE] [decimal](18, 2) NULL,
	[BILLEDQTY] [decimal](18, 2) NULL
) ON [PRIMARY]