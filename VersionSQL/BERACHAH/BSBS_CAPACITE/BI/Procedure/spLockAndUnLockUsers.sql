/****** Object:  Procedure [BI].[spLockAndUnLockUsers]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE BI.spLockAndUnLockUsers(@ACTIVEUSERIDS VARCHAR(4000), @ACTION INT )
AS
SELECT * INTO #NOTTOLOCK FROM DBO.SPLITRESULTTABLE(@ACTIVEUSERIDS)

 --ACTION =1  IS LOCK   AND ACTION = 0  IS UN LOCK 

IF @ACTION = 1  
 BEGIN 
   INSERT INTO BI.LOCKEDUSERS
   SELECT LOGINID,USERID,USERNAME,GETDATE() FROM USERS WHERE LOCKED=0 AND USERID NOT IN (SELECT VALUE FROM #NOTTOLOCK)
   UPDATE USERS SET LOCKED=1 WHERE USERID IN (SELECT USERID FROM BI.LOCKEDUSERS) 
 END