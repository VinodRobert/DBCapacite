/****** Object:  Table [BI].[BUDGET]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BI].[BUDGET](
	[ID] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ORGID] [int] NULL,
	[LEDGERCODE] [varchar](15) NULL,
	[YEAR] [int] NULL,
	[APRIL] [decimal](18, 2) NULL,
	[MAY] [decimal](18, 2) NULL,
	[JUNE] [decimal](18, 2) NULL,
	[JULY] [decimal](18, 2) NULL,
	[AUGUST] [decimal](18, 2) NULL,
	[SEPTEMBER] [decimal](18, 2) NULL,
	[OCTOBER] [decimal](18, 2) NULL,
	[NOVEMBER] [decimal](18, 2) NULL,
	[DECEMBER] [decimal](18, 2) NULL,
	[JANUARY] [decimal](18, 2) NULL,
	[FEBRUARY] [decimal](18, 2) NULL,
	[MARCH] [decimal](18, 2) NULL,
 CONSTRAINT [PK_BUDGETVSACTUAL] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]