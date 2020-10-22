/****** Object:  Table [dbo].[PTSLABSIND]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PTSLABSIND](
	[PTID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[PROVID] [int] NOT NULL,
	[FROMAMT] [money] NOT NULL,
	[TOAMT] [money] NOT NULL,
	[RATE] [money] NOT NULL,
 CONSTRAINT [PK_PTSLABSIND] PRIMARY KEY CLUSTERED 
(
	[PTID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PTSLABSIND]  WITH CHECK ADD  CONSTRAINT [FK_PTSLABSIND_PROVINCES] FOREIGN KEY([PROVID])
REFERENCES [dbo].[PROVINCES] ([PROVINCEID])
ON UPDATE CASCADE
ON DELETE CASCADE
ALTER TABLE [dbo].[PTSLABSIND] CHECK CONSTRAINT [FK_PTSLABSIND_PROVINCES]