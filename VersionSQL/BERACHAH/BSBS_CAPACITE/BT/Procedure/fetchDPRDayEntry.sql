/****** Object:  Procedure [BT].[fetchDPRDayEntry]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BT].[fetchDPRDayEntry](@PROJECTCODE INT,@DPRDATESTRING VARCHAR(15))
AS
DECLARE @DPRDATE DATETIME 
SET @DPRDATE = CONVERT(DATETIME,@DPRDATESTRING,103)

SELECT D.BOQNUMBER,S.BOQ,S.UOM,D.DPRQTY THISDAYQTY
INTO #BOQ
FROM BT.DPR D INNER JOIN BT.SALES S ON D.BOQNUMBER=S.BOQNUMBER 
WHERE D.PROJECTCODE=@PROJECTCODE AND D.DPRDATE=@DPRDATE AND S.ProjectCode=@PROJECTCODE 


ALTER TABLE #BOQ ADD THISMONTHQTY   DECIMAL(18,2)
ALTER TABLE #BOQ ADD TODATEQTY      DECIMAL(18,2) 
ALTER TABLE #BOQ ADD RATE           DECIMAL(18,2) 

SELECT D.BOQNUMBER,SUM(D.DPRQTY) THISMONTHQTY 
INTO #THISMONTH 
FROM BT.DPR D INNER JOIN BT.SALES S ON D.BOQNUMBER=S.BOQNUMBER 
WHERE D.PROJECTCODE=@PROJECTCODE AND MONTH(D.DPRDATE)=MONTH(@DPRDATE) AND YEAR(D.DPRDATE)=YEAR(@DPRDATE) AND S.ProjectCode=@PROJECTCODE
GROUP BY D.BOQNumber

SELECT D.BOQNUMBER,SUM(D.DPRQTY) TODATEQTY
INTO #TODATEQTY
FROM BT.DPR D INNER JOIN BT.SALES S ON D.BOQNUMBER=S.BOQNUMBER 
WHERE D.PROJECTCODE=@PROJECTCODE  AND S.PROJECTCODE=@PROJECTCODE 
GROUP BY D.BOQNUMBER 

UPDATE #BOQ SET TODATEQTY = T.TODATEQTY FROM #TODATEQTY T INNER JOIN #BOQ ON #BOQ.BOQNUMBER = T.BOQNumber 
UPDATE #BOQ SET THISMONTHQTY  = T.THISMONTHQTY FROM #THISMONTH T INNER JOIN #BOQ ON #BOQ.BOQNUMBER = T.BOQNumber 
UPDATE #BOQ SET RATE = S.RATE FROM BT.SALES S INNER JOIN #BOQ ON #BOQ.BOQNUMBER = S.BOQNUMBER 

ALTER TABLE #BOQ ADD THISDAYVALUE DECIMAL(18,2)
ALTER TABLE #BOQ ADD THISMONTHVALUE DECIMAL(18,2)
ALTER TABLE #BOQ ADD TODATEVALUE DECIMAL(18,2)
ALTER TABLE #BOQ ADD PROJECTCODE INT
UPDATE #BOQ  SET THISDAYVALUE = THISDAYQTY*RATE,THISMONTHVALUE = THISMONTHQTY* RATE , TODATEVALUE = TODATEQTY*RATE 
UPDATE #BOQ SET PROJECTCODE=@PROJECTCODE 




SELECT M.SKILLNAME,DM.DPRQTY 
INTO #MANPOWER
FROM BT.ManPowerTypes M INNER JOIN BT.DPRManpower DM ON DM.MANPOWERSKILLTYPEID = M.SKILLTYPEID 
WHERE DM.PROJECTCODE=@PROJECTCODE AND DM.DPRDATE=@DPRDATE 

ALTER TABLE #MANPOWER ADD PROJECTCODE INT 
UPDATE #MANPOWER SET PROJECTCODE=@PROJECTCODE 

SELECT DN.HINDERANCES,DN.NOTES 
INTO #NOTES
FROM BT.DPRNOTES DN
WHERE DN.PROJECTCODE=@PROJECTCODE AND DN.DPRDATE=@DPRDATE 


SELECT DPRID,NARRATION
INTO #UPLOADS
FROM BT.DPRIMAGE UP
WHERE UP.PROJECTID=@PROJECTCODE AND UP.DPRDATE=@DPRDATE 

 
SELECT E.EQUIPNUMBER,E.EQUIPNAME,E.MAKE,E.MODEL,R.STARTREADING,R.ENDREADING,R.WORKINGHOURS,R.IDLEHOURS,R.BREAKDOWNHOURS 
INTO #EQUIPMENTS
FROM BT.DPRMachinery R INNER JOIN BT.EQUIPMENTMASTER E ON R.EQUIPMENTCODE=E.EQUIPMENTID 
WHERE R.PROJECTCODE=@PROJECTCODE AND R.DPRDATE=@DPRDATE 
ALTER TABLE #EQUIPMENTS ADD PROJECTCODE INT 
UPDATE #EQUIPMENTS SET PROJECTCODE=@PROJECTCODE 

CREATE TABLE #ABOUTDPR(PROJECTNAME VARCHAR(200),DPRDATE VARCHAR(15)) 
DECLARE @PROJECTNAME VARCHAR(250) 
SELECT @PROJECTNAME = P.PROJECTNAME FROM BT.PROJECTS P WHERE P.PROJECTID=@PROJECTCODE 
INSERT INTO #ABOUTDPR VALUES (@PROJECTNAME,@DPRDATESTRING)


 
 
SELECT BOQNUMBER,BOQ,UOM,RATE,THISDAYQTY,THISDAYVALUE,THISMONTHQTY,THISMONTHVALUE,TODATEQTY,TODATEVALUE  FROM #BOQ ORDER BY BOQNUMBER
SELECT * FROM #MANPOWER ORDER BY SKILLNAME
SELECT * FROM #NOTES
SELECT * FROM #UPLOADS 
SELECT * FROM #EQUIPMENTS
SELECT * FROM #ABOUTDPR
SELECT HINDERANCES FROM BT.DPRNOTES D WHERE D.PROJECTCODE=@PROJECTCODE AND D.DPRDATE=@DPRDATE 
SELECT NOTES       FROM BT.DPRNOTES D WHERE D.PROJECTCODE=@PROJECTCODE AND D.DPRDATE=@DPRDATE 
 

 