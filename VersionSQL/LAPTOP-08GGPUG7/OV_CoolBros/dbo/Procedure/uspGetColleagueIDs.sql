/****** Object:  Procedure [dbo].[uspGetColleagueIDs]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetColleagueIDs](@empPosId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT epi.id FROM EmployeePositionInfo epi
	INNER JOIN
	Position p
	ON p.id = epi.positionid
	INNER JOIN
	Employee e
	ON e.id = epi.employeeid
	INNER JOIN
	EmployeePosition ep
	ON ep.id = epi.id
	INNER JOIN
	[Status] s
	ON s.[Description] = e.[status]
	WHERE e.isplaceholder = 0 and s.IsVisibleChart = 1 AND ep.IsDeleted = 0 AND p.IsDeleted = 0 AND e.IsDeleted = 0 AND p.IsUnassigned = 0 AND positionparentid IN(
		SELECT positionparentid FROM EmployeePositionInfo epi
		INNER JOIN
		Position p
		ON
		p.id = epi.positionid
		WHERE epi.id = @empPosId AND p.IsUnassigned = 0
	)
END

