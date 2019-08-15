/****** Object:  Procedure [dbo].[uspGetEmployeesByLeaveTypeDate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeesByLeaveTypeDate](@leaveTypeId int, @date datetime, @search varchar(100))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT
		e.id,
		e.displayname,
		e.surname,
		p.title as position,
		e.[status] as [status]
	FROM
		EmployeeLeaveTypes elt
	INNER JOIN
		Employee e
	ON
		e.ID = elt.EmployeeID
	INNER JOIN
		EmployeePosition ep
	ON
		e.ID = ep.EmployeeID
	INNER JOIN
		Position p
	ON
		p.ID = ep.PositionID
	INNER JOIN
		EmployeeWorkHoursHeader ewh
	ON
		ewh.EmployeeID = e.id AND elt.EmployeeWorkHoursHeaderID = ewh.ID
	WHERE
		ewh.ID = dbo.fnGetWorkHourHeaderIDByDay(elt.EmployeeID, @date) AND
		elt.LeaveTypeID = @leaveTypeId AND [Enabled] = 1 AND ep.Primaryposition = 'Y' and ep.IsDeleted = 0 AND e.IsDeleted = 0
		AND
		(e.displayname like '%' + @search + '%' OR p.title like '%' + @search + '%' OR e.[status] like '%' + @search + '%')
	ORDER BY e.surname
END

