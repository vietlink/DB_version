/****** Object:  Procedure [dbo].[uspGetPeopleCountByManagerID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPeopleCountByManagerID](@empId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT
		COUNT(*) AS PeopleCount
	FROM
		EmployeePositionHistory h
	INNER JOIN
		Employee e
	ON
		e.id = h.employeeid
	INNER JOIN
		Position p
	ON
		p.id = h.positionid

	LEFT OUTER JOIN
		EmployeePosition mep
	ON
		mep.id = h.managerid
	LEFT OUTER JOIN
		Employee me
	ON
		me.id = mep.employeeid
	WHERE me.id = @empId and e.isdeleted = 0 and (h.enddate is null or h.startdate >= DATEADD(d,0,DATEDIFF(d,0,GETDATE())) or h.enddate >= DATEADD(d,0,DATEDIFF(d,0,GETDATE())))
END


