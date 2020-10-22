/****** Object:  Procedure [BT].[spChangeMaterailCodes]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE BT.spChangeMaterailCodes(@PROJECT INT,@WRONGTOOLCODE VARCHAR(20), @CORRECTTOOLCODE VARCHAR(20)) 
AS
-- This Procedure will Simply Replace the Wrong Tool Code to Correct Tool Code - 
-- Distribution and Release - No Change 
-- Will Modify Project Material Budget Master / Monthly Material Budget and Tender Items 

DECLARE @BORGID INT
SET @BORGID=0
SELECT @BORGID=ISNULL(BORGID ,0) FROM BT.PROJECTS WHERE PROJECTID=@PROJECT 
IF @BORGID = 0
   BEGIN
     SELECT ' CHECK PROJECT CODE ' 
	 RETURN
   END 

DECLARE @EXISTOLDCODE INT
DECLARE @EXISTNEWCODE INT

SET @EXISTOLDCODE = 0
SELECT @EXISTOLDCODE = COUNT(*) FROM BT.MasterMaterialBudget WHERE TEMPLATECODE=@WRONGTOOLCODE
IF @EXISTOLDCODE=0 
  BEGIN
     SELECT ' CHECK OLD MATERAIL CODE  ' 
	 RETURN
  END

SET @EXISTNEWCODE = 0
SELECT @EXISTNEWCODE = COUNT(*) FROM BT.MasterMaterialBudget WHERE TEMPLATECODE=@CORRECTTOOLCODE
IF @EXISTNEWCODE=0 
  BEGIN
     SELECT ' CHECK NEW  MATERAIL CODE  ' 
	 RETURN
  END



DECLARE @NEWMATERIALNAME VARCHAR(250)
SELECT @NEWMATERIALNAME = TEMPLATENAME FROM BT.MasterMaterialBudget WHERE TEMPLATECODE=@CORRECTTOOLCODE

-- Project Material Budget 
UPDATE BT.ProjectMaterialBudgetMaster SET TOOLCODE=@CORRECTTOOLCODE 
 WHERE PROJECTCODE=@PROJECT AND TOOLCODE=@WRONGTOOLCODE

-- Monthly Materail Budget - For PR
UPDATE BT.MonthlyMaterialBudget SET TOOLCODE=@CORRECTTOOLCODE ,BudgetCategoryName=@NEWMATERIALNAME
 WHERE PROJECTCODE=@PROJECT AND TOOLCODE=@WRONGTOOLCODE

-- TENDER ITEMS
UPDATE TENDERITEMS SET DESCR=@NEWMATERIALNAME,RESCODE=@CORRECTTOOLCODE 
 WHERE BORG=@BORGID AND RESCODE=@WRONGTOOLCODE