/****** Object:  Table [BT].[WEBWORKORDERITEMS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BT].[WEBWORKORDERITEMS](
	[WWWITEMCODE] [int] NOT NULL,
	[BMTPROJECTCODE] [int] NULL,
	[BSORGID] [int] NULL,
	[PROJECTCODE] [int] NULL,
	[CONTRACTCODE] [varchar](25) NULL,
	[DELIVERYID] [int] NULL,
	[ACTIVITY] [varchar](25) NULL,
	[LEDGERCODE] [varchar](15) NULL,
	[CLIENTBOQ] [varchar](25) NULL,
	[BOQCODE] [varchar](20) NULL,
	[BOQDESCRIPTION] [varchar](600) NULL,
	[WORKITEMCODE] [varchar](25) NULL,
	[WORKITEMDESCRIPTION] [varchar](600) NULL,
	[WORKORDERITEMDESCRIPTION] [ntext] NULL,
	[UOM] [varchar](25) NULL,
	[RATE] [decimal](18, 2) NULL,
	[TOTALQTY] [decimal](18, 2) NULL,
	[ORDEREDQTY] [decimal](18, 2) NULL,
	[ORDEREDAMOUNT] [decimal](18, 2) NULL,
	[TOTALBALANCEQTY] [decimal](18, 4) NULL,
	[PRQTY] [decimal](18, 4) NULL,
	[ITEMID] [int] NULL,
 CONSTRAINT [PK__WEBWORKO__98E5206225596B28] PRIMARY KEY CLUSTERED 
(
	[WWWITEMCODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]