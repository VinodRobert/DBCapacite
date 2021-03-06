/****** Object:  Table [dbo].[CATEGORIESSUPP]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CATEGORIESSUPP](
	[CATID] [int] NOT NULL,
	[SUPPID] [int] NOT NULL,
 CONSTRAINT [PK_CATEGORIESSUPP] PRIMARY KEY CLUSTERED 
(
	[CATID] ASC,
	[SUPPID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CATEGORIESSUPP]  WITH CHECK ADD  CONSTRAINT [FK_CATEGORIESSUPP_CATEGORIESTYPE] FOREIGN KEY([CATID])
REFERENCES [dbo].[CATEGORIESTYPE] ([CATID])
ALTER TABLE [dbo].[CATEGORIESSUPP] CHECK CONSTRAINT [FK_CATEGORIESSUPP_CATEGORIESTYPE]
ALTER TABLE [dbo].[CATEGORIESSUPP]  WITH CHECK ADD  CONSTRAINT [FK_CATEGORIESSUPP_SUPPLIERS] FOREIGN KEY([SUPPID])
REFERENCES [dbo].[SUPPLIERS] ([SUPPID])
ALTER TABLE [dbo].[CATEGORIESSUPP] CHECK CONSTRAINT [FK_CATEGORIESSUPP_SUPPLIERS]