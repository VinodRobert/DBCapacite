/****** Object:  View [dbo].[INVSTORESALLOWED]    Committed by VersionSQL https://www.versionsql.com ******/

  CREATE VIEW INVSTORESALLOWED  AS  	SELECT INVSTORES.*, USERSININVSTORES.USERID  	FROM INVSTORES  	INNER JOIN USERSININVSTORES  	ON INVSTORES.STORECODE = USERSININVSTORES.STORECODE 