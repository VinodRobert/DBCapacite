/****** Object:  Table [BT].[BUDGETMATERAILMOVEMENTHEAD]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BT].[BUDGETMATERAILMOVEMENTHEAD](
	[HEADERID] [bigint] IDENTITY(1,1) NOT NULL,
	[PROJECTCODE] [int] NULL,
	[PROJECTNAME] [varchar](200) NULL,
	[TOOLCODE] [varchar](25) NULL,
	[MAJORHEAD] [varchar](200) NULL,
	[TOOLNAME] [varchar](200) NULL,
	[CATEGORY] [varchar](15) NULL,
	[UOM] [varchar](20) NULL,
	[BUDGET] [decimal](18, 4) NULL,
	[RELEASED] [decimal](18, 4) NULL,
	[TENDERTABLEQTY] [decimal](18, 4) NULL,
	[TENDERTABLEORDEREDQTY] [decimal](18, 4) NULL,
	[TENDERTABLEFORORDERING] [decimal](18, 4) NULL,
	[PURCHASE_REQUEST_MADE] [decimal](18, 4) NULL,
	[CANCELLED] [decimal](18, 4) NULL,
	[REJECTED] [decimal](18, 4) NULL,
	[ORDERED] [decimal](18, 4) NULL,
	[DELIVERY] [decimal](18, 4) NULL,
	[COMPLETED] [decimal](18, 4) NULL,
	[OPENPR] [decimal](18, 4) NULL,
	[FORPURCHASE_WEBPR] [decimal](18, 4) NULL,
	[TOTALQTYCONSUMED] [decimal](18, 4) NULL,
	[BALANCEQTYFORPURCHASE] [decimal](18, 4) NULL,
	[C1_TENDERQTY_RELEASEQTY] [int] NULL,
	[C2_TENDERORDER_CONSUMED] [int] NULL,
	[C3_WEBPRQTY_BALANCEFORPURCHASE] [int] NULL,
	[TENDERITEMID] [int] NULL,
	[MONTHLYBUDGETID] [int] NULL,
 CONSTRAINT [PK__BUDGETMA__13405418B6377C60] PRIMARY KEY CLUSTERED 
(
	[HEADERID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]