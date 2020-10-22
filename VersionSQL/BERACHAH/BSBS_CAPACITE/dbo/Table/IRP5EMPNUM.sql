/****** Object:  Table [dbo].[IRP5EMPNUM]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[IRP5EMPNUM](
	[PRID] [int] IDENTITY(1,1) NOT NULL,
	[PAYROLLID] [int] NOT NULL,
	[TAXYEAR] [int] NOT NULL,
	[EMPNUMBER] [nvarchar](15) NOT NULL,
	[NUM] [int] NOT NULL,
	[PERIODNO] [int] NULL,
	[CERTNUMBER] [nvarchar](30) NULL
) ON [PRIMARY]