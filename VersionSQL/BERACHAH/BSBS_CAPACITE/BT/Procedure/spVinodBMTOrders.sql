/****** Object:  Procedure [BT].[spVinodBMTOrders]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE BT.spVinodBMTOrders
as

SELECT REQID INTO #REQIDS 
FROM REQ WHERE BORGID=188 AND REQID>=305777 AND RECTYPE='STD'  ORDER BY REQID 



CREATE TABLE #REQMASTER(REQID INT PRIMARY KEY ,REQNUMBER VARCHAR(35), REQDATE DATETIME,REQSTATUSID INT)
INSERT INTO #REQMASTER(REQID,REQNUMBER,REQDATE,REQSTATUSID) 
SELECT REQID,REQNUMBER,CREATEDATE,REQSTATUSID FROM REQ 
WHERE REQID IN (SELECT REQID FROM #REQIDS) 

CREATE TABLE #REQDETAILS(REQID INT,LINENUMBER INT,CATALOGITEMID INT,ITEMDESCRIPTION VARCHAR(255),BUYERPARTNUMBER VARCHAR(25),UOM VARCHAR(15),QTY DECIMAL(18,4), RATE DECIMAL(18,2))
INSERT INTO #REQDETAILS(REQID,LINENUMBER,CATALOGITEMID,ITEMDESCRIPTION,BUYERPARTNUMBER,UOM,QTY,RATE)
SELECT REQID,LINENUMBER,CATALOGITEMID,ITEMDESCRIPTION,BUYERPARTNUMBER,UOM,QTY,PRICE 
FROM REQITEMS WHERE REQID IN (SELECT REQID FROM #REQMASTER) 
UPDATE #REQDETAILS SET ITEMDESCRIPTION = UPPER(ITEMDESCRIPTION) 

DELETE FROM #REQDETAILS WHERE CATALOGITEMID=-1
DELETE FROM #REQDETAILS WHERE ITEMDESCRIPTION LIKE 'FREIGHT CHARGES%'
DELETE FROM #REQDETAILS WHERE ITEMDESCRIPTION ='PACKING AND FORWARDING CHARGES'
DELETE FROM #REQDETAILS WHERE ITEMDESCRIPTION LIKE 'TRANSPORT CHARGES%'
DELETE FROM #REQDETAILS WHERE ITEMDESCRIPTION LIKE 'PUMPING CHARGES%'






CREATE TABLE #ORDMASTER(ORDID INT PRIMARY KEY,ORDNUMBER VARCHAR(35), ORDDATE DATETIME, ORDSTATUSID INT,REQID INT) 
INSERT INTO #ORDMASTER(ORDID,ORDNUMBER,ORDDATE,ORDSTATUSID,REQID) 
SELECT ORDID,ORDNUMBER,CREATEDATE,ORDSTATUSID,REQID
FROM ORD 
WHERE REQID IN (SELECT REQID FROM #REQMASTER) 

CREATE TABLE #ORDDETAILS(ORDID INT,LINENUMBER INT,ITEMDESCRIPTION VARCHAR(255), BUYERPARTNUMBER VARCHAR(25), UOM VARCHAR(10),QTY DECIMAL(18,4), RATE DECIMAL(18,2) )
INSERT INTO #ORDDETAILS(ORDID,LINENUMBER,ITEMDESCRIPTION,BUYERPARTNUMBER,UOM,QTY,RATE) 
SELECT ORDID,LINENUMBER,ITEMDESCRIPTION,BUYERPARTNUMBER,UOM,QTY,PRICE  
FROM ORDITEMS 
WHERE ORDID IN (SELECT ORDID FROM #ORDMASTER) 

UPDATE #ORDDETAILS SET ITEMDESCRIPTION = UPPER(ITEMDESCRIPTION) 

SELECT M.REQID,M.ORDID,M.ORDNUMBER,M.ORDDATE,M.ORDSTATUSID,D.LINENUMBER,D.ITEMDESCRIPTION,D.BUYERPARTNUMBER,D.UOM,D.QTY,D.RATE 
INTO #ORD 
FROM #ORDMASTER M INNER JOIN #ORDDETAILS D ON M.ORDID = D.ORDID 

CREATE TABLE #MOVEMENT(DETAILID INT PRIMARY KEY IDENTITY(1,1),
PROJECTCODE INT,
TOOLCODE VARCHAR(15),
TOOLNAME VARCHAR(150),
BUYINGCATEGORY VARCHAR(10),
CONVERTIONFACTOR DECIMAL(18,2),
REQID INT,
REQDATE DATETIME,
REQNUMBER VARCHAR(35),
LINENUMBER INT,
STOCKCODE VARCHAR(15),
STOCKNAME VARCHAR(200),
PRQTY DECIMAL(18,4),
PRUOM VARCHAR(15),
PRRATE DECIMAL(18,2),
PRAMOUNT DECIMAL(18,2),
PRSTATUS INT,
OPEPR DECIMAL(18,4),
CANCELLEDQTY DECIMAL(18,4),
REJECTQTY DECIMAL(18,4),
BUDGETPRQTY DECIMAL(18,4),
ORDID INT,
ORDNUMBER VARCHAR(25),
ORDDATE DATETIME,
ORDQTY DECIMAL(18,4),
ORDRATE DECIMAL(18,2),
ORDAMOUNT DECIMAL(18,2),
ORDSTATUS INT,
BUDGETORDERQTY DECIMAL(18,2),
PRPOQTYDIFF DECIMAL(18,2),
BUDGETPRPODIFF DECIMAL(18,2),
DELIVERQTY DECIMAL(18,2),
DELIVERYAMOUNT DECIMAL(18,2),
BUDGETDELIVERY DECIMAL(18,2),
COMPLETED DECIMAL(18,2),
ORDCOMPDIFF DECIMAL(18,2),
BUDGETORDCOMPDIFF DECIMAL(18,2)
)
SELECT M.REQID,M.REQNUMBER,M.REQDATE,M.REQSTATUSID,D.LINENUMBER,D.CATALOGITEMID,D.ITEMDESCRIPTION,D.BUYERPARTNUMBER,D.UOM,D.QTY,D.RATE 
INTO #REQ 
FROM #REQMASTER M INNER JOIN #REQDETAILS D ON M.REQID=D.REQID 

INSERT INTO #MOVEMENT(PROJECTCODE,REQID,REQDATE,REQNUMBER,LINENUMBER,STOCKCODE,STOCKNAME,PRQTY,PRUOM,PRRATE,PRSTATUS)
SELECT 7,REQID,REQDATE,REQNUMBER,LINENUMBER,BUYERPARTNUMBER,ITEMDESCRIPTION,QTY,UOM,RATE,REQSTATUSID
FROM #REQ 

UPDATE #MOVEMENT 
SET ORDID = O.ORDID ,
    ORDNUMBER = O.ORDNUMBER,
	ORDDATE = O.ORDDATE,
	ORDQTY = O.QTY,
	ORDRATE =O.RATE ,
	ORDSTATUS = O.ORDSTATUSID
FROM #ORD O 
INNER JOIN #MOVEMENT M ON O.REQID = M.REQID AND O.LINENUMBER = M.LINENUMBER 

SELECT * FROM #MOVEMENT ORDER BY PRSTATUS 