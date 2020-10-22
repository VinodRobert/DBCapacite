/****** Object:  Table [dbo].[CABATCHDETAIL]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CABATCHDETAIL](
	[DetailId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HeaderID] [int] NOT NULL,
	[EMPNUMBER] [nvarchar](15) NOT NULL,
	[DAYNO] [int] NOT NULL,
	[WEEKNO] [int] NOT NULL,
	[NT] [decimal](18, 2) NOT NULL,
	[OT1] [decimal](18, 2) NOT NULL,
	[OT2] [decimal](18, 2) NOT NULL,
	[OT3] [decimal](18, 2) NOT NULL,
	[OT4] [decimal](18, 2) NOT NULL,
	[OT5] [decimal](18, 2) NOT NULL,
	[USERATE] [char](1) NOT NULL,
	[LEDGERCODE] [char](10) NOT NULL,
	[COSTALLOCATION] [varchar](50) NOT NULL,
	[ACTNUMBER] [char](10) NOT NULL,
	[tDiv] [int] NULL,
	[tPayrollid] [int] NULL,
	[STAMPHOURS] [decimal](18, 2) NULL,
 CONSTRAINT [PK_CABatchData] PRIMARY KEY CLUSTERED 
(
	[DetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]