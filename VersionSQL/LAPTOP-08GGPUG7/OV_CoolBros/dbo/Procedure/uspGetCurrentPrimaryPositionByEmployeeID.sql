/****** Object:  Procedure [dbo].[uspGetCurrentPrimaryPositionByEmployeeID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCurrentPrimaryPositionByEmployeeID](@empId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT
		ep.*,
		p.title,
		p.identifier,
		me.displayname + ' - (' + mp.title + ')' as manager,
		p.IsUnassigned,
		p.ApprovalLevel
	FROM
		EmployeePosition ep
	INNER JOIN
		Position p
	ON
		ep.positionid = p.id
	LEFT OUTER JOIN
		EmployeePosition mep
	ON
		mep.id = ep.ManagerID
	LEFT OUTER JOIN
		Employee me
	ON
		me.id = mep.employeeid
	LEFT OUTER JOIN
		Position mp
	ON
		mp.id = mep.positionid
	WHERE ep.Employeeid = @empId AND ep.IsDeleted = 0 AND ep.primaryposition = 'Y'
END
