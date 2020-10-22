/****** Object:  Function [dbo].[BS_MRPVIEW]    Committed by VersionSQL https://www.versionsql.com ******/

Create FUNCTION [dbo].[BS_MRPVIEW] (@orgid int = -1,@lev int = -1)
RETURNS @t TABLE (
ID int identity(1,1),
MRPID INT,
MTYPE SMALLINT,
CID INT,
TODO INT,
MRPCODE NVARCHAR(20),
LEV INT,
CODETYPE NVARCHAR(20),
CODE NVARCHAR(20),
UOM NVARCHAR(8),
DESCRIPTION NVARCHAR(250),
STORECODE NVARCHAR(50),
STORENAME NVARCHAR(35),
COSTRATE NUMERIC(18, 4), 
QTY NUMERIC(18, 4),
PRODUCTION NUMERIC(18, 4),
MARKUP NUMERIC(18, 4),
SELLRATE NUMERIC(18, 4), 
ORD int
)
AS
BEGIN
declare @id as int
declare @ord as int

set @ord = 0

insert into @t (
MRPCODE, MRPID, CID, LEV, MTYPE, CODETYPE, CODE, DESCRIPTION, QTY, COSTRATE, PRODUCTION, MARKUP, STORECODE, STORENAME, SELLRATE, TODO, UOM, ORD)
SELECT
H.MRPCODE,
H.MRPID, H.MRPID, 0, 0, 
'Header',
H.MRPCODE, 
H.DESCRIPTION, 
1, MD.COSTRATE,
1, H.MUVALUE, 
isnull(S.STORECODE, ''), isnull(S.STORENAME, ''),
case H.MUMETHOD 
when 0 then MD.COSTRATE + (MD.COSTRATE * H.MUVALUE / 100)
when 1 then MD.COSTRATE + H.MUVALUE
when 2 then MD.COSTRATE - (MD.COSTRATE * H.MUVALUE / 100)
when 3 then MD.COSTRATE - H.MUVALUE
when 4 then MD.COSTRATE
end,
1,
H.UOM,
@ord
FROM MRPHEADER H
LEFT OUTER JOIN INVSTORES S ON S.STORECODE = H.DEFSTORE
OUTER APPLY (
	select round(SUM((MD.QTY * MD.COSTRATE / MD.PRODUCTION) + (MD.QTY * MD.COSTRATE * (MD.MARKUP / 100) / MD.PRODUCTION)), 4) as COSTRATE
	FROM MRPDETAIL MD
	WHERE H.MRPID = MD.MRPID
	GROUP BY MD.MRPID
	) MD
WHERE H.BORGID = @orgid

set @ord = @ord + 1

WHILE EXISTS (select top 1 id from @t where TODO = 1)
BEGIN
	set @ord = @ord + 1

	set @id = isnull((select top 1 id from @t where TODO = 1), -1)
	if @id <> -1
	begin
		update @t set
		TODO = 0,
		ORD = @ord 
		WHERE ID = @id

		insert into @t (
		MRPCODE, MRPID, CID, LEV, MTYPE, CODETYPE, CODE, DESCRIPTION, QTY, COSTRATE, PRODUCTION, MARKUP, STORECODE, STORENAME, SELLRATE, TODO, UOM, ORD
		)
		SELECT
		T.MRPCODE, T.MRPID, D.CID, T.LEV + 1, D.MTYPE, 
		case D.MTYPE when 1 then 'Stock' when 2 then 'Extra' when 3 then 'MRP' else 'Unknown' end,
		case D.MTYPE when 1 then isnull(I.STKCODE, '') when 3 then isnull(H2.MRPCODE, '') else D.CODE end, 
		case D.MTYPE when 1 then isnull(I.STKDESC, '') when 3 then isnull(H2.DESCRIPTION, '') else D.DESCRIPTION end, 
		D.QTY, case when D.MTYPE = 2 then D.COSTRATE when D.MTYPE = 1 then I.STKCOSTRATE else D.COSTRATE end as COSTRATE,
		D.PRODUCTION, D.MARKUP, isnull(S.STORECODE, ''), isnull(S.STORENAME, ''), 
		(D.QTY * case when D.MTYPE = 2 then D.COSTRATE when D.MTYPE = 1 then I.STKCOSTRATE else D.COSTRATE end / D.PRODUCTION) * (1 + (D.MARKUP / 100)),
		case when D.MTYPE = 3 and D.CID > 0 then 1 else 0 end,
		case D.MTYPE when 1 then I.StkUnit when 2 then D.UOM when 3 then H2.UOM else '' end,
		@ord
		FROM MRPHEADER H
		INNER JOIN MRPDETAIL D ON D.MRPID = H.MRPID
		LEFT OUTER JOIN MRPHEADER H2 on H2.MRPID = D.CID and D.MTYPE = 3
		LEFT OUTER JOIN INVENTORY I	ON I.BORGID = H.BORGID AND I.StkStore = D.STKSTORE AND I.StkCode = D.STKCODE
		LEFT OUTER JOIN INVSTORES S ON S.StoreCode = I.StkStore
		INNER JOIN @t T	ON H.MRPID = T.CID
		WHERE T.id = @id
	end
END 

if(@lev > -1) BEGIN
	delete from @t where LEV > @lev
END

RETURN
END