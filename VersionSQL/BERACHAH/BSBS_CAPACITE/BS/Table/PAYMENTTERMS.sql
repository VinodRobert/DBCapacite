/****** Object:  Table [BS].[PAYMENTTERMS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BS].[PAYMENTTERMS](
	[TERM] [int] NOT NULL,
	[TERMNAME] [nvarchar](55) NOT NULL,
	[DAYS] [int] NULL
) ON [PRIMARY]