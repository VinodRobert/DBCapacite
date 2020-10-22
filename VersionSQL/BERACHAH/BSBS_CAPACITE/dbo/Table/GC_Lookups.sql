/****** Object:  Table [dbo].[GC_Lookups]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[GC_Lookups](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[LookupName] [nvarchar](100) NOT NULL,
	[SchemaName] [nvarchar](100) NULL,
	[TableName] [nvarchar](100) NOT NULL,
	[ColumnID] [int] NOT NULL,
	[Field] [nvarchar](100) NOT NULL,
	[Visible] [bit] NOT NULL,
	[DefaultName] [nvarchar](100) NOT NULL,
	[DataType] [nvarchar](100) NULL,
	[Filter] [nvarchar](100) NULL,
 CONSTRAINT [PK_GC_Lookups] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[GC_Lookups] ADD  CONSTRAINT [DF_GC_Lookups_Visible]  DEFAULT (N'0') FOR [Visible]