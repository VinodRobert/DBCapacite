/****** Object:  Table [dbo].[ORDITEMS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ORDITEMS](
	[ORDID] [int] NOT NULL,
	[LINENUMBER] [int] NOT NULL,
	[ITEMDESCRIPTION] [nvarchar](255) NOT NULL,
	[BUYERPARTNUMBER] [nvarchar](50) NOT NULL,
	[PARTNUMBER] [nvarchar](50) NOT NULL,
	[PARTNUMBEREXT] [nvarchar](50) NOT NULL,
	[UOM] [nvarchar](25) NOT NULL,
	[QTY] [decimal](19, 4) NOT NULL,
	[PRICE] [money] NOT NULL,
	[PAYMENTID] [int] NOT NULL,
	[DLVRID] [int] NOT NULL,
	[INSTRUCTIONS] [ntext] NOT NULL,
	[VATPERC] [decimal](18, 4) NOT NULL,
	[PROJECTID] [int] NOT NULL,
	[CONTRACTID] [int] NOT NULL,
	[MIMETYPE] [nvarchar](100) NOT NULL,
	[FILESIZEINKB] [int] NOT NULL,
	[ORIGINALFILEPATH] [nvarchar](255) NOT NULL,
	[SENDTOSUPP] [bit] NOT NULL,
	[DIVISIONID] [int] NOT NULL,
	[RESOURCECODE] [nvarchar](25) NOT NULL,
	[FILEPATH] [nvarchar](255) NOT NULL,
	[DISCOUNT] [decimal](18, 4) NOT NULL,
	[ITEMSTATUSID] [int] NOT NULL,
	[LASTCHANGE] [datetime] NULL,
	[LASTCHANGEBY] [int] NULL,
	[ITEMSTATUSDATE] [datetime] NOT NULL,
	[ISFREEITEM] [bit] NOT NULL,
	[LONGDESCR] [ntext] NULL,
	[CATORTENDITEM] [int] NOT NULL,
	[ITEMID] [int] NOT NULL,
	[GLCODEID] [int] NOT NULL,
	[ACTID] [int] NOT NULL,
	[ALLOCATION] [char](25) NOT NULL,
	[PENUMBER] [char](10) NOT NULL,
	[STOCKID] [int] NOT NULL,
	[ATTMESSAGE] [nvarchar](200) NOT NULL,
	[VATID] [nvarchar](100) NOT NULL,
	[TBORGID] [int] NULL,
	[TERMS] [nvarchar](250) NOT NULL,
	[EID] [char](10) NOT NULL,
	[VATAMOUNT] [decimal](18, 4) NOT NULL,
	[STKCONVERTFLAG] [bit] NOT NULL,
	[STKBUYCONV] [numeric](18, 4) NULL,
	[WHTID] [int] NOT NULL,
	[WHTAMOUNT] [money] NOT NULL,
 CONSTRAINT [PK_ORDITEMS] PRIMARY KEY CLUSTERED 
(
	[ORDID] ASC,
	[LINENUMBER] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_ORDITEMS_ALLOCATION] ON [dbo].[ORDITEMS]
(
	[ALLOCATION] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_ORDITEMS_CONTRACTID_GLCODEID_PENUMBER] ON [dbo].[ORDITEMS]
(
	[CONTRACTID] ASC,
	[GLCODEID] ASC,
	[PENUMBER] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
ALTER TABLE [dbo].[ORDITEMS] ADD  CONSTRAINT [DF_ORDITEMS_ITEMDESCRIPTION]  DEFAULT ('') FOR [ITEMDESCRIPTION]
ALTER TABLE [dbo].[ORDITEMS] ADD  CONSTRAINT [DF_ORDITEMS_BUYERPARTNUMBER]  DEFAULT ('') FOR [BUYERPARTNUMBER]
ALTER TABLE [dbo].[ORDITEMS] ADD  CONSTRAINT [DF_ORDITEMS_SUPPPARTNUMBER]  DEFAULT ('') FOR [PARTNUMBER]
ALTER TABLE [dbo].[ORDITEMS] ADD  CONSTRAINT [DF_ORDITEMS_SUPPPARTNUMBEREXT]  DEFAULT ('') FOR [PARTNUMBEREXT]
ALTER TABLE [dbo].[ORDITEMS] ADD  CONSTRAINT [DF_ORDITEMS_UOM]  DEFAULT ('') FOR [UOM]
ALTER TABLE [dbo].[ORDITEMS] ADD  CONSTRAINT [DF_ORDITEMS_QTY]  DEFAULT (0) FOR [QTY]
ALTER TABLE [dbo].[ORDITEMS] ADD  CONSTRAINT [DF_ORDITEMS_PRICE]  DEFAULT (0) FOR [PRICE]
ALTER TABLE [dbo].[ORDITEMS] ADD  CONSTRAINT [DF_ORDITEMS_PAYMENTID]  DEFAULT ((-1)) FOR [PAYMENTID]
ALTER TABLE [dbo].[ORDITEMS] ADD  CONSTRAINT [DF_ORDITEMS_DELIVERYTOID]  DEFAULT ((-1)) FOR [DLVRID]
ALTER TABLE [dbo].[ORDITEMS] ADD  CONSTRAINT [DF_ORDITEMS_INSTRUCTIONS]  DEFAULT ('') FOR [INSTRUCTIONS]
ALTER TABLE [dbo].[ORDITEMS] ADD  CONSTRAINT [DF_ORDITEMS_VATPERC]  DEFAULT (0) FOR [VATPERC]
ALTER TABLE [dbo].[ORDITEMS] ADD  CONSTRAINT [DF_ORDITEMS_PROJECTID]  DEFAULT ((-1)) FOR [PROJECTID]
ALTER TABLE [dbo].[ORDITEMS] ADD  CONSTRAINT [DF_ORDITEMS_CONTRACTID]  DEFAULT ((-1)) FOR [CONTRACTID]
ALTER TABLE [dbo].[ORDITEMS] ADD  CONSTRAINT [DF_ORDITEMS_MIMETYPE]  DEFAULT ('') FOR [MIMETYPE]
ALTER TABLE [dbo].[ORDITEMS] ADD  CONSTRAINT [DF_ORDITEMS_FILESIZEINKB]  DEFAULT (0) FOR [FILESIZEINKB]
ALTER TABLE [dbo].[ORDITEMS] ADD  CONSTRAINT [DF_ORDITEMS_ORIGINALFILEPATH]  DEFAULT ('') FOR [ORIGINALFILEPATH]
ALTER TABLE [dbo].[ORDITEMS] ADD  CONSTRAINT [DF_ORDITEMS_SENDTOSUPP]  DEFAULT (0) FOR [SENDTOSUPP]
ALTER TABLE [dbo].[ORDITEMS] ADD  CONSTRAINT [DF_ORDITEMS_DIVISIONID]  DEFAULT ((-1)) FOR [DIVISIONID]
ALTER TABLE [dbo].[ORDITEMS] ADD  CONSTRAINT [DF_ORDITEMS_RESOURCECODE]  DEFAULT ('') FOR [RESOURCECODE]
ALTER TABLE [dbo].[ORDITEMS] ADD  CONSTRAINT [DF_ORDITEMS_FILEPATH]  DEFAULT ('') FOR [FILEPATH]
ALTER TABLE [dbo].[ORDITEMS] ADD  CONSTRAINT [DF_ORDITEMS_DISCOUNT]  DEFAULT (0) FOR [DISCOUNT]
ALTER TABLE [dbo].[ORDITEMS] ADD  CONSTRAINT [DF_ORDITEMS_ORDITEMSTATUS]  DEFAULT (163) FOR [ITEMSTATUSID]
ALTER TABLE [dbo].[ORDITEMS] ADD  CONSTRAINT [DF_ORDITEMS_ITEMSTATUSDATE]  DEFAULT (getdate()) FOR [ITEMSTATUSDATE]
ALTER TABLE [dbo].[ORDITEMS] ADD  CONSTRAINT [DF_ORDITEMS_ISFREEITEM]  DEFAULT (0) FOR [ISFREEITEM]
ALTER TABLE [dbo].[ORDITEMS] ADD  CONSTRAINT [DF_ORDITEMS_LONGDESCR]  DEFAULT ('') FOR [LONGDESCR]
ALTER TABLE [dbo].[ORDITEMS] ADD  CONSTRAINT [DF_ORDITEMS_CATORTENDITEM]  DEFAULT (1) FOR [CATORTENDITEM]
ALTER TABLE [dbo].[ORDITEMS] ADD  CONSTRAINT [DF_ORDITEMS_ITEMID]  DEFAULT ((-1)) FOR [ITEMID]
ALTER TABLE [dbo].[ORDITEMS] ADD  CONSTRAINT [DF_ORDITEMS_GLCODEID]  DEFAULT ((-1)) FOR [GLCODEID]
ALTER TABLE [dbo].[ORDITEMS] ADD  CONSTRAINT [DF_ORDITEMS_ACTID]  DEFAULT ((-1)) FOR [ACTID]
ALTER TABLE [dbo].[ORDITEMS] ADD  CONSTRAINT [DF_ORDITEMS_ALLOCATION]  DEFAULT ('Contracts') FOR [ALLOCATION]
ALTER TABLE [dbo].[ORDITEMS] ADD  CONSTRAINT [DF_ORDITEMS_PENUMBER]  DEFAULT ('') FOR [PENUMBER]
ALTER TABLE [dbo].[ORDITEMS] ADD  CONSTRAINT [DF_ORDITEMS_STOCKID]  DEFAULT ((-1)) FOR [STOCKID]
ALTER TABLE [dbo].[ORDITEMS] ADD  CONSTRAINT [DF__ORDITEMS__ATTMES__42501F7D]  DEFAULT ('') FOR [ATTMESSAGE]
ALTER TABLE [dbo].[ORDITEMS] ADD  CONSTRAINT [DF_ORDITEMS_VATID]  DEFAULT ('Z') FOR [VATID]
ALTER TABLE [dbo].[ORDITEMS] ADD  CONSTRAINT [DF_ORDITEMS_TERMS]  DEFAULT ('Current') FOR [TERMS]
ALTER TABLE [dbo].[ORDITEMS] ADD  DEFAULT ('') FOR [EID]
ALTER TABLE [dbo].[ORDITEMS] ADD  CONSTRAINT [DF_ORDITEMS_VATAMOUNT]  DEFAULT ((0)) FOR [VATAMOUNT]
ALTER TABLE [dbo].[ORDITEMS] ADD  CONSTRAINT [DF_ORDITEMS_STKCONVERTFLAG]  DEFAULT ((0)) FOR [STKCONVERTFLAG]
ALTER TABLE [dbo].[ORDITEMS] ADD  CONSTRAINT [DF_ORDITEMS_WHTID]  DEFAULT ((-1)) FOR [WHTID]
ALTER TABLE [dbo].[ORDITEMS] ADD  CONSTRAINT [DF_ORDITEMS_WHTAMOUNT]  DEFAULT ((0)) FOR [WHTAMOUNT]
ALTER TABLE [dbo].[ORDITEMS]  WITH CHECK ADD  CONSTRAINT [FK_ORDITEMS_ORD] FOREIGN KEY([ORDID])
REFERENCES [dbo].[ORD] ([ORDID])
ALTER TABLE [dbo].[ORDITEMS] CHECK CONSTRAINT [FK_ORDITEMS_ORD]
ALTER TABLE [dbo].[ORDITEMS]  WITH CHECK ADD  CONSTRAINT [FK_ORDITEMS_TBORGID] FOREIGN KEY([TBORGID])
REFERENCES [dbo].[BORGS] ([BORGID])
ALTER TABLE [dbo].[ORDITEMS] CHECK CONSTRAINT [FK_ORDITEMS_TBORGID]