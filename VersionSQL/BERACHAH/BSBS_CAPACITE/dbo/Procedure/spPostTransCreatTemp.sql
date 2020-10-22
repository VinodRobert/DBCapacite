/****** Object:  Procedure [dbo].[spPostTransCreatTemp]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Okker botes
-- Create date: 2009/05/29
-- Description:	Add a Temporary Transaction table to the BSBS_Temp database 
-- 2009-07-10 Change the default of the home ConversionRate rate from 1 to 0.
--	We need this since we write zeros to the Home Currency amount field if no currencies apply. 
--	spPostTrans use the exchange rate to calculate the home Currency amounts for the RI, WIP and Tax legs. 
--
-- =============================================
create PROCEDURE [dbo].[spPostTransCreatTemp]
	@TIndex as nvarchar(50) = '',
	@MakeLocal as bit = 0
AS
BEGIN
	
	declare @TName as nvarChar(15)

	if @MakeLocal = 1
		set @TName = '#TRANSACTIONS'
	else
		set @TName = '##TRANSACTIONS'
		
	exec('
	if EXISTS (select name from tempdb..sysobjects  where name like '''+ @TName + @TIndex +'%'')
		drop table '+ @TName + @TIndex +'
	')

	exec('
	CREATE TABLE '+ @TName + @TIndex +'( [Debug] int,
		[OrgID] [int] NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_OrgID]  DEFAULT (0),
		[Year] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_Year]  DEFAULT (''2000''),
		[Period] [int] NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_Period]  DEFAULT (1),
		[PDate] [datetime] NULL,
		[BatchRef] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_BatchRef]  DEFAULT (''''),
		[TransRef] [char](10)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_TransRef]  DEFAULT (''''),
		[MatchRef] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_MatchRef]  DEFAULT (''''),
		[TransType] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_TransType]  DEFAULT (''''),
		[Allocation] [char](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_Allocation]  DEFAULT (''Balance Sheet''),
		[LedgerCode] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_LedgerCode]  DEFAULT (''''),
		[Contract] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_Contract]  DEFAULT (''''),
		[Activity] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_Activity]  DEFAULT (''''),
		[Description] [char](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_Description]  DEFAULT (''''),
		[ForeignDescription] [char](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_ForeignDescription]  DEFAULT (''''),
		[Currency] [nvarchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_Currency]  DEFAULT (''ZAR''),
		[Debit] [money] NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_Debit]  DEFAULT (0.00),
		[Credit] [money] NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_Credit]  DEFAULT (0.00),
		[VatDebit] [money] NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_VatDebit]  DEFAULT (0.00),
		[VatCredit] [money] NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_VatCredit]  DEFAULT (0.00),
		[Credno] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_Credno]  DEFAULT (''''),
		[Store] [char](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_Store]  DEFAULT (''''),
		[Plantno] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_Plantno]  DEFAULT (''''),
		[Stockno] [char](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_Stockno]  DEFAULT (''''),
		[Quantity] [numeric](23, 4) NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_Quantity]  DEFAULT (0),
		[Unit] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_Unit]  DEFAULT (''''),
		[Rate] [money] NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_Rate]  DEFAULT (0),
		[ReqNo] [char](55) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_ReqNo]  DEFAULT (''''),
		[OrderNo] [char](55) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_OrderNo]  DEFAULT (''''),
		[Age] [int] NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_Age]  DEFAULT (0),
		[TransID] [int] IDENTITY(1,1) NOT NULL,
		[SubConTran] [char](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_SubConTran]  DEFAULT (''''),
		[VATType] [varchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_VATType]  DEFAULT (''Z''),
		[HomeCurrAmount] [money] NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_HomeCurrAmount]  DEFAULT (0),
		[ConversionDate] [datetime] NULL,
		[ConversionRate] [money] NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_ConversionRate]  DEFAULT (0),
		[PaidFor] [bit] NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_PaidFor]  DEFAULT (0),
		[PaidToDate] [money] NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_PaidToDate]  DEFAULT (0),
		[PaidThisPeriod] [money] NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_PaidThisPeriod]  DEFAULT (0),
		[WhtThisPeriod] [money] NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_WhtThisPeriod]  DEFAULT (0),
		[DiscThisPeriod] [money] NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_DiscThisPeriod]  DEFAULT (0),
		[ReconStatus] [int] NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_ReconStatus]  DEFAULT (0),
		[UserID] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_UserID]  DEFAULT (''Admin''),
		[DivID] [int] NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_DivID]  DEFAULT (3),
		[ForexVal] [money] NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_ForexVal]  DEFAULT (0),
		[HeadID] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[XGLCODE] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT (''''),
		[XVATA] [money] NOT NULL DEFAULT ((0.00)),
		[XVATT] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT (''Z''),
		[DOCNUMBER] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[WHTID] [int] NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_WHTID]  DEFAULT ((-1)),
		[FBID] [int] NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_FBID]  DEFAULT ((-1)),
		[ISREIMB] [bit] NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_ISREIMB]  DEFAULT (1),
		[ISCOSTLEG] [int] NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_ISCOSTLEG]  DEFAULT (0),
		[ISWIPLEG] [int] NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_ISWIPLEG]  DEFAULT (0),      
		[ISRILEG] [int] NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_ISRILEG]  DEFAULT (0),
		[DLVRID] [int] NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TIndex +'_DLVRID]  DEFAULT (-1) 
	 CONSTRAINT [PK_TRANSACTIONS'+ @TIndex +'] PRIMARY KEY CLUSTERED 
	(
		[TransID] ASC
	) ON [PRIMARY] )
	')	
end  
		