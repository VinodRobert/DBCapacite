/****** Object:  View [dbo].[POS_Approver_Mapping]    Committed by VersionSQL https://www.versionsql.com ******/

 
CREATE VIEW POS_Approver_Mapping as 
SELECT Posuser.BORGID [Org ID], Posuser.USERID [User ID], borguser.USERNAME AS [User], Posuser.SPENDINGLIMIT [Spend Limit], Posuser.APPROVALLIMIT [Approval Limit],
(SELECT TOP (1) approveruser.USERNAME FROM USERS AS approveruser INNER JOIN USERSINBORGP ON approveruser.USERID = USERSINBORGP.SPENDLIMITAPPROVER WHERE approveruser.USERID = Posuser.SPENDLIMITAPPROVER) AS [Next Mapped Approver]
FROM USERS AS borguser 
INNER JOIN USERSINBORGP AS Posuser ON borguser.USERID = Posuser.USERID