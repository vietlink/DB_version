/****** Object:  Procedure [dbo].[uspGetNewEmployeesForPosition]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetNewEmployeesForPosition](@posId int, @isSecondary bit = 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @unassignedId int = 0;
	SELECT TOP 1 @unassignedId = id FROM position WHERE IsUnassigned = 1

    SELECT 
		e.*, (SELECT COUNT(*) FROM EmployeePosition WHERE employeeid = e.id AND primaryposition = 'Y' AND IsDeleted = 0 AND positionid <> @unassignedId) as hasposition
	FROM
		Employee e
	INNER JOIN
		[Status] s
	ON
		s.[Description] = e.[status]
	WHERE
		e.id NOT IN
		(
			SELECT
				employeeid e
			FROM
				EmployeePosition ep
			WHERE
				ep.IsDeleted = 0 AND ep.positionid = @posId
		) and e.IsDeleted = 0 AND s.IsVisibleChart = 1 and e.isplaceholder = 0
		and ((@isSecondary = 1) OR (@isSecondary = 0 AND (SELECT COUNT(*) FROM EmployeePosition WHERE employeeid = e.id AND primaryposition = 'Y' AND IsDeleted = 0 AND positionid <> @unassignedId) = 0))
	ORDER BY e.surname

END

