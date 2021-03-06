/****** Object:  Table [dbo].[ATTRIBDEFINITION]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ATTRIBDEFINITION](
	[TABLENAME] [nvarchar](55) NOT NULL,
	[ATTRIBUTE] [nvarchar](55) NOT NULL,
	[COLTYPE] [nvarchar](55) NOT NULL,
	[COLSIZE] [nvarchar](55) NULL,
	[COLDEFAULT] [nvarchar](55) NULL,
	[ISDROPDOWN] [bit] NOT NULL,
	[ISREQUIRED] [bit] NOT NULL,
	[ISREPORTFILTER] [bit] NOT NULL,
	[ISSEARCH] [bit] NOT NULL,
	[ISGROUPHEADER] [bit] NOT NULL,
	[ISMASTERCOLUMN] [bit] NOT NULL,
	[ISMASTEREDITABLE] [bit] NOT NULL,
	[EXISTINGCOLNAME] [nvarchar](55) NULL,
	[ISACTIVE] [bit] NOT NULL,
	[ISARRAY] [int] NOT NULL,
	[Application] [char](3) NOT NULL,
	[IsSystemAttribute] [bit] NOT NULL,
	[IsSystemEditable] [bit] NOT NULL,
 CONSTRAINT [PK_ATTRIBDEFINITION] PRIMARY KEY CLUSTERED 
(
	[TABLENAME] ASC,
	[ATTRIBUTE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ATTRIBDEFINITION] ADD  CONSTRAINT [DF_ATTRIBDEFINITION_TABLENAME]  DEFAULT ('') FOR [TABLENAME]
ALTER TABLE [dbo].[ATTRIBDEFINITION] ADD  CONSTRAINT [DF_ATTRIBDEFINITION_ATTRIBUTE]  DEFAULT ('') FOR [ATTRIBUTE]
ALTER TABLE [dbo].[ATTRIBDEFINITION] ADD  CONSTRAINT [DF_ATTRIBDEFINITION_COLTYPE]  DEFAULT ('') FOR [COLTYPE]
ALTER TABLE [dbo].[ATTRIBDEFINITION] ADD  CONSTRAINT [DF_ATTRIBDEFINITION_COLSIZE]  DEFAULT ('') FOR [COLSIZE]
ALTER TABLE [dbo].[ATTRIBDEFINITION] ADD  CONSTRAINT [DF_ATTRIBDEFINITION_COLDEFAULT]  DEFAULT ('') FOR [COLDEFAULT]
ALTER TABLE [dbo].[ATTRIBDEFINITION] ADD  CONSTRAINT [DF_ATTRIBDEFINITION_ISDROPDOWN]  DEFAULT ('0') FOR [ISDROPDOWN]
ALTER TABLE [dbo].[ATTRIBDEFINITION] ADD  CONSTRAINT [DF_ATTRIBDEFINITION_ISREQUIRED]  DEFAULT ('0') FOR [ISREQUIRED]
ALTER TABLE [dbo].[ATTRIBDEFINITION] ADD  CONSTRAINT [DF_ATTRIBDEFINITION_ISREPORTFILTER]  DEFAULT ('0') FOR [ISREPORTFILTER]
ALTER TABLE [dbo].[ATTRIBDEFINITION] ADD  CONSTRAINT [DF_ATTRIBDEFINITION_ISSEARCH]  DEFAULT ('0') FOR [ISSEARCH]
ALTER TABLE [dbo].[ATTRIBDEFINITION] ADD  CONSTRAINT [DF_ATTRIBDEFINITION_ISGROUPHEADER]  DEFAULT ('0') FOR [ISGROUPHEADER]
ALTER TABLE [dbo].[ATTRIBDEFINITION] ADD  CONSTRAINT [DF_ATTRIBDEFINITION_ISMASTERCOLUMN]  DEFAULT ('0') FOR [ISMASTERCOLUMN]
ALTER TABLE [dbo].[ATTRIBDEFINITION] ADD  CONSTRAINT [DF_ATTRIBDEFINITION_ISMASTEREDITABLE]  DEFAULT ('0') FOR [ISMASTEREDITABLE]
ALTER TABLE [dbo].[ATTRIBDEFINITION] ADD  CONSTRAINT [DF_ATTRIBDEFINITION_EXISTINGCOLNAME]  DEFAULT ('') FOR [EXISTINGCOLNAME]
ALTER TABLE [dbo].[ATTRIBDEFINITION] ADD  CONSTRAINT [DF_ATTRIBDEFINITION_ISACTIVE]  DEFAULT ('0') FOR [ISACTIVE]
ALTER TABLE [dbo].[ATTRIBDEFINITION] ADD  CONSTRAINT [DF_ATTRIBDEFINITION_ISARRAY]  DEFAULT ((0)) FOR [ISARRAY]
ALTER TABLE [dbo].[ATTRIBDEFINITION] ADD  CONSTRAINT [DF_ATTRIBDEFINITION_Application]  DEFAULT ('ACC') FOR [Application]
ALTER TABLE [dbo].[ATTRIBDEFINITION] ADD  CONSTRAINT [DF_ATTRIBDEFINITION_IsSystemAttribute]  DEFAULT (N'0') FOR [IsSystemAttribute]
ALTER TABLE [dbo].[ATTRIBDEFINITION] ADD  CONSTRAINT [DF_ATTRIBDEFINITION_IsSystemEditable]  DEFAULT (N'1') FOR [IsSystemEditable]