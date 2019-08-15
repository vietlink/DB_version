/****** Object:  Function [dbo].[fnIsPublicHolidayOnDay]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnIsPublicHolidayOnDay](@date DateTime, @headerId int)
RETURNS int
AS
BEGIN
	DECLARE @id int = 0;
	SELECT
		@id = h.ID
	FROM
		EmployeeWorkHoursHeader ewh
	INNER JOIN
		HolidayRegion hr ON ewh.HolidayRegionID= hr.ID
	INNER JOIN 

		Holiday h
	ON
		h.HolidayRegionID = hr.ID
	WHERE
		h.[Date] = @date
		and ewh.ID= @headerId
		and dbo.fnGetWorkHourHeaderIDByDay(ewh.EmployeeID, h.Date)=@headerId
	RETURN @id
END

