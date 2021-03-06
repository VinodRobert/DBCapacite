/****** Object:  Table [dbo].[EMPREGLDSD]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EMPREGLDSD](
	[PAYROLLID] [int] NOT NULL,
	[EMPNUMBER] [nvarchar](15) NOT NULL,
	[PERIODNO] [int] NOT NULL,
	[YEARNO] [int] NOT NULL,
	[DNO] [decimal](18, 2) NOT NULL,
	[FROMDATE] [datetime] NOT NULL,
	[TODATE] [datetime] NOT NULL,
	[RECTYPE] [nvarchar](2) NOT NULL,
	[ERID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[BATCHNO] [nvarchar](20) NOT NULL,
	[HRLEAVERECORDID] [nvarchar](20) NULL,
	[CALCDATE] [datetime] NULL,
	[ISCALCULATED] [bit] NOT NULL,
	[ISLEAVEENCASHMENT] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[PAYROLLID] ASC,
	[EMPNUMBER] ASC,
	[PERIODNO] ASC,
	[YEARNO] ASC,
	[FROMDATE] ASC,
	[TODATE] ASC,
	[RECTYPE] ASC,
	[BATCHNO] ASC,
	[ISLEAVEENCASHMENT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[EMPREGLDSD] ADD  CONSTRAINT [DF_EMPREGLDSD_BATCHNO]  DEFAULT ('') FOR [BATCHNO]
ALTER TABLE [dbo].[EMPREGLDSD] ADD  DEFAULT ((0)) FOR [ISCALCULATED]
ALTER TABLE [dbo].[EMPREGLDSD] ADD  DEFAULT ((0)) FOR [ISLEAVEENCASHMENT]