/****** Object:  Procedure [BT].[spLoginWeb]    Committed by VersionSQL https://www.versionsql.com ******/

--[BT].[spLoginwEB] 'VINOD',1,2
CREATE  PROCEDURE [BT].[spLoginWeb](@LOGINID  VARCHAR(15),@PWD VARCHAR(15),@PROJECTID INT)
AS
-- Searching Main Table (Outside BMT) to make sure this user is a Valid User
DECLARE @VALIDUSER INT 
DECLARE @ACCESSTOPROJECT INT 
DECLARE @PROJECTNAME VARCHAR(150)
SELECT @VALIDUSER = COUNT(*) FROM USERS WHERE LOGINID=@LOGINID AND PASSWORD=@PWD

IF @VALIDUSER >= 1
 BEGIN
  -- Check whether he is having Rights in the Project Opted
  SELECT @ACCESSTOPROJECT = COUNT(*) FROM BT.BMTUSERMENUS_WEB WHERE LOGINID=@LOGINID AND PROJECTID=@PROJECTID 
  IF @ACCESSTOPROJECT = 0 
     SELECT 0 as IsValid,'INVALID' as [Status],null AS PROJECTNAME
  ELSE
   BEGIN
  SELECT @PROJECTNAME=ProjectName FROM BT.PROJECTS WHERE PROJECTID=@PROJECTID
     SELECT 1 AS ISVALID,'VALID' as [Status], @PROJECTNAME AS PROJECTNAME
     SELECT  P.MENUINDEX,P.MENULEVEL,P.PARENTMENUID,P.MENUID,P.POSITIONINDEX,P.MENUNAME AS PARENTNAME,C.CONTROLLER,C.[ACTION],C.MENUNAME,gc.MENUNAME as MAINMENUNAME
	 FROM BT.BMTMENUS_WEB P LEFT JOIN BT.BMTMENUS_WEB C ON P.MENUID=C.PARENTMENUID AND C.PARENTMENUID<>0 AND P.PARENTMENUID<>0
	 LEFT JOIN BT.BMTMENUS_WEB gC ON P.PARENTMENUID=gC.MENUID
     WHERE P.MENUINDEX IN (SELECT MENUID FROM BT.BMTUSERMENUS_WEB WHERE LOGINID=@LOGINID AND PROJECTID=@PROJECTID)
     ORDER BY POSITIONINDEX
   END
 END
ELSE
    SELECT 0 as IsValid,'INVALID' as [Status],null AS PROJECTNAME