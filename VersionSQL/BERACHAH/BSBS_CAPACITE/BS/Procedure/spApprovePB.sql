/****** Object:  Procedure [BS].[spApprovePB]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE BS.spApprovePB(@BATCHNUMBER INT,@BATCHORGID INT,@BATCHTYPE VARCHAR(1))
AS 
 
INSERT INTO VRBATCH VALUES (@BATCHNUMBER,@BATCHORGID,@BATCHTYPE) 
 