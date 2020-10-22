/****** Object:  Table [BT].[MATERIALMOVEMENTDETAIL]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BT].[MATERIALMOVEMENTDETAIL](
	[INDEXCODE] [bigint] IDENTITY(1,1) NOT NULL,
	[INDEXID] [int] NULL,
	[TENDERID] [int] NULL,
	[BORGID] [int] NULL,
	[REQID] [bigint] NULL,
	[REQNUMBER] [varchar](35) NULL,
	[REQDATE] [datetime] NULL,
	[LINENUMBER] [int] NULL,
	[MATERIALCODE] [varchar](15) NULL,
	[MATERIALNAME] [varchar](250) NULL,
	[UOM] [varchar](15) NULL,
	[REQQTY] [decimal](18, 4) NULL,
	[REQRATE] [decimal](18, 2) NULL,
	[REQAMOUNT] [decimal](18, 2) NULL,
	[REQSTATUS] [int] NULL,
	[STATUS_REQ] [varchar](50) NULL,
	[ORDID] [int] NULL,
	[ORDNUMBER] [varchar](35) NULL,
	[ORDDATE] [datetime] NULL,
	[ORDQTY] [decimal](18, 4) NULL,
	[ORDRATE] [decimal](18, 2) NULL,
	[ORDAMOUNT] [decimal](18, 2) NULL,
	[ORDSTATUS] [int] NULL,
	[STATUS_ORD] [varchar](50) NULL,
	[DELIVEREDQTY] [decimal](18, 4) NULL,
	[TOOLCODE] [varchar](25) NULL,
	[BUDGETCROSSREFID] [int] NULL,
	[FINALIZATIONSTATUS] [int] NULL,
 CONSTRAINT [PK__MATERIAL__0A93C88A60873A26] PRIMARY KEY CLUSTERED 
(
	[INDEXCODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]