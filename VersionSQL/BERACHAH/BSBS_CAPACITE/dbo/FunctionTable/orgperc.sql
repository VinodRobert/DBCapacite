/****** Object:  Function [dbo].[orgperc]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Matthew Spiller
-- Create date: 05-11-2020
-- Description:	returns consolidated percentages from org structure
-- =============================================
CREATE FUNCTION dbo.orgperc
(
  @Orgid int
)
RETURNS @Orgperc table
(
  Orgid			int, 
  ParentOrg		int,
  CONPERC			decimal (18,4),
  CONPERCORIG		decimal (18,4),
  Lev				int,
  Done			int
)
AS
BEGIN
  declare @lev int
  set @lev = 1

  Insert into   @Orgperc
  Select cast(borgid as int) borgid, -1 PARENTBORG, 100.00 CONPERC, CONPERC CONPERCORIG, @lev LEV, cast(2 as int) done
  From borgs where borgid = @Orgid

  while exists(select * from @Orgperc where done = 2)
  begin
	  set @lev = @lev + 1
	  update @Orgperc set done = 1 where done = 2

	  insert into @Orgperc (Orgid, PARENTORG, CONPERC, CONPERCORIG, LEV, done)
	  select B.BORGID, B.PARENTBORG, B.CONPERC * BP.CONPERC / 100, B.CONPERC, @lev, 2 
	  FROM BORGS B
	  INNER JOIN @Orgperc BP on B.PARENTBORG = BP.ORGID and BP.DONE = 1 

	  update @Orgperc set done = 0 where done = 1
  END
  RETURN
END

 
		
		