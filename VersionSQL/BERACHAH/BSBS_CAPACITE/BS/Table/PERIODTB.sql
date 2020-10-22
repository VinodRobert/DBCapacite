/****** Object:  Table [BS].[PERIODTB]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BS].[PERIODTB](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[LEDGERCODE] [varchar](15) NULL,
	[LEDGERNAME] [varchar](150) NULL,
	[OB] [decimal](18, 2) NULL,
	[APRIL] [decimal](18, 3) NULL,
	[MAY] [decimal](18, 3) NULL,
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
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]