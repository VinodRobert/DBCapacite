/****** Object:  Procedure [BI].[spPeriodPermanentLockStatus]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BI].[spPeriodPermanentLockStatus](@FINYEAR INT) 
as



CREATE TABLE #FINAL(ORGID INT, BORGNAME VARCHAR(50),APRIL VARCHAR(6), MAY VARCHAR(6), JUNE VARCHAR(6), JULY VARCHAR(6), AUGUST VARCHAR(6), SEPTEMBER VARCHAR(6), OCTOBER VARCHAR(6), NOVEMBER VARCHAR(6), DECEMBER VARCHAR(6), JANUARY VARCHAR(6), FEBRUARY VARCHAR(6), MARCH VARCHAR(6) ) 

INSERT INTO #FINAL(ORGID) 
  SELECT DISTINCT ORGID FROM PERIODSETUP WHERE YEAR=@FINYEAR 

DELETE FROM #FINAL WHERE ORGID IN (22,23,24,26,27)
DELETE FROM #FINAL WHERE LEFT(BORGNAME,1)<>'9' 

UPDATE #FINAL SET BORGNAME = LEFT(B.BORGNAME,50) FROM BORGS B INNER JOIN #FINAL ON #FINAL.ORGID=B.BORGID 

UPDATE #FINAL SET JANUARY = '' , FEBRUARY='', MARCH='',APRIL='' ,MAY='' , JUNE='', JULY ='', AUGUST='', SEPTEMBER='', OCTOBER='', NOVEMBER='',DECEMBER=''

UPDATE #FINAL SET APRIL='Open'  WHERE ORGID  IN (SELECT ORGID  FROM PERIODSETUP  WHERE YEAR=@FINYEAR AND  STATUS=0 AND DESCR='April' )
 
UPDATE #FINAL SET MAY='Open'  WHERE ORGID  IN (SELECT ORGID  FROM PERIODSETUP  WHERE YEAR=@FINYEAR AND  STATUS=0 AND DESCR='May' )

UPDATE #FINAL SET JUNE='Open'  WHERE ORGID  IN (SELECT ORGID  FROM PERIODSETUP  WHERE YEAR=@FINYEAR AND  STATUS=0 AND DESCR='June' )
 
UPDATE #FINAL SET JULY ='Open'  WHERE ORGID  IN (SELECT ORGID  FROM PERIODSETUP  WHERE YEAR=@FINYEAR AND  STATUS=0 AND DESCR='July' )

UPDATE #FINAL SET AUGUST='Open'  WHERE ORGID  IN (SELECT ORGID  FROM PERIODSETUP  WHERE YEAR=@FINYEAR AND  STATUS=0 AND DESCR='August' )
 
UPDATE #FINAL SET SEPTEMBER ='Open'  WHERE ORGID  IN (SELECT ORGID  FROM PERIODSETUP  WHERE YEAR=@FINYEAR AND  STATUS=0 AND DESCR='September' )


UPDATE #FINAL SET OCTOBER='Open'  WHERE ORGID  IN (SELECT ORGID  FROM PERIODSETUP  WHERE YEAR=@FINYEAR AND  STATUS=0 AND DESCR='October' )
 
UPDATE #FINAL SET NOVEMBER ='Open'  WHERE ORGID  IN (SELECT ORGID  FROM PERIODSETUP  WHERE YEAR=@FINYEAR AND  STATUS=0 AND DESCR='November' )

UPDATE #FINAL SET DECEMBER='Open'  WHERE ORGID  IN (SELECT ORGID  FROM PERIODSETUP  WHERE YEAR=@FINYEAR AND  STATUS=0 AND DESCR='December' )
 
UPDATE #FINAL SET JANUARY ='Open'  WHERE ORGID  IN (SELECT ORGID  FROM PERIODSETUP  WHERE YEAR=@FINYEAR AND  STATUS=0 AND DESCR='January' )

UPDATE #FINAL SET FEBRUARY='Open'  WHERE ORGID  IN (SELECT ORGID  FROM PERIODSETUP  WHERE YEAR=@FINYEAR AND  STATUS=0 AND DESCR='February' )
 
UPDATE #FINAL SET MARCH ='Open'  WHERE ORGID  IN (SELECT ORGID  FROM PERIODSETUP  WHERE YEAR=@FINYEAR AND  STATUS=0 AND DESCR='March' )



SELECT * FROM #FINAL ORDER BY  ORGID 