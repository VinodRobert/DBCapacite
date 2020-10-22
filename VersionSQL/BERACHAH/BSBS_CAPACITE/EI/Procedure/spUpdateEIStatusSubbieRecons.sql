/****** Object:  Procedure [EI].[spUpdateEIStatusSubbieRecons]    Committed by VersionSQL https://www.versionsql.com ******/

--SELECT * FROM EI.SUBBIECONTRRECONID

--SELECT * FROM CONTRAS WHERE CONTRARECONID=91220
--SELECT * FROM SUBCRECONS WHERE RECONID=91220
--SELECT * FROM SUBCONTRACTORS WHERE SUBID=20843     
CREATE PROCEDURE EI.spUpdateEIStatusSubbieRecons
AS
BEGIN
 DECLARE @RECONID INT
 DECLARE @CONTRITEMS INT
 DECLARE @CONTRAID INT
 DECLARE @CONTRAVATAMOUNT DECIMAL(18,2)
 DECLARE @STATUS VARCHAR(10)
 DECLARE RECONLIST CURSOR FOR SELECT DISTINCT RECONID FROM EI.SUBBIECONTRRECONID
 OPEN RECONLIST
 FETCH NEXT FROM RECONLIST INTO @RECONID 
 WHILE @@FETCH_STATUS = 0 
 BEGIN
    SET @CONTRAID=0
	SELECT @CONTRAID = MAX(CONTRAID) FROM CONTRAS WHERE CONTRARECONID=@RECONID 
	IF @CONTRAID = 0 
	   SET @STATUS='NA'
	ELSE
	 BEGIN
	  SELECT @CONTRAVATAMOUNT = CONTRAVATAMNT FROM CONTRAS WHERE CONTRAID=@CONTRAID 
	  IF @CONTRAVATAMOUNT = 0 
	     SET @STATUS = 'NA'
	  ELSE
	     SET @STATUS ='OPEN'
     END
	 SELECT @RECONID,@STATUS 
	 INSERT INTO ATTRIBVALUE(COLKEY,TABLENAME,ATTRIBUTE,VALUE,USERID,LOGDATETIME,ARRAYINDEX)
     SELECT @RECONID,'SUBCRECONS','EI',@STATUS,227,GETDATE(),0
	 DELETE FROM EI.SUBBIECONTRRECONID WHERE RECONID=@RECONID 
	 FETCH NEXT FROM RECONLIST INTO @RECONID 
 END
 CLOSE RECONLIST
 DEALLOCATE RECONLIST 
END