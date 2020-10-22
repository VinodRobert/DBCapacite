/****** Object:  Table [dbo].[ERFQSSUPPREFNO]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ERFQSSUPPREFNO](
	[REFNOID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ERFQID] [int] NOT NULL,
	[SUPPID] [int] NOT NULL,
	[REFNO] [nvarchar](15) NOT NULL,
	[REPLYTOTAMOUNT] [money] NOT NULL,
	[LASTTCPIPADDR] [nvarchar](20) NOT NULL,
	[WHOFIRST] [nvarchar](255) NOT NULL,
	[WHENFIRST] [datetime] NOT NULL,
	[TCMIME] [nvarchar](100) NOT NULL,
	[TCFILESIZE] [int] NOT NULL,
	[TCFILE] [nvarchar](255) NOT NULL,
	[WHONEXT] [nvarchar](255) NOT NULL,
	[WHENNEXT] [datetime] NOT NULL,
	[TCSRVFILE] [nvarchar](255) NOT NULL,
	[ADDRESS] [nvarchar](150) NOT NULL,
	[TEL] [nvarchar](35) NOT NULL,
	[FAX] [nvarchar](35) NOT NULL,
	[EMAIL] [nvarchar](80) NOT NULL,
	[POSTALADDR] [nvarchar](150) NOT NULL,
	[WEB] [nvarchar](100) NOT NULL,
	[SUPPNAME] [nvarchar](55) NOT NULL,
	[CONTACTPERSON] [nvarchar](75) NOT NULL,
 CONSTRAINT [PK_ERFQSSUPPREFNO] PRIMARY KEY CLUSTERED 
(
	[REFNOID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ERFQSSUPPREFNO] ADD  CONSTRAINT [DF_ERFQSSUPPREFNO_REPLYTOTAMOUNT]  DEFAULT ((0.00)) FOR [REPLYTOTAMOUNT]
ALTER TABLE [dbo].[ERFQSSUPPREFNO] ADD  CONSTRAINT [DF_ERFQSSUPPREFNO_LASTTCPIPADDR]  DEFAULT ('xxx.xxx.xxx.xxx') FOR [LASTTCPIPADDR]
ALTER TABLE [dbo].[ERFQSSUPPREFNO] ADD  CONSTRAINT [DF_ERFQSSUPPREFNO_WHO]  DEFAULT ('') FOR [WHOFIRST]
ALTER TABLE [dbo].[ERFQSSUPPREFNO] ADD  CONSTRAINT [DF_ERFQSSUPPREFNO_WHEN]  DEFAULT (getdate()) FOR [WHENFIRST]
ALTER TABLE [dbo].[ERFQSSUPPREFNO] ADD  CONSTRAINT [DF_ERFQSSUPPREFNO_TCMIME]  DEFAULT ('') FOR [TCMIME]
ALTER TABLE [dbo].[ERFQSSUPPREFNO] ADD  CONSTRAINT [DF_ERFQSSUPPREFNO_TCFILESIZE]  DEFAULT ((0)) FOR [TCFILESIZE]
ALTER TABLE [dbo].[ERFQSSUPPREFNO] ADD  CONSTRAINT [DF_ERFQSSUPPREFNO_TCFILE]  DEFAULT ('') FOR [TCFILE]
ALTER TABLE [dbo].[ERFQSSUPPREFNO] ADD  CONSTRAINT [DF_ERFQSSUPPREFNO_WHONEXT]  DEFAULT ('') FOR [WHONEXT]
ALTER TABLE [dbo].[ERFQSSUPPREFNO] ADD  CONSTRAINT [DF_ERFQSSUPPREFNO_WHENNEXT]  DEFAULT (getdate()) FOR [WHENNEXT]
ALTER TABLE [dbo].[ERFQSSUPPREFNO] ADD  CONSTRAINT [DF_ERFQSSUPPREFNO_TCSRVFILE]  DEFAULT ('') FOR [TCSRVFILE]
ALTER TABLE [dbo].[ERFQSSUPPREFNO] ADD  CONSTRAINT [DF_ERFQSSUPPREFNO_ADDRESS]  DEFAULT ('') FOR [ADDRESS]
ALTER TABLE [dbo].[ERFQSSUPPREFNO] ADD  CONSTRAINT [DF_ERFQSSUPPREFNO_TEL]  DEFAULT ('') FOR [TEL]
ALTER TABLE [dbo].[ERFQSSUPPREFNO] ADD  CONSTRAINT [DF_ERFQSSUPPREFNO_FAX]  DEFAULT ('') FOR [FAX]
ALTER TABLE [dbo].[ERFQSSUPPREFNO] ADD  CONSTRAINT [DF_ERFQSSUPPREFNO_EMAIL]  DEFAULT ('') FOR [EMAIL]
ALTER TABLE [dbo].[ERFQSSUPPREFNO] ADD  CONSTRAINT [DF_ERFQSSUPPREFNO_POSTALADDR]  DEFAULT ('') FOR [POSTALADDR]
ALTER TABLE [dbo].[ERFQSSUPPREFNO] ADD  CONSTRAINT [DF_ERFQSSUPPREFNO_WEB]  DEFAULT ('') FOR [WEB]
ALTER TABLE [dbo].[ERFQSSUPPREFNO] ADD  CONSTRAINT [DF_ERFQSSUPPREFNO_SUPPNAME]  DEFAULT ('') FOR [SUPPNAME]
ALTER TABLE [dbo].[ERFQSSUPPREFNO] ADD  CONSTRAINT [DF_ERFQSSUPPREFNO_CONTACTPERSON]  DEFAULT ('') FOR [CONTACTPERSON]
ALTER TABLE [dbo].[ERFQSSUPPREFNO]  WITH CHECK ADD  CONSTRAINT [FK_ERFQSSUPPREFNO_ERFQS] FOREIGN KEY([ERFQID])
REFERENCES [dbo].[ERFQS] ([ERFQID])
ALTER TABLE [dbo].[ERFQSSUPPREFNO] CHECK CONSTRAINT [FK_ERFQSSUPPREFNO_ERFQS]
ALTER TABLE [dbo].[ERFQSSUPPREFNO]  WITH CHECK ADD  CONSTRAINT [FK_ERFQSSUPPREFNO_SUPPLIERS] FOREIGN KEY([SUPPID])
REFERENCES [dbo].[SUPPLIERS] ([SUPPID])
ALTER TABLE [dbo].[ERFQSSUPPREFNO] CHECK CONSTRAINT [FK_ERFQSSUPPREFNO_SUPPLIERS]