/****** Object:  View [dbo].[POS_ACCESS_PER_ROLE]    Committed by VersionSQL https://www.versionsql.com ******/

 
CREATE VIEW POS_ACCESS_PER_ROLE as 
SELECT ROLEHEADERP.ROLENAME [Role Name], ROLETEMPLATEP.ITEMCATEGORY [Group], ROLETEMPLATEP.ITEMACTION [Action], 
ROLETEMPLATEP.ITEMDESCRIPTION [Description], ROLEDETAILSP.ITEMPOSITION
FROM ROLEDETAILSP 
INNER JOIN ROLETEMPLATEP ON ROLEDETAILSP.ITEMPOSITION = ROLETEMPLATEP.ITEMPOSITION 
INNER JOIN ROLEHEADERP ON ROLEDETAILSP.ROLEID = ROLEHEADERP.ROLEID 
WHERE ROLEDETAILSP.ITEMENABLED = 1