/****** Object:  Procedure [BS].[STOCKSTATEMENT]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BS].[STOCKSTATEMENT](@BORGID INT,@STORECODE VARCHAR(10))
AS
BEGIN
  SELECT STOCKNO,QUANTITY,RATE INTO #TEMP1 FROM TRANSACTIONS WHERE PERIOD=11 AND YEAR=2014 AND ORGID=@BORGID AND STORE=@STORECODE 

  SELECT I.STKCODE,D.DLVRQTY,D.PRICE  INTO #TEMP2 
  FROM ORD O INNER JOIN ORDITEMS OI ON O.ORDID=OI.ORDID INNER JOIN DELIVERIES D ON O.ORDID=D.ORDID AND OI.LINENUMBER = D.ORDITEMLINENO 
  INNER JOIN INVENTORY I ON I.STKID = OI.STOCKID WHERE D.TBORGID = @BORGID AND D.DLVRDATE<='31/MAR/2014' 

  SELECT STKCODE,SUM(DLVRQTY) DLVRQTY,SUM(DLVRQTY*PRICE) DLVRVALUE INTO  #TEMP3 
  FROM #TEMP2 GROUP BY STKCODE  

   

  CREATE TABLE #FINAL(STORECODE VARCHAR(10),STOCKNO VARCHAR(15), STOCKNAME VARCHAR(255), UOM VARCHAR(25),
  OPENINGQTY DECIMAL(18,4),OPENINGVALUE DECIMAL(18,2),RECEIPTS DECIMAL(18,4),RECEIPTVALUE DECIMAL(18,2)) 

  INSERT INTO #FINAL(STOCKNO,OPENINGQTY,OPENINGVALUE)
  SELECT STOCKNO,QUANTITY,QUANTITY*RATE FROM #TEMP1 
  SELECT * FROM #FINAL WHERE STOCKNO= 'FCNUT0116'

  INSERT INTO #FINAL(STOCKNO) 
  SELECT STKCODE FROM #TEMP3 WHERE STKCODE NOT IN (SELECT STOCKNO FROM #FINAL)

  UPDATE #FINAL SET RECEIPTS=#TEMP3.DLVRQTY,RECEIPTVALUE = #TEMP3.DLVRVALUE FROM #TEMP3 INNER JOIN #FINAL ON 
  #FINAL.STOCKNO = #TEMP3.STKCODE 

  UPDATE #FINAL SET STORECODE=@STORECODE
  UPDATE #FINAL SET STOCKNAME = LEFT(I.STKDESC,255)   ,UOM = LEFT(I.StkUnit,25)   FROM INVENTORY I
   INNER JOIN #FINAL  ON #FINAL.STOCKNO   = I.STKCODE WHERE  I.BORGID=@BORGID 
  UPDATE #FINAL SET OPENINGQTY =0,OPENINGVALUE=0 WHERE OPENINGQTY IS NULL
  UPDATE #FINAL SET RECEIPTS=0,RECEIPTVALUE=0 WHERE RECEIPTS IS NULL 
  SELECT * FROM #FINAL ORDER BY STOCKNO   

END