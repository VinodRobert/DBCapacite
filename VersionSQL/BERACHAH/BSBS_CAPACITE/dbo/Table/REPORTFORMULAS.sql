/****** Object:  Table [dbo].[REPORTFORMULAS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[REPORTFORMULAS](
	[RFID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RID] [int] NOT NULL,
	[NAME] [nvarchar](50) NOT NULL,
	[FORMULANAME] [nvarchar](50) NOT NULL,
	[DEFAULTVALUE] [nvarchar](250) NOT NULL,
	[SEQ] [int] NOT NULL,
	[HIDE] [bit] NOT NULL,
	[EVAL] [bit] NOT NULL,
	[ISSTRING] [bit] NOT NULL,
	[ISDATE] [bit] NOT NULL,
 CONSTRAINT [PK_REPORTFORMULAS] PRIMARY KEY CLUSTERED 
(
	[RFID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[REPORTFORMULAS] ADD  CONSTRAINT [DF_REPORTFORMULAS_SEQ]  DEFAULT ((1)) FOR [SEQ]
ALTER TABLE [dbo].[REPORTFORMULAS] ADD  CONSTRAINT [DF_REPORTFORMULAS_HIDE]  DEFAULT ((0)) FOR [HIDE]
ALTER TABLE [dbo].[REPORTFORMULAS] ADD  CONSTRAINT [DF_REPORTFORMULAS_EXEC]  DEFAULT ((0)) FOR [EVAL]
ALTER TABLE [dbo].[REPORTFORMULAS] ADD  CONSTRAINT [DF_REPORTFORMULAS_ISSTRING]  DEFAULT ((0)) FOR [ISSTRING]
ALTER TABLE [dbo].[REPORTFORMULAS] ADD  CONSTRAINT [DF_REPORTFORMULAS_ISDATE]  DEFAULT ((0)) FOR [ISDATE]
ALTER TABLE [dbo].[REPORTFORMULAS]  WITH CHECK ADD  CONSTRAINT [FK_REPORTFORMULAS_REPORTS] FOREIGN KEY([RID])
REFERENCES [dbo].[REPORTS] ([RID])
ALTER TABLE [dbo].[REPORTFORMULAS] CHECK CONSTRAINT [FK_REPORTFORMULAS_REPORTS]