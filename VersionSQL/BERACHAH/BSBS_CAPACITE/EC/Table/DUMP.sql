/****** Object:  Table [EC].[DUMP]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [EC].[DUMP](
	[SLNO] [int] NULL,
	[PARTYCODE] [varchar](25) NULL,
	[PARTYNAME] [varchar](250) NULL,
	[ACCNO] [varchar](25) NULL,
	[IFSC] [varchar](25) NULL,
	[EMAILID] [varchar](25) NULL,
	[ADDRESS1] [varchar](250) NULL,
	[ADDRESS2] [varchar](250) NULL,
	[ADDRESS3] [varchar](250) NULL
) ON [PRIMARY]