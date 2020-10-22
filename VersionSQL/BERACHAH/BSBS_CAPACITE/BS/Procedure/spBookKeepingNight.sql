/****** Object:  Procedure [BS].[spBookKeepingNight]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE   PROCEDURE [BS].[spBookKeepingNight]
as
UPDATE TRANSACTIONS SET SUBCONTRAN='Payment' WHERE 
  LEDGERCODE='1320000' AND LEFT(TRANSTYPE,3) IN ('CBC','CBD', 'PCP','PCD') and  SubContran=''

UPDATE SUBCONTRACTORS SET SubContact = SUBSTRING(SUBCONTACT,1,10)  where SubContact=''
UPDATE ACCBOQDETAIL SET description = SUBSTRING( DESCRIPTION , 1 ,254 ) where detailid>626297 
-- REMOVAL OF DUPLICATE ENTRIES IN WORK ORDER RECONS
EXEC [BS].[spSUBCRECONS] 

-- If Remark is having single quote this will get replaced by space
UPDATE SUBCRECONS 
SET REMARK = REPLACE(REMARK,'''',' ')

-- Asset Location Updation 
--UPDATE ASSETS SET ASSETLOCATION = AV.VALUE FROM ATTRIBVALUE AV INNER JOIN ASSETS ON ASSETS.ASSETID=AV.COLKEY WHERE AV.TABLENAME='ASSETS' AND ATTRIBUTE='Located'

EXEC [BS].[spUpdateGSTPercentage]

DELETE  FROM CONTRAS WHERE RECONHISTID<>-1

UPDATE TRANSACTIONS SET TRANSREFEXT = TRANSREF WHERE TRANSREFEXT=''   
UPDATE TRANSACTIONS SET TRANSREFEXT = TRANSREF  WHERE TRANSREFEXT  IS NULL 
--- Updating Sub COntractor Contra Invoice Numbers 
EXEC BS.spAssignContraInvoice

update subcontractors set subselect=left(subtype,5) 

-- UPDATE LAST PURCHASE RATE 
EXEC BT.spUpdateLastPurchaseRate