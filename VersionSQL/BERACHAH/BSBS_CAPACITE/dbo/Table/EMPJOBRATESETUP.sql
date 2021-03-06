/****** Object:  Table [dbo].[EMPJOBRATESETUP]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EMPJOBRATESETUP](
	[JOBCODE] [nvarchar](3) NOT NULL,
	[CONTRNUMBER] [nvarchar](10) NOT NULL,
	[RATE1] [decimal](18, 4) NOT NULL,
	[RATE2] [decimal](18, 4) NOT NULL,
 CONSTRAINT [PK_EMPJOBRATESETUP] PRIMARY KEY CLUSTERED 
(
	[JOBCODE] ASC,
	[CONTRNUMBER] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[EMPJOBRATESETUP]  WITH CHECK ADD  CONSTRAINT [FK_EMPJOBRATESETUP_CONTRACTS] FOREIGN KEY([CONTRNUMBER])
REFERENCES [dbo].[CONTRACTS] ([CONTRNUMBER])
ALTER TABLE [dbo].[EMPJOBRATESETUP] CHECK CONSTRAINT [FK_EMPJOBRATESETUP_CONTRACTS]
ALTER TABLE [dbo].[EMPJOBRATESETUP]  WITH CHECK ADD  CONSTRAINT [FK_EMPJOBRATESETUP_EMPJOBRATE] FOREIGN KEY([JOBCODE])
REFERENCES [dbo].[EMPJOBRATE] ([JOBCODE])
ALTER TABLE [dbo].[EMPJOBRATESETUP] CHECK CONSTRAINT [FK_EMPJOBRATESETUP_EMPJOBRATE]