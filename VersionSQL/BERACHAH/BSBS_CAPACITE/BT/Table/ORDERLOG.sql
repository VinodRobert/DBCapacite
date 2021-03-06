/****** Object:  Table [BT].[ORDERLOG]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BT].[ORDERLOG](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[BORGID] [int] NULL,
	[REQID] [int] NULL,
	[RESCODE] [varchar](25) NULL,
	[OPENING] [decimal](18, 2) NULL,
	[REQUISITION] [decimal](18, 2) NULL,
	[CANCELATION] [decimal](18, 2) NULL,
	[ORDID] [int] NULL,
	[ORDERED] [decimal](18, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]