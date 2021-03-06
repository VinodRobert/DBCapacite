/****** Object:  Table [PB].[UTRHEADER]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [PB].[UTRHEADER](
	[UTRHEADID] [int] NOT NULL,
	[BANKID] [int] NULL,
	[FROMPERIOD] [datetime] NULL,
	[TOPERIOD] [datetime] NULL,
	[REMARKS] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[UTRHEADID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]