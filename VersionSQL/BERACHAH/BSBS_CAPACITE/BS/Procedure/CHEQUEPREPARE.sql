/****** Object:  Procedure [BS].[CHEQUEPREPARE]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BS].[CHEQUEPREPARE](@CHEQUEDAY CHAR(2),@CHEQUEMONTH CHAR(2),@CHEQUEYEAR CHAR(4),@CREDNO VARCHAR(10),@BORGID INT,@FINYEAR INT )
AS 

IF EXISTS (select * from dbo.sysobjects where id = object_id(N'[dbo].[CHEQUESR]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)   drop table [dbo].[CHEQUESR] 

CREATE TABLE [dbo].[CHEQUESR] (  
	 [BorgID] [int] NOT NULL ,  
	 [CREDNO] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,  
     [CREDNAME] [char] (155) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,  
     [AMNT] [money] NOT NULL ,  
     [DISC] [money] NOT NULL,  
     [CHEQUEDATE]   DATETIME , 
     [CHEQUEAMOUNT] VARCHAR(250),     
     [CHEQUEDAY]    CHAR(2) ,
	 [CHEQUEMONTH]  CHAR(2),
	 [CHEQUEYEAR]   CHAR(4) ) ON [PRIMARY]  

DECLARE @AMOUNT DECIMAL(18,2)

SELECT @AMOUNT = SUM(PAIDTHISPERIOD) FROM TRANSACTIONS 
WHERE  ORGID=@BORGID AND YEAR=@FINYEAR  AND CREDNO=@CREDNO AND RECONSTATUS=1

 
 

INSERT INTO [CHEQUESR] VALUES (@BORGID , @CREDNO ,[BS].[fnGetParty](@CREDNO) , @AMOUNT , 0 , GETDATE(), dbo.fn_spellNumber(@AMOUNT,'UK',0), @CHEQUEDAY , @CHEQUEMONTH, @CHEQUEYEAR )

select * from CHEQUESR   