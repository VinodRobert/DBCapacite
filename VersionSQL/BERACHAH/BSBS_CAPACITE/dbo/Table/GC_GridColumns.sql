/****** Object:  Table [dbo].[GC_GridColumns]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[GC_GridColumns](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[TableName] [nvarchar](100) NOT NULL,
	[ColumnID] [int] NOT NULL,
	[Field] [nvarchar](100) NOT NULL,
	[Alias] [nvarchar](100) NOT NULL,
	[Visible] [bit] NOT NULL,
	[Editable] [bit] NULL,
	[Updatable] [bit] NULL,
	[DefaultName] [nvarchar](100) NOT NULL,
	[DataType] [nvarchar](100) NOT NULL,
	[LookupName] [nvarchar](100) NULL,
	[LookupTargetID] [nvarchar](100) NULL,
	[SelectFilterField] [nvarchar](100) NULL,
	[AutoComplete] [bit] NULL,
	[MinLength] [int] NOT NULL,
	[MaxLength] [int] NOT NULL,
	[DefaultSort] [int] NULL,
	[DataProcedure] [nvarchar](100) NULL,
 CONSTRAINT [PK_GC_GridColumns] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[GC_GridColumns] ADD  CONSTRAINT [DF_GC_GridColumns_Visible]  DEFAULT (N'0') FOR [Visible]
ALTER TABLE [dbo].[GC_GridColumns] ADD  CONSTRAINT [DF_GC_GridColumns_Editable]  DEFAULT (N'0') FOR [Editable]
ALTER TABLE [dbo].[GC_GridColumns] ADD  CONSTRAINT [DF_GC_GridColumns_Updatable]  DEFAULT (N'0') FOR [Updatable]
ALTER TABLE [dbo].[GC_GridColumns] ADD  CONSTRAINT [DF_GC_GridColumns_AutoComplete]  DEFAULT (N'0') FOR [AutoComplete]