/****** Object:  Procedure [dbo].[VRCROSSCHECKPOSTINGS]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[VRCROSSCHECKPOSTINGS]
AS
DROP TABLE VRBMTCHECK

CREATE TABLE VRBMTCHECK(BORGID INT,REQID INT,REQNUMBER VARCHAR(55)
,REQDATE DATETIME,LINENUMBER INT,CATALOGITEMID INT,
ITEMDESCRIPTION VARCHAR(600),BUYERPARTNUMBER VARCHAR(25),
RESOURCECODE VARCHAR(25),
BUDGETCATEGORY VARCHAR(10),
CORRECTRESOURCECODE VARCHAR(25),
CORRECTITEMID INT
)

INSERT INTO VRBMTCHECK 
SELECT R.BORGID,R.REQID,R.REQNUMBER,R.CREATEDATE,RI.LINENUMBER,RI.CATALOGITEMID,RI.ITEMDESCRIPTION,RI.BUYERPARTNUMBER,RI.RESOURCECODE ,'U','NEW',0
FROM REQITEMS  RI INNER JOIN REQ R ON R.REQID=RI.REQID WHERE R.BORGID=188 AND RI.CATALOGITEMID<>-1  AND R.RECTYPE='STD' ORDER BY R.REQID

UPDATE VRBMTCHECK
SET CORRECTRESOURCECODE=BTM.TEMPLATECODE FROM bt.MasterMaterialDetail BTM INNER JOIN VRBMTCHECK ON VRBMTCHECK.BUYERPARTNUMBER=BTM.MATERIALCODE 



UPDATE VRBMTCHECK SET BUDGETCATEGORY = BTM.UOM FROM BT.MasterMaterialBudget BTM INNER JOIN VRBMTCHECK ON VRBMTCHECK.CORRECTRESOURCECODE =BTM.TEMPLATECODE

UPDATE VRBMTCHECK SET CORRECTITEMID = TE.ITEMID FROM TENDERITEMS TE INNER JOIN VRBMTCHECK ON VRBMTCHECK.BORGID=TE.BORG  AND VRBMTCHECK.CORRECTRESOURCECODE =TE.RESCODE

--UPDATE VRBMTCHECK SET CORRECTRESOURCECODE=RESOURCECODE WHERE   CORRECTITEMID=0 

UPDATE VRBMTCHECK SET CORRECTRESOURCECODE = '2022010000'   WHERE ITEMDESCRIPTION='ISMC 100X50mm'      

UPDATE VRBMTCHECK SET CORRECTRESOURCECODE = '2018010000'   WHERE ITEMDESCRIPTION='M.S.Pipe 40NB x 6M Medium Class.'   
UPDATE VRBMTCHECK SET CORRECTRESOURCECODE = '2015010005'   WHERE ITEMDESCRIPTION='Rapid Moisture Meter  0 to 50 With Chemical'  
UPDATE VRBMTCHECK SET CORRECTRESOURCECODE = '2015010005'   WHERE ITEMDESCRIPTION='PVC Rungs 290 x240 x12mm'  
UPDATE VRBMTCHECK SET CORRECTITEMID = TE.ITEMID FROM TENDERITEMS TE INNER JOIN VRBMTCHECK ON VRBMTCHECK.BORGID=TE.BORG  AND VRBMTCHECK.CORRECTRESOURCECODE =TE.RESCODE

--UPDATE VRBMTCHECK SET CORRECTRESOURCECODE = RESOURCECODE , CORRECTITEMID=catalogitemid  WHERE CORRECTITEMID=0

--UPDATE VRBMTCHECK SET CORRECTRESOURCECODE='2006010021'  , CORRECTITEMID=5822 WHERE CORRECTITEMID=0
SELECT * FROM VRBMTCHECK where CORRECTITEMID=0 ORDER BY LINENUMBER, ITEMDESCRIPTION 

 
UPDATE REQITEMS 
SET 
 RESOURCECODE=VRB.CORRECTRESOURCECODE,
 CATALOGITEMID = VRB.CORRECTITEMID 
 FROM VRBMTCHECK VRB INNER JOIN REQITEMS ON REQITEMS.REQID=VRB.REQID 