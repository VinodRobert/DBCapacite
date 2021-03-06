/****** Object:  Table [dbo].[CONTACTS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CONTACTS](
	[CONTACTID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Name] [nvarchar](35) NOT NULL,
	[Location] [nvarchar](55) NOT NULL,
	[Telephone] [nvarchar](35) NOT NULL,
	[Fax] [nvarchar](35) NOT NULL,
	[Email] [nvarchar](80) NOT NULL,
	[HomeBorgID] [int] NOT NULL,
	[CELL] [nvarchar](35) NOT NULL,
	[EID] [char](10) NOT NULL,
	[ISSUPPLIER] [bit] NOT NULL,
 CONSTRAINT [PK_CONTACTS] PRIMARY KEY CLUSTERED 
(
	[CONTACTID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CONTACTS] ADD  CONSTRAINT [DF_CONTACTS_CELL]  DEFAULT ('') FOR [CELL]
ALTER TABLE [dbo].[CONTACTS] ADD  CONSTRAINT [DF_CONTACTS_EID]  DEFAULT ('') FOR [EID]
ALTER TABLE [dbo].[CONTACTS] ADD  CONSTRAINT [DF__CONTACTS__ISSUPP__4B4F79D2]  DEFAULT (0) FOR [ISSUPPLIER]