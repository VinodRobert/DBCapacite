/****** Object:  Procedure [BI].[spGetLoginUsers]    Committed by VersionSQL https://www.versionsql.com ******/

create PROCEDURE [BI].[spGetLoginUsers]
AS

CREATE TABLE #TEMP0 ( MODULE VARCHAR(15), LOGINID VARCHAR(20), USERNAME VARCHAR(200), CATEGORY VARCHAR(20), BORGNAME VARCHAR(100)) 


INSERT INTO #TEMP0 
SELECT
    'ACCOUNTS' MODULE,
    LOGINID,
    UPPER(USERNAME) USERNAME,
	CATEGORY =  
      CASE USERS.LOCKED  
         WHEN 0 THEN 'Active'  
         WHEN 1 THEN 'Inactive' 
      END,  
    UPPER(BORGNAME) BORGNAME
FROM
    USERSINBORG 
	 INNER JOIN USERS ON USERSINBORG.USERID = USERS.USERID 
	 INNER JOIN BORGS ON USERSINBORG.BORGID = BORGS.BORGID
 
 
INSERT INTO #TEMP0 
SELECT
    'PURCHASE' MODULE,
    LOGINID,
    UPPER(USERNAME) USERNAME,
	CATEGORY =  
      CASE USERS.LOCKED  
         WHEN 0 THEN 'Active'  
         WHEN 1 THEN 'Inactive' 
      END,  
	  UPPER(BORGNAME) BORGNAME 
	
FROM
    USERSINBORGP 
	 INNER JOIN USERS ON USERSINBORGP.USERID = USERS.USERID 
	 INNER JOIN BORGS ON USERSINBORGP.BORGID = BORGS.BORGID
 
 SELECT * FROM #TEMP0 ORDER BY MODULE,USERNAME,BORGNAME 