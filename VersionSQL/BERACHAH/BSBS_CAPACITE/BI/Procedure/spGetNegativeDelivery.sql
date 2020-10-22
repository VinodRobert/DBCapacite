/****** Object:  Procedure [BI].[spGetNegativeDelivery]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BI].[spGetNegativeDelivery](@CHOICE INT )
AS

SELECT B.BORGNAME,D.LYEAR,O.ORDNUMBER ,OI.ITEMDESCRIPTION, D.DLVRID,D.DLVRNO,D.GRNNO,D.DLVRQTY,D.ORDID,D.ORDITEMLINENO
INTO #NEGATIVE  
FROM DELIVERIES D 
INNER JOIN ORDITEMS OI ON D.ORDID=OI.ORDID AND D.ORDITEMLINENO = OI.LINENUMBER 
INNER JOIN ORD O ON O.ORDID=OI.ORDID  
INNER JOIN BORGS B ON D.TBORGID = B.BORGID 
WHERE D.DLVRQTY<0 AND D.ALLOCATED=0 AND D.LYEAR>=2016
ORDER BY BORGNAME,ITEMDESCRIPTION,ORDNUMBER


IF @CHOICE = 1 
 SELECT * FROM #NEGATIVE ORDER BY BORGNAME,ITEMDESCRIPTION,ORDNUMBER