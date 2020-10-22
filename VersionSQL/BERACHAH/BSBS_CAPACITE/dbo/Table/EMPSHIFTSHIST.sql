/****** Object:  Table [dbo].[EMPSHIFTSHIST]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EMPSHIFTSHIST](
	[PAYROLLID] [int] NOT NULL,
	[EMPNUMBER] [nvarchar](15) NOT NULL,
	[SHIFTS] [decimal](18, 2) NOT NULL,
	[YEARNO] [int] NOT NULL
) ON [PRIMARY]