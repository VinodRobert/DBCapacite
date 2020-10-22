/****** Object:  View [dbo].[POS_User_Admin_Roles]    Committed by VersionSQL https://www.versionsql.com ******/

 
CREATE VIEW POS_User_Admin_Roles as 
SELECT USERS.USERID [User ID], USERS.LOGINID [Login ID], USERS.USERNAME [User Name], ROLEHEADERA.ROLENAME AS [Admin Role]
FROM USERS 
INNER JOIN ROLEHEADERA ON USERS.ROLEIDA = ROLEHEADERA.ROLEID
WHERE USERS.ROLEIDA <> - 1