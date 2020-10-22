/****** Object:  Procedure [BT].[spEquipmentLogSummaryReport]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BT].[spEquipmentLogSummaryReport](@PROJECTCODE INT, @STARTDATESTRING VARCHAR(15), @ENDDATESTRING VARCHAR(15))
AS

DECLARE @D1 DATETIME 
DECLARE @D2 DATETIME
DECLARE @S  DECIMAL(18,2) 
DECLARE @E  DECIMAL(18,2) 
DECLARE @BH DECIMAL(18,2)
DECLARE @IH DECIMAL(18,2) 
DECLARE @DAYSBETWEEN INT 

DECLARE @FIRST DATETIME 
DECLARE @LAST  DATETIME 
DECLARE @ID  INT 
DECLARE @EQUIPMENTID INT


DECLARE @STARTREADING DECIMAL(18,2)
DECLARE @ENDREADING DECIMAL(18,2)
DECLARE @TOTALREADING DECIMAL(18,2)

DECLARE @IDLEHOURS DECIMAL(18,2)
DECLARE @BREAKDOWNHOURS DECIMAL(18,2) 

SET @D1 = CONVERT(DATETIME,@STARTDATESTRING,103)
SET @D2 = CONVERT(DATETIME,@ENDDATESTRING,103) 

CREATE TABLE #DATES (DPRDATE DATETIME) 

CREATE TABLE #TEMP0(ID INT IDENTITY(1,1),EQUIPMENTID INT,
EQUIPNAME VARCHAR(200),MAKE VARCHAR(50),MODEL VARCHAR(50),CAPACITY VARCHAR(50),TYPE VARCHAR(50),
EQUIPNUMBER VARCHAR(15),CHECKINDATE DATETIME, CHECKOUTDATE DATETIME,
SHIFTS INT,HOURSPERSHIFT INT,WORKINGDAYS INT,SUNDAYS INT,SHIFTHRSINPERIOD INT,
STARTREADING INT,ENDREADING INT,TOTALREADING INT,BREAKDOWNHOURS DECIMAL(18,2), IDLEHOURS DECIMAL(18,2),
AVAILABLEHOURS DECIMAL(18,2),AVAILABILITY DECIMAL(18,2),UTLIZATION  DECIMAL(18,2),BREAKDOWN DECIMAL(18,2) )

 
INSERT INTO #TEMP0 
SELECT 
 EQUIPMENTID,
 EQUIPNAME,
 MAKE,
 MODEL,
 CAPACITY,
 TYPE,
 EQUIPNUMBER,
 CHECKINDATE,
 CHECKOUTDATE,
 SHIFTS  ,
 HOURSPERSHIFT,
 0,0,0,0,0,0,0,0,0,0,0,0
FROM 
 BT.EQUIPMENTMASTER
WHERE 
 PROJECTCODE=@PROJECTCODE AND
 OWNERID  = 1 
 
UPDATE #TEMP0 SET CHECKOUTDATE = @D2 WHERE CHECKOUTDATE IS NULL




 
 

DECLARE EQUIPS CURSOR FOR
SELECT ID,EQUIPMENTID FROM #TEMP0 

OPEN  EQUIPS 
FETCH NEXT FROM EQUIPS INTO @ID,@EQUIPMENTID 

WHILE @@FETCH_STATUS = 0
BEGIN
  INSERT INTO #DATES 
  SELECT DPRDATE  FROM BT.DPRMACHINERY WHERE PROJECTCODE=2 AND EQUIPMENTCODE=@EQUIPMENTID ORDER BY DPRDATE 
  DELETE FROM #DATES WHERE DPRDATE < @D1 
  DELETE FROM #DATES WHERE DPRDATE > @D2
  SELECT @FIRST = MIN(DPRDATE) FROM #DATES 
  SELECT @LAST = MAX(DPRDATE) FROM #DATES 

  SELECT @STARTREADING = MIN(STARTREADING) FROM BT.DPRMACHINERY WHERE 
  DPRDATE BETWEEN @FIRST AND @LAST   AND PROJECTCODE=2 AND EQUIPMENTCODE=@EQUIPMENTID AND  STARTREADING<>0
  SELECT @ENDREADING = MAX(ENDREADING) FROM BT.DPRMACHINERY WHERE 
  DPRDATE BETWEEN @FIRST AND @LAST AND PROJECTCODE=2 AND EQUIPMENTCODE=@EQUIPMENTID AND  ENDREADING<>0
  
  DELETE FROM #DATES 

  SELECT @IDLEHOURS = SUM(IDLEHOURS) FROM BT.DPRMACHINERY WHERE DPRDATE 
  BETWEEN @FIRST AND @LAST AND EQUIPMENTCODE=@EQUIPMENTID AND PROJECTCODE=2 

  SELECT @BREAKDOWNHOURS = SUM(BREAKDOWNHOURS) FROM  BT.DPRMACHINERY WHERE DPRDATE 
  BETWEEN @FIRST AND @LAST AND EQUIPMENTCODE=@EQUIPMENTID AND PROJECTCODE=2 

  UPDATE #TEMP0 SET CHECKINDATE=@FIRST,CHECKOUTDATE=@LAST, STARTREADING = @STARTREADING , 
  ENDREADING = @ENDREADING , IDLEHOURS = @IDLEHOURS, BREAKDOWNHOURS = @BREAKDOWNHOURS 
  WHERE ID = @ID 
  

  FETCH NEXT FROM EQUIPS INTO @ID,@EQUIPMENTID 
END 
CLOSE EQUIPS
DEALLOCATE EQUIPS 

UPDATE #TEMP0 SET TOTALREADING = ENDREADING - STARTREADING 

UPDATE #TEMP0 SET WORKINGDAYS = DATEDIFF(DAY, CHECKINDATE, CHECKOUTDATE)  

UPDATE #TEMP0 SET SUNDAYS =   BT.NumberOfSundays(CHECKINDATE,CHECKOUTDATE)

UPDATE #TEMP0 SET SHIFTHRSINPERIOD = SHIFTS * HOURSPERSHIFT * ( WORKINGDAYS - SUNDAYS)


UPDATE #TEMP0 SET AVAILABLEHOURS = SHIFTHRSINPERIOD - BREAKDOWNHOURS 

UPDATE #TEMP0 SET AVAILABILITY = (AVAILABLEHOURS/SHIFTHRSINPERIOD) * 100 

UPDATE #TEMP0 SET UTLIZATION = (TOTALREADING /AVAILABLEHOURS ) * 100 

UPDATE #TEMP0 SET BREAKDOWN = ( BREAKDOWNHOURS / SHIFTHRSINPERIOD )  * 100 

SELECT 
EQUIPMENTID,EQUIPNAME,MAKE,MODEL,CAPACITY,TYPE,EQUIPNUMBER,CHECKINDATE,CHECKOUTDATE,SHIFTS,HOURSPERSHIFT,WORKINGDAYS,SUNDAYS,SHIFTHRSINPERIOD,
STARTREADING,ENDREADING,TOTALREADING,BREAKDOWNHOURS,IDLEHOURS,AVAILABLEHOURS,AVAILABILITY,UTLIZATION,BREAKDOWN
FROM #TEMP0  ORDER BY EQUIPNAME 

 

 
 