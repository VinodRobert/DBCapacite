/****** Object:  Table [BT].[BOQMAPTASK]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BT].[BOQMAPTASK](
	[BOQMAPTASKID] [int] IDENTITY(1,1) NOT NULL,
	[SALESID] [int] NULL,
	[TASKID] [varchar](8) NULL,
PRIMARY KEY CLUSTERED 
(
	[BOQMAPTASKID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]