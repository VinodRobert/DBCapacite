/****** Object:  Table [dbo].[ROLEDETAILSE]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ROLEDETAILSE](
	[ROLEID] [int] NOT NULL,
	[ITEMENABLED] [bit] NOT NULL,
	[ITEMPOSITION] [int] NOT NULL,
 CONSTRAINT [PK_ROLEDETAILSE] PRIMARY KEY CLUSTERED 
(
	[ROLEID] ASC,
	[ITEMPOSITION] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ROLEDETAILSE] ADD  CONSTRAINT [DF_ROLEDETAILSE_ITEMENABLED]  DEFAULT (0) FOR [ITEMENABLED]
ALTER TABLE [dbo].[ROLEDETAILSE]  WITH CHECK ADD  CONSTRAINT [FK_ROLEDETAILSE_ROLEHEADERE] FOREIGN KEY([ROLEID])
REFERENCES [dbo].[ROLEHEADERE] ([ROLEID])
ALTER TABLE [dbo].[ROLEDETAILSE] CHECK CONSTRAINT [FK_ROLEDETAILSE_ROLEHEADERE]
ALTER TABLE [dbo].[ROLEDETAILSE]  WITH CHECK ADD  CONSTRAINT [FK_ROLEDETAILSE_ROLETEMPLATEE] FOREIGN KEY([ITEMPOSITION])
REFERENCES [dbo].[ROLETEMPLATEE] ([ITEMPOSITION])
ALTER TABLE [dbo].[ROLEDETAILSE] CHECK CONSTRAINT [FK_ROLEDETAILSE_ROLETEMPLATEE]