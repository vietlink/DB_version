/****** Object:  Procedure [dbo].[uspGetEmployeePositionHistoryByID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeePositionHistoryByID](@id int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT
		eph.*,
		p.title as position,
		p.identifier as positionidentifier,
		case when isnull(eph.managerid, 0) < 1 then '' else (me.displayname + ' - (' + mp.title + ')') end as manager
	FROM
		EmployeePositionHistory eph
	INNER JOIN
		Position p
	ON
		p.id = eph.positionid
	LEFT OUTER JOIN
		EmployeePosition mep
	ON
		mep.id = eph.managerid
	LEFT OUTER JOIN
		Employee me
	ON
		me.id = mep.employeeid
	LEFT OUTER JOIN
		Position mp
	ON
		mp.id = mep.positionid
	WHERE
		eph.id = @id;
END


