/****** Object:  Table [BT].[WEBWOREQ]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BT].[WEBWOREQ](
	[WEBWOREQID] [int] IDENTITY(1,1) NOT NULL,
	[BSREQID] [int] NULL,
	[BSORDID] [int] NULL,
	[STATUSCODE] [int] NULL,
 CONSTRAINT [PK_WEBWOREQ] PRIMARY KEY CLUSTERED 
(
	[WEBWOREQID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]