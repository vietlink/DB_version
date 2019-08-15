/****** Object:  Function [dbo].[fnGetLastDateByDay]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetLastDateByDay](@date datetime, @dayOfWeekIndex int)
RETURNS DateTime
AS
BEGIN
	IF DATEPART(dw, @date) = 1
		SET @date = DATEADD(day, -1, @date);
	DECLARE @lastMonday DateTime = DATEADD(wk, DATEDIFF(wk, 6, @date), 0)
	RETURN DATEADD(dd, (@dayOfWeekIndex - 1), @lastMonday);
END

