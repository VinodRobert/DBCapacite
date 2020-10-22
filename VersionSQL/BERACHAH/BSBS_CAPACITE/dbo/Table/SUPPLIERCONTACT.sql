/****** Object:  Table [dbo].[SUPPLIERCONTACT]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[SUPPLIERCONTACT](
	[SUPPLIERID] [int] NOT NULL,
	[CONTACTID] [int] NOT NULL,
 CONSTRAINT [PK_SUPPLIERCONTACT] PRIMARY KEY CLUSTERED 
(
	[SUPPLIERID] ASC,
	[CONTACTID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[SUPPLIERCONTACT]  WITH CHECK ADD  CONSTRAINT [FK_SUPPLIERCONTACT_CONTACTS] FOREIGN KEY([CONTACTID])
REFERENCES [dbo].[CONTACTS] ([CONTACTID])
ALTER TABLE [dbo].[SUPPLIERCONTACT] CHECK CONSTRAINT [FK_SUPPLIERCONTACT_CONTACTS]
ALTER TABLE [dbo].[SUPPLIERCONTACT]  WITH CHECK ADD  CONSTRAINT [FK_SUPPLIERCONTACT_SUPPLIERS] FOREIGN KEY([SUPPLIERID])
REFERENCES [dbo].[SUPPLIERS] ([SUPPID])
ALTER TABLE [dbo].[SUPPLIERCONTACT] CHECK CONSTRAINT [FK_SUPPLIERCONTACT_SUPPLIERS]