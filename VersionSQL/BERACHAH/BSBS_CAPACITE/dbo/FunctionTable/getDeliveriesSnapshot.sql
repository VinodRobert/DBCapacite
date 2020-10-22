/****** Object:  Function [dbo].[getDeliveriesSnapshot]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Matthew Spiller
-- Create date: 09-09-2015
-- Description:	returns Deliveries rolledback to a date
-- NOTES:
--  
-- =============================================
CREATE FUNCTION getDeliveriesSnapshot (@theDate datetime)
    RETURNS @t TABLE (
    [DLVRID] [int] NOT NULL,
    [LYEAR] [char](10) NOT NULL,
    [PERIOD] [int] NOT NULL,
    [DLVRNO] [nvarchar](55) NOT NULL,
    [GRNNO] [nvarchar](55) NOT NULL,
    [DLVRQTY] [numeric](18, 4) NOT NULL,
    [ALLOCATION] [char](25) NOT NULL,
    [ALLOCATED] [bit] NOT NULL,
    [ORDID] [int] NOT NULL,
    [DLVRDATE] [datetime] NOT NULL,
    [ORDITEMLINENO] [int] NOT NULL,
    [USERID] [int] NOT NULL,
    [RECONQTY] [decimal](18, 4) NOT NULL,
    [STORECODE] [char](15) NOT NULL,
    [DLVRCAPTDATE] [datetime] NOT NULL,
    [TBORGID] [int] NULL,
    [PRICE] [money] NULL,
    [RFDID] [int] NOT NULL 
  )
AS
BEGIN
    insert into @t
    SELECT D.DLVRID, D.LYEAR, D.PERIOD, D.DLVRNO, D.GRNNO, D.DLVRQTY, D.ALLOCATION, isnull(DS.ALLOCATED, D.ALLOCATED) ALLOCATED, D.ORDID, 
	  D.DLVRDATE, D.ORDITEMLINENO, D.USERID, 
	  isnull(DS.RECONQTY, D.RECONQTY) RECONQTY, D.STORECODE, D.DLVRCAPTDATE, D.TBORGID, D.PRICE, D.RFDID
    FROM DELIVERIES AS D
    OUTER APPLY (SELECT MIN(DS.SYSDATE) SYSDATE, DS.DLVRID FROM DELIVERIESSNAPSHOT DS WHERE DS.SYSDATE > @theDate AND DS.DLVRID = D.DLVRID GROUP BY DS.DLVRID) DSD
    LEFT OUTER JOIN DELIVERIESSNAPSHOT DS ON D.DLVRID = DS.DLVRID AND DS.SYSDATE = DSD.SYSDATE
    WHERE D.DLVRCAPTDATE <= @theDate 

	RETURN
END
		
		