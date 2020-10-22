/****** Object:  Table [dbo].[PLANTMATERIALS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PLANTMATERIALS](
	[CODE] [nvarchar](10) NOT NULL,
	[VALUE] [nvarchar](250) NOT NULL,
 CONSTRAINT [PK_PLANTMATERIALS] PRIMARY KEY CLUSTERED 
(
	[CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PLANTMATERIALS] ADD  CONSTRAINT [DF_PLANTMATERIALS_CODE]  DEFAULT ('') FOR [CODE]
ALTER TABLE [dbo].[PLANTMATERIALS] ADD  CONSTRAINT [DF_PLANTMATERIALS_VALUE]  DEFAULT ('') FOR [VALUE]