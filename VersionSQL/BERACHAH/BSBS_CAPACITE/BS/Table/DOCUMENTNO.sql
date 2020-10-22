/****** Object:  Table [BS].[DOCUMENTNO]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BS].[DOCUMENTNO](
	[Year] [int] NOT NULL,
	[OrgID] [int] NOT NULL,
	[Transtype] [varchar](3) NOT NULL,
	[LastNumber] [int] NULL,
 CONSTRAINT [PK_DOCUMENTNO] PRIMARY KEY CLUSTERED 
(
	[Year] ASC,
	[OrgID] ASC,
	[Transtype] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]