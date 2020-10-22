/****** Object:  Procedure [BT].[AddEditDPRManpower]    Committed by VersionSQL https://www.versionsql.com ******/

--SELECT * FROM BT.SALES

--CREATE TABLE BT.DPR(DPRID INT Primary Key,ProjectCode int, BOQNumber Varchar(15), DPRDate DateTime, DPRQty Decimal(18,2) )

CREATE Procedure BT.AddEditDPRManpower(@DPRID int,@ProjectCode int, @ManpowerSkillTypeID varchar(5), @DPRDATESTRING Varchar(15), @DPRQty decimal(18,2))
as
DECLARE @NEXTID INT
SELECT @NEXTID =ISNULL( MAX(DPRID) ,0 ) FROM BT.DPRManpower
SET @NEXTID = @NEXTID + 1

DECLARE @DPRDATE DATETIME 
SET @DPRDATE = CONVERT(DATETIME,@DPRDATESTRING,103);

IF @DPRID= 0 
 BEGIN
       INSERT INTO BT.DPRManpower(DPRID,PROJECTCODE,ManpowerSkillTypeID,DPRDATE,DPRQTY)  
       VALUES     (@NEXTID,@ProjectCode,@ManpowerSkillTypeID,@DPRDATE,@DPRQTY)
 END
ELSE
 BEGIN
       UPDATE BT.DPRManpower SET DPRQTY = @DPRQTY WHERE DPRID=@DPRID
 END