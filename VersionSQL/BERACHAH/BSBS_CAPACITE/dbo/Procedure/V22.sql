/****** Object:  Procedure [dbo].[V22]    Committed by VersionSQL https://www.versionsql.com ******/

 
CREATE PROCEDURE V22
AS
 
DECLARE VV CURSOR FOR SELECT DISTINCT TASKID FROM BT.WORKSUBTASK
DECLARE @TASKID VARCHAR(8)
OPEN VV 
FETCH NEXT FROM VV INTO @TASKID 
WHILE @@FETCH_STATUS = 0 
BEGIN
  CREATE TABLE #TEMP1(ID INT PRIMARY KEY IDENTITY(1,1),SUBTASKCODE VARCHAR(10))
  DELETE FROM #TEMP1 
 
  INSERT INTO #TEMP1 
  SELECT SUBTASKCODE FROM BT.WORKSUBTASK WHERE TASKID=@TASKID  ORDER BY SUBTASKNAME 
   

  UPDATE BT.WORKSUBTASK SET SUBTASKNUMBER =T.ID FROM #TEMP1 T INNER JOIN BT.WORKSUBTASK ON BT.WORKSUBTASK.SUBTASKCODE = T.SUBTASKCODE 
  DROP TABLE #TEMP1 

  FETCH NEXT FROM VV INTO @TASKID 
END 
CLOSE VV
DEALLOCATE VV

SELECT * FROM BT.WORKSUBTASK ORDER BY TASKID , SUBTASKNUMBER 