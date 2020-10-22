/****** Object:  UserDefinedTableType [dbo].[ListWorkOrderID]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TYPE [dbo].[ListWorkOrderID] AS TABLE(
	[WORKORDERID] [bigint] NOT NULL,
	[QTY] [decimal](18, 4) NULL,
	PRIMARY KEY CLUSTERED 
(
	[WORKORDERID] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)