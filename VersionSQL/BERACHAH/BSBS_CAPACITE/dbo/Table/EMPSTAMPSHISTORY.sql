/****** Object:  Table [dbo].[EMPSTAMPSHISTORY]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EMPSTAMPSHISTORY](
	[PAYROLLID] [int] NOT NULL,
	[EMPNUMBER] [nvarchar](15) NOT NULL,
	[PERIODNO] [int] NOT NULL,
	[RUNNO] [int] NOT NULL,
	[YEARNO] [int] NOT NULL,
	[WEEKNO] [int] NOT NULL,
	[NOOFSTAMPS] [int] NOT NULL,
	[SSID] [int] NOT NULL,
	[SSTOTAL] [money] NOT NULL
) ON [PRIMARY]