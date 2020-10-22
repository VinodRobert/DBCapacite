/****** Object:  Table [dbo].[ROLEDETAILSP]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ROLEDETAILSP](
	[ROLEID] [int] NOT NULL,
	[ITEMENABLED] [bit] NOT NULL,
	[ITEMPOSITION] [int] NOT NULL,
 CONSTRAINT [PK_ROLEDETAILS] PRIMARY KEY CLUSTERED 
(
	[ROLEID] ASC,
	[ITEMPOSITION] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ROLEDETAILSP] ADD  CONSTRAINT [DF_RELEDETAILS_ITEMENABLED]  DEFAULT (0) FOR [ITEMENABLED]