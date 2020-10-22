/****** Object:  Table [dbo].[BORGSRAPPROVER]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[BORGSRAPPROVER](
	[BORGID] [int] NOT NULL,
	[APPROVERID] [int] NOT NULL,
 CONSTRAINT [PK_BORGSRAPPROVER] PRIMARY KEY CLUSTERED 
(
	[BORGID] ASC,
	[APPROVERID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]