/****** Object:  View [dbo].[POS_ACCESS_PER_ADMINROLE]    Committed by VersionSQL https://www.versionsql.com ******/

 
CREATE VIEW POS_ACCESS_PER_ADMINROLE as 
SELECT ROLEHEADERA.ROLENAME, ROLETEMPLATEA.ITEMCATEGORY [Group], ROLETEMPLATEA.ITEMACTION [Action], 
ROLETEMPLATEA.ITEMDESCRIPTION [Description], ROLETEMPLATEA.ITEMPOSITION, ROLEDETAILSA.ITEMENABLED [Active]
FROM ROLEDETAILSA 
INNER JOIN ROLEHEADERA ON ROLEDETAILSA.ROLEID = ROLEHEADERA.ROLEID 
INNER JOIN ROLETEMPLATEA ON ROLEDETAILSA.ITEMPOSITION = ROLETEMPLATEA.ITEMPOSITION
WHERE ROLEDETAILSA.ITEMENABLED = 1 AND ROLETEMPLATEA.ITEMPOSITION NOT IN (12000, 13000, 14000, 15000, 16000, 17000, 18000, 19000, 35000, 36000, 37000)