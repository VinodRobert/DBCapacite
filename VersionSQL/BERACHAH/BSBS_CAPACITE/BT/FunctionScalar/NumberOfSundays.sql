/****** Object:  Function [BT].[NumberOfSundays]    Committed by VersionSQL https://www.versionsql.com ******/

Create Function BT.NumberOfSundays(@dFrom datetime, @dTo   datetime)
Returns int as
BEGIN
   Declare @nSundays int
   Set @nSundays = 0
   While @dFrom <= @dTo Begin
      If datepart(dw, @dFrom) = 1 Set @nSundays = @nSundays + 1
      Set @dFrom = DateAdd(d, 1, @dFrom)
   End
   Return (@nSundays)
END