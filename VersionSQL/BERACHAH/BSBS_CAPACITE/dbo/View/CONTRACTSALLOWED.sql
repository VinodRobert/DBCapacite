/****** Object:  View [dbo].[CONTRACTSALLOWED]    Committed by VersionSQL https://www.versionsql.com ******/

  CREATE VIEW CONTRACTSALLOWED  AS  	SELECT CONTRACTS.*, USERSINCONTRACTS.USERID  	FROM CONTRACTS  	INNER JOIN USERSINCONTRACTS  	ON CONTRACTS.CONTRID = USERSINCONTRACTS.CONTRID 