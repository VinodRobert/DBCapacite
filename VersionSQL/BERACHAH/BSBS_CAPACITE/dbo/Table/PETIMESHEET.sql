/****** Object:  Table [dbo].[PETIMESHEET]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PETIMESHEET](
	[PENUMBERID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[PENUMBER] [char](10) NOT NULL,
	[SHIFT] [char](10) NOT NULL,
	[DATE] [datetime] NOT NULL,
	[TIME] [char](10) NULL,
	[SMR1] [nchar](10) NULL,
	[SMR2] [nchar](10) NULL,
	[SMR3] [nchar](10) NULL,
	[SMR4] [nchar](10) NULL,
	[SMR5] [nchar](10) NULL,
	[SMR6] [nchar](10) NULL,
	[SMR7] [nchar](10) NULL,
	[SMR8] [nchar](10) NULL,
	[SMR9] [nchar](10) NULL,
	[HireHNumber] [char](10) NULL,
 CONSTRAINT [PK_PETIMESHEET] PRIMARY KEY CLUSTERED 
(
	[PENUMBERID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PETIMESHEET] ADD  CONSTRAINT [DF_PETIMESHEET_PENUMBER]  DEFAULT ('') FOR [PENUMBER]
ALTER TABLE [dbo].[PETIMESHEET] ADD  CONSTRAINT [DF_PETIMESHEET_SHIFT]  DEFAULT ('') FOR [SHIFT]
ALTER TABLE [dbo].[PETIMESHEET] ADD  CONSTRAINT [DF_PETIMESHEET_DATE]  DEFAULT (getdate()) FOR [DATE]