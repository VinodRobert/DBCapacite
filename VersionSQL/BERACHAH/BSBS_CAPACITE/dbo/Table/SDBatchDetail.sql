/****** Object:  Table [dbo].[SDBatchDetail]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[SDBatchDetail](
	[DetailId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HeaderID] [int] NOT NULL,
	[EMPNUMBER] [nvarchar](15) NOT NULL,
	[SickDays] [decimal](18, 2) NOT NULL,
	[tPayrollid] [int] NULL,
	[FROMDATE] [datetime] NULL,
	[TODATE] [datetime] NULL,
	[PERIODNO] [int] NULL,
	[YEARNO] [int] NULL,
	[RECTYPE] [nvarchar](2) NULL,
 CONSTRAINT [PK_SDBatchDetail] PRIMARY KEY CLUSTERED 
(
	[DetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]