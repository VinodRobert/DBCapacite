/****** Object:  Table [BT].[TempMaterialSpread]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BT].[TempMaterialSpread](
	[ToolCode] [varchar](15) NOT NULL,
	[BudgetToolName] [varchar](250) NULL,
	[Category] [varchar](25) NULL,
	[UOM] [varchar](15) NULL,
	[QTY] [decimal](18, 4) NULL,
	[RATE] [decimal](18, 4) NULL,
	[AMOUNT] [decimal](18, 4) NULL,
	[1Q] [decimal](18, 4) NULL,
	[1R] [decimal](18, 2) NULL,
	[1A] [decimal](18, 2) NULL,
	[2Q] [decimal](18, 4) NULL,
	[2R] [decimal](18, 2) NULL,
	[2A] [decimal](18, 2) NULL,
	[3Q] [decimal](18, 4) NULL,
	[3R] [decimal](18, 2) NULL,
	[3A] [decimal](18, 2) NULL,
	[4Q] [decimal](18, 4) NULL,
	[4R] [decimal](18, 2) NULL,
	[4A] [decimal](18, 2) NULL,
	[5Q] [decimal](18, 4) NULL,
	[5R] [decimal](18, 2) NULL,
	[5A] [decimal](18, 2) NULL,
	[6Q] [decimal](18, 4) NULL,
	[6R] [decimal](18, 2) NULL,
	[6A] [decimal](18, 2) NULL,
	[7Q] [decimal](18, 4) NULL,
	[7R] [decimal](18, 2) NULL,
	[7A] [decimal](18, 2) NULL,
	[8Q] [decimal](18, 4) NULL,
	[8R] [decimal](18, 2) NULL,
	[8A] [decimal](18, 2) NULL,
	[9Q] [decimal](18, 4) NULL,
	[9R] [decimal](18, 2) NULL,
	[9A] [decimal](18, 2) NULL,
	[10Q] [decimal](18, 4) NULL,
	[10R] [decimal](18, 2) NULL,
	[10A] [decimal](18, 2) NULL,
	[11Q] [decimal](18, 4) NULL,
	[11R] [decimal](18, 2) NULL,
	[11A] [decimal](18, 2) NULL,
	[12Q] [decimal](18, 4) NULL,
	[12R] [decimal](18, 2) NULL,
	[12A] [decimal](18, 2) NULL,
	[13Q] [decimal](18, 4) NULL,
	[13R] [decimal](18, 2) NULL,
	[13A] [decimal](18, 2) NULL,
	[14Q] [decimal](18, 4) NULL,
	[14R] [decimal](18, 2) NULL,
	[14A] [decimal](18, 2) NULL,
	[15Q] [decimal](18, 4) NULL,
	[15R] [decimal](18, 2) NULL,
	[15A] [decimal](18, 2) NULL,
	[16Q] [decimal](18, 4) NULL,
	[16R] [decimal](18, 2) NULL,
	[16A] [decimal](18, 2) NULL,
	[17Q] [decimal](18, 4) NULL,
	[17R] [decimal](18, 2) NULL,
	[17A] [decimal](18, 2) NULL,
	[18Q] [decimal](18, 4) NULL,
	[18R] [decimal](18, 2) NULL,
	[18A] [decimal](18, 2) NULL,
	[19Q] [decimal](18, 4) NULL,
	[19R] [decimal](18, 2) NULL,
	[19A] [decimal](18, 2) NULL,
	[20Q] [decimal](18, 4) NULL,
	[20R] [decimal](18, 2) NULL,
	[20A] [decimal](18, 2) NULL,
	[21Q] [decimal](18, 4) NULL,
	[21R] [decimal](18, 2) NULL,
	[21A] [decimal](18, 2) NULL,
	[22Q] [decimal](18, 4) NULL,
	[22R] [decimal](18, 2) NULL,
	[22A] [decimal](18, 2) NULL,
	[23Q] [decimal](18, 4) NULL,
	[23R] [decimal](18, 2) NULL,
	[23A] [decimal](18, 2) NULL,
	[24Q] [decimal](18, 4) NULL,
	[24R] [decimal](18, 2) NULL,
	[24A] [decimal](18, 2) NULL,
	[25Q] [decimal](18, 4) NULL,
	[25R] [decimal](18, 2) NULL,
	[25A] [decimal](18, 2) NULL,
	[26Q] [decimal](18, 4) NULL,
	[26R] [decimal](18, 2) NULL,
	[26A] [decimal](18, 2) NULL,
	[27Q] [decimal](18, 4) NULL,
	[27R] [decimal](18, 2) NULL,
	[27A] [decimal](18, 2) NULL,
	[28Q] [decimal](18, 4) NULL,
	[28R] [decimal](18, 2) NULL,
	[28A] [decimal](18, 2) NULL,
	[29Q] [decimal](18, 4) NULL,
	[29R] [decimal](18, 2) NULL,
	[29A] [decimal](18, 2) NULL,
	[30Q] [decimal](18, 4) NULL,
	[30R] [decimal](18, 2) NULL,
	[30A] [decimal](18, 2) NULL,
	[31Q] [decimal](18, 4) NULL,
	[31R] [decimal](18, 2) NULL,
	[31A] [decimal](18, 2) NULL,
	[32Q] [decimal](18, 4) NULL,
	[32R] [decimal](18, 2) NULL,
	[32A] [decimal](18, 2) NULL,
	[33Q] [decimal](18, 4) NULL,
	[33R] [decimal](18, 2) NULL,
	[33A] [decimal](18, 2) NULL,
	[34Q] [decimal](18, 4) NULL,
	[34R] [decimal](18, 2) NULL,
	[34A] [decimal](18, 2) NULL,
	[35Q] [decimal](18, 4) NULL,
	[35R] [decimal](18, 2) NULL,
	[35A] [decimal](18, 2) NULL,
	[36Q] [decimal](18, 4) NULL,
	[36R] [decimal](18, 2) NULL,
	[36A] [decimal](18, 2) NULL,
	[37Q] [decimal](18, 4) NULL,
	[37R] [decimal](18, 2) NULL,
	[37A] [decimal](18, 2) NULL,
	[38Q] [decimal](18, 4) NULL,
	[38R] [decimal](18, 2) NULL,
	[38A] [decimal](18, 2) NULL,
	[39Q] [decimal](18, 4) NULL,
	[39R] [decimal](18, 2) NULL,
	[39A] [decimal](18, 2) NULL,
	[40Q] [decimal](18, 4) NULL,
	[40R] [decimal](18, 2) NULL,
	[40A] [decimal](18, 2) NULL,
	[41Q] [decimal](18, 4) NULL,
	[41R] [decimal](18, 2) NULL,
	[41A] [decimal](18, 2) NULL,
	[42Q] [decimal](18, 4) NULL,
	[42R] [decimal](18, 2) NULL,
	[42A] [decimal](18, 2) NULL,
	[43Q] [decimal](18, 4) NULL,
	[43R] [decimal](18, 2) NULL,
	[43A] [decimal](18, 2) NULL,
	[44Q] [decimal](18, 4) NULL,
	[44R] [decimal](18, 2) NULL,
	[44A] [decimal](18, 2) NULL,
	[45Q] [decimal](18, 4) NULL,
	[45R] [decimal](18, 2) NULL,
	[45A] [decimal](18, 2) NULL,
	[46Q] [decimal](18, 4) NULL,
	[46R] [decimal](18, 2) NULL,
	[46A] [decimal](18, 2) NULL,
	[47Q] [decimal](18, 4) NULL,
	[47R] [decimal](18, 2) NULL,
	[47A] [decimal](18, 2) NULL,
	[48Q] [decimal](18, 4) NULL,
	[48R] [decimal](18, 2) NULL,
	[48A] [decimal](18, 2) NULL,
	[49Q] [decimal](18, 4) NULL,
	[49R] [decimal](18, 2) NULL,
	[49A] [decimal](18, 2) NULL,
	[50Q] [decimal](18, 4) NULL,
	[50R] [decimal](18, 2) NULL,
	[50A] [decimal](18, 2) NULL,
	[51Q] [decimal](18, 4) NULL,
	[51R] [decimal](18, 2) NULL,
	[51A] [decimal](18, 2) NULL,
	[52Q] [decimal](18, 4) NULL,
	[52R] [decimal](18, 2) NULL,
	[52A] [decimal](18, 2) NULL,
	[53Q] [decimal](18, 4) NULL,
	[53R] [decimal](18, 2) NULL,
	[53A] [decimal](18, 2) NULL,
	[54Q] [decimal](18, 4) NULL,
	[54R] [decimal](18, 2) NULL,
	[54A] [decimal](18, 2) NULL,
	[55Q] [decimal](18, 4) NULL,
	[55R] [decimal](18, 2) NULL,
	[55A] [decimal](18, 2) NULL,
	[56Q] [decimal](18, 4) NULL,
	[56R] [decimal](18, 2) NULL,
	[56A] [decimal](18, 2) NULL,
	[57Q] [decimal](18, 4) NULL,
	[57R] [decimal](18, 2) NULL,
	[57A] [decimal](18, 2) NULL,
	[58Q] [decimal](18, 4) NULL,
	[58R] [decimal](18, 2) NULL,
	[58A] [decimal](18, 2) NULL,
	[59Q] [decimal](18, 4) NULL,
	[59R] [decimal](18, 2) NULL,
	[59A] [decimal](18, 2) NULL,
	[60Q] [decimal](18, 4) NULL,
	[60R] [decimal](18, 2) NULL,
	[60A] [decimal](18, 2) NULL,
 CONSTRAINT [PK_TempMaterialSpread] PRIMARY KEY CLUSTERED 
(
	[ToolCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]