/****** Object:  Function [dbo].[fnGetWorkHoursInRage]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetWorkHoursInRage](@empId int, @dateFrom datetime, @dateTo datetime)
RETURNS decimal(10,5)
AS
BEGIN
	DECLARE @dateTable TABLE ([date] DateTime);

	INSERT INTO @dateTable SELECT  DATEADD(DAY, nbr - 1, @dateFrom)
	FROM    ( SELECT    ROW_NUMBER() OVER ( ORDER BY c.object_id ) AS Nbr
			  FROM      sys.columns c
			) nbrs
	WHERE   nbr - 1 <= DATEDIFF(DAY, @dateFrom, @dateTo)

	DECLARE @result decimal(10,5);
	SELECT @result = SUM(dbo.fnGetHoursInDay(@empId, [date])) FROM @dateTable

	RETURN isnull(@result, 0);
END

