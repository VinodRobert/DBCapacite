/****** Object:  Table [dbo].[GC_UserGridSettings]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[GC_UserGridSettings](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[TableName] [nvarchar](250) NOT NULL,
	[UserID] [bigint] NULL,
	[BorgID] [bigint] NULL,
	[Columns] [nvarchar](max) NULL,
	[ColumnFilters] [nvarchar](max) NULL,
	[SortColumns] [nvarchar](max) NULL,
	[PageNumber] [int] NULL,
	[RowsPerPage] [int] NULL,
	[Uri] [nvarchar](250) NULL,
	[GridInstanceID] [nvarchar](50) NULL,
 CONSTRAINT [PK_GC_UserGridSettings] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]