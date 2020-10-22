/****** Object:  Table [dbo].[CATEGORIESSUPPERFQ]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CATEGORIESSUPPERFQ](
	[CATID] [int] NOT NULL,
	[SUPPID] [int] NOT NULL,
	[ERFQID] [int] NOT NULL,
	[ACTIVE] [bit] NOT NULL,
	[FAXNOTIFRPT] [ntext] NOT NULL,
	[SUPPDELHIMSELF] [bit] NOT NULL,
 CONSTRAINT [PK_CATEGORIESSUPPERFQ] PRIMARY KEY CLUSTERED 
(
	[CATID] ASC,
	[SUPPID] ASC,
	[ERFQID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[CATEGORIESSUPPERFQ] ADD  CONSTRAINT [DF_CATEGORIESSUPPERFQ_ACTIVE]  DEFAULT ((1)) FOR [ACTIVE]
ALTER TABLE [dbo].[CATEGORIESSUPPERFQ] ADD  CONSTRAINT [DF_CATEGORIESSUPPERFQ_FAXNOTIFRPT]  DEFAULT ('No Notification Report Received Yet') FOR [FAXNOTIFRPT]
ALTER TABLE [dbo].[CATEGORIESSUPPERFQ] ADD  CONSTRAINT [DF_CATEGORIESSUPPERFQ_SUPPDELHIMSELF]  DEFAULT ((0)) FOR [SUPPDELHIMSELF]
ALTER TABLE [dbo].[CATEGORIESSUPPERFQ]  WITH CHECK ADD  CONSTRAINT [FK_CATEGORIESSUPPERFQ_CATEGORIESTYPE] FOREIGN KEY([CATID])
REFERENCES [dbo].[CATEGORIESTYPE] ([CATID])
ALTER TABLE [dbo].[CATEGORIESSUPPERFQ] CHECK CONSTRAINT [FK_CATEGORIESSUPPERFQ_CATEGORIESTYPE]
ALTER TABLE [dbo].[CATEGORIESSUPPERFQ]  WITH CHECK ADD  CONSTRAINT [FK_CATEGORIESSUPPERFQ_ERFQS] FOREIGN KEY([ERFQID])
REFERENCES [dbo].[ERFQS] ([ERFQID])
ALTER TABLE [dbo].[CATEGORIESSUPPERFQ] CHECK CONSTRAINT [FK_CATEGORIESSUPPERFQ_ERFQS]
ALTER TABLE [dbo].[CATEGORIESSUPPERFQ]  WITH CHECK ADD  CONSTRAINT [FK_CATEGORIESSUPPERFQ_SUPPLIERS] FOREIGN KEY([SUPPID])
REFERENCES [dbo].[SUPPLIERS] ([SUPPID])
ALTER TABLE [dbo].[CATEGORIESSUPPERFQ] CHECK CONSTRAINT [FK_CATEGORIESSUPPERFQ_SUPPLIERS]