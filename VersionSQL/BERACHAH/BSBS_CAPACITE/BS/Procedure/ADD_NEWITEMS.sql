/****** Object:  Procedure [BS].[ADD_NEWITEMS]    Committed by VersionSQL https://www.versionsql.com ******/

   
CREATE PROCEDURE [BS].[ADD_NEWITEMS] 
AS
BEGIN
   -- CHECKE CONTRACT CODE IN THE INVSTORES - ELSE REPLACE IT
   SELECT STORECODE,LTRIM(RTRIM(SUBSTRING(STORECODE,4,8))) CONTRCTCODE INTO #NEWCONTRACTS  from invstores where StoreContNumber is null  and left(storecode,1)='M'  
   UPDATE INVSTORES SET StoreContNumber = NC.CONTRCTCODE 
   FROM #NEWCONTRACTS NC
   INNER JOIN INVSTORES ON INVSTORES.STORECODE=NC.STORECODE 

   -- REPLICATE IN ALL THE OTHER STORES FROM VIRTUAL STORE
   DECLARE @ROWCOUNT INT
   DECLARE @STORECODE VARCHAR(10)
   DECLARE @BORGID INT
   
   DROP TABLE NEWITEMS 
   
   SELECT *  INTO NEWITEMS  FROM INVENTORY WHERE STKSTORE='VMAINSTORE' AND BORGID = 2 AND
    STKCODE NOT IN (SELECT STKCODE FROM INVENTORY WHERE STKSTORE= 'MS-90003       ')
 

   DECLARE STORELISTS CURSOR FOR
   SELECT I.STORECODE,B.BORGID 
        FROM INVSTORES I 
	    INNER JOIN CONTRACTS C ON I.STORECONTNUMBER=C.CONTRNUMBER 
        INNER JOIN PROJECTS P ON C.PROJID = P.PROJID
        INNER JOIN BORGS B ON P.BORGID = B.BORGID 
        WHERE ( I.StoreCode <>'VMAINSTORE' AND LEFT(I.STORECODE,4)<>'MS-5'  AND I.STORECODE<>'VMAINCSL' )  AND 
	    LEFT(B.BORGNAME,1)='9' 
		
	OPEN STORELISTS
	FETCH NEXT FROM STORELISTS INTO @STORECODE,@BORGID 
	WHILE @@FETCH_STATUS = 0
	BEGIN
	
	INSERT INTO INVENTORY 
	SELECT
		   @STORECODE
		  ,[StkCode]
		  ,[StkDesc]
		  ,[StkUnit]
		  ,[StkBin]
		  ,[StkQuantity]
		  ,[StkCostRate]
		  ,[MUMethod]
		  ,[MUValue]
		  ,[StkSellRate]
		  ,[StkGLCode]
		  ,[StkMaxBal]
		  ,[StkMinBal]
		  ,@BORGID 
		  ,[ToJoinI]
		  ,[StkHireRate]
		  ,[StkStatus]
		  ,[STKSTKTAKE]
		  ,[STKSHEET]
		  ,[STKWEIGHT]
		  ,[STKWEIGHTUNIT]
		  ,[STKSELLUNIT]
		  ,[STKSELLCONV]
		  ,[STKBUYUNIT]
		  ,[STKBUYCONV]
		  ,[STKSUPPCODE]
		  ,[STKBUYCOST]
		  ,[STKBUYDATE]
		  ,[STKSELLDATE]
		  ,[STKSELECT]
		  ,[StkSuppProdCode]
		  ,[OB1]
		  ,[OB2]
		  ,[OB3]
		  ,[OB4]
		  ,[OB5]
		  ,[OB6]
		  ,[OB7]
		  ,[OB8]
		  ,[OB9]
		  ,[OB10]
		  ,[OB11]
		  ,[OB12]
		  ,[OPENINGBALANCE]
		  ,[STKDEFGL]
		  ,[StkDefAct]
		  ,[StkConvertFlag]
		  ,[SerialType]
		  ,[STKSTKTAKERATE]
		  ,[STKSHEETRATE]
		  ,[DIVID]
		  ,[STKSTARTQTY]
		  ,[STKSTARTRATE]
		  ,[STKHIREADJUST]
		  ,[STKHIRESHEET]
		  ,[DEFINVVATID]
	    FROM NEWITEMS 
		WHERE STKCODE NOT IN (SELECT STKCODE FROM INVENTORY WHERE STKSTORE=@STORECODE  AND BORGID= @BORGID ) 

		FETCH NEXT FROM STORELISTS INTO @STORECODE,@BORGID 
		END

		CLOSE STORELISTS
		DEALLOCATE STORELISTS

		-- REPLICATEING STOCK STATUS TO ALL THE SIMILAR ITEMS 
		UPDATE INVENTORY SET STKSTATUS=1 WHERE STKSTORE<>'VMAINSTORE'  AND STKCODE IN ( 
				SELECT STKCODE FROM INVENTORY WHERE STKSTORE='VMAINSTORE'  AND STKSTATUS=1 )

END