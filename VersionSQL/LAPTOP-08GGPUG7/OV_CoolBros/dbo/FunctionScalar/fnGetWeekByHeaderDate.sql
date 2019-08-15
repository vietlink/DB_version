/****** Object:  Function [dbo].[fnGetWeekByHeaderDate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetWeekByHeaderDate](@headerId int, @date datetime)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @profileStart DateTime
	DECLARE @weekMode int
	SELECT @profileStart = [DateFrom], @weekMode = WeekMode FROM EmployeeWorkHoursHeader where ID = @headerId;

	IF @weekMode = 1
		RETURN 1;

	DECLARE @profileStartWeek int;
	DECLARE @dateWeek int;

	SELECT @profileStartWeek = DATEPART(wk, @profileStart)
	SELECT @dateWeek = DATEPART(wk, @date)

	IF (@profileStartWeek % 2) = (@dateWeek % 2)
		RETURN 1;

	RETURN 2;
END

