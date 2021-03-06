/****** Object:  Table [dbo].[EMPLOYEESLDARCH]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EMPLOYEESLDARCH](
	[EMPNUMBER] [nvarchar](15) NOT NULL,
	[CALYEARNO] [smallint] NOT NULL,
	[LDTOTALTAKEN] [decimal](18, 2) NOT NULL,
	[LDACCUMULATED] [decimal](18, 2) NOT NULL,
	[PAYROLLID] [int] NOT NULL,
	[TAXYEARNO] [smallint] NOT NULL,
 CONSTRAINT [PK_EMPLOYEESLDARCH] PRIMARY KEY CLUSTERED 
(
	[EMPNUMBER] ASC,
	[CALYEARNO] ASC,
	[PAYROLLID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]