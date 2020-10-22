/****** Object:  Table [dbo].[ROLETEMPLATEP]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ROLETEMPLATEP](
	[ITEMCATEGORY] [char](55) NULL,
	[ITEMACTION] [char](55) NULL,
	[ITEMDESCRIPTION] [char](255) NULL,
	[ITEMPOSITION] [int] NOT NULL,
	[LANG] [char](3) NOT NULL,
 CONSTRAINT [PK_ROLETEMPLATE_1] PRIMARY KEY CLUSTERED 
(
	[ITEMPOSITION] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ROLETEMPLATEP] ADD  CONSTRAINT [DF_ROLETEMPLATE_ITEMCATEGORY]  DEFAULT ('') FOR [ITEMCATEGORY]
ALTER TABLE [dbo].[ROLETEMPLATEP] ADD  CONSTRAINT [DF_ROLETEMPLATE_ITEMACTION]  DEFAULT ('') FOR [ITEMACTION]
ALTER TABLE [dbo].[ROLETEMPLATEP] ADD  CONSTRAINT [DF_ROLETEMPLATE_ITEMDESCRIPTION]  DEFAULT ('') FOR [ITEMDESCRIPTION]
ALTER TABLE [dbo].[ROLETEMPLATEP] ADD  CONSTRAINT [DF_ROLETEMPLATE_LANG_1]  DEFAULT ('ENG') FOR [LANG]