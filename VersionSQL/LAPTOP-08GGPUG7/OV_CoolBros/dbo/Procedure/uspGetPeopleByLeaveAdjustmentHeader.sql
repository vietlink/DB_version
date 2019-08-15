/****** Object:  Procedure [dbo].[uspGetPeopleByLeaveAdjustmentHeader]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPeopleByLeaveAdjustmentHeader](@id int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT
		e.id,
		e.displayname,
		p.title as position,
		e.[status] as [status]
	FROM
		LeaveAdjustmentPeople lap
	INNER JOIN
		Employee e
	ON
		e.ID = lap.EmployeeID
	INNER JOIN
		EmployeePosition ep
	ON
		e.ID = ep.EmployeeID
	INNER JOIN
		Position p
	ON
		p.ID = ep.PositionID
	WHERE
		lap.LeaveAdjustmentHeaderID = @id AND ep.primaryposition = 'Y' AND ep.IsDeleted = 0 AND e.IsDeleted = 0
END

