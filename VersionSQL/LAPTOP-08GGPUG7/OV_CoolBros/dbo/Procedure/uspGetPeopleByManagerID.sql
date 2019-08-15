/****** Object:  Procedure [dbo].[uspGetPeopleByManagerID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPeopleByManagerID](@empId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT
		h.id,
		ep.id as empposid,
		e.displayname,
		e.id as empid,
		p.title,
		h.startdate,
		h.enddate,
		h.managerid,
		h.primaryposition,
		e.[status],
		CASE WHEN me.displayname IS NOT NULL THEN
			me.displayname + ' (' + mp.title + ')'
		ELSE '' END as manager
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
		EmployeePosition ep
	ON
		ep.employeeid = e.id AND ep.positionid = p.id
	LEFT OUTER JOIN
		EmployeePosition mep
	ON
		mep.id = h.managerid
	LEFT OUTER JOIN
		Employee me
	ON
		me.id = mep.employeeid
	LEFT OUTER JOIN
		Position mp
	ON
		mp.id = mep.positionid
	WHERE ep.id is not null and me.id = @empId and e.isdeleted = 0 and (h.enddate is null or h.startdate >= DATEADD(d,0,DATEDIFF(d,0,GETDATE())) or h.enddate >= DATEADD(d,0,DATEDIFF(d,0,GETDATE())))
END
