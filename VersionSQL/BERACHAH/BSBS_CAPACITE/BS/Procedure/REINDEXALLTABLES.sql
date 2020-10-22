/****** Object:  Procedure [BS].[REINDEXALLTABLES]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE BS.REINDEXALLTABLES
AS
DECLARE @TableName varchar(255) 
 SELECT (table_schema+'.'+table_name) as TABLENAME FROM information_schema.tables 
WHERE table_type ='base table' ORDER BY TABLENAME

DECLARE TableCursor CURSOR FOR
SELECT table_schema+'.'+table_name as table_name FROM information_schema.tables 
WHERE table_type ='base table' ORDER BY TABLE_NAME 
 
OPEN TableCursor 
 
FETCH NEXT FROM TableCursor INTO @TableName 
WHILE @@FETCH_STATUS = 0 
BEGIN
SELECT @TABLENAME 
DBCC DBREINDEX(@TableName,'',90) 
FETCH NEXT FROM TableCursor INTO @TableName 
END
 
CLOSE TableCursor 
 
DEALLOCATE TableCursor