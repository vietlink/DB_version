/****** Object:  Function [dbo].[fnGetChildrenIDsBySupervisorID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetChildrenIDsBySupervisorID](@supervisorPositionId int)
RETURNS TABLE 
AS
RETURN 
(
	SELECT
		ep.ID
	FROM
		EmployeePosition ep
	INNER JOIN
		Position p
	ON
		ep.PositionID = p.ID
	WHERE
		p.parentid = @supervisorPositionId AND ep.IsDeleted = 0 AND p.IsDeleted = 0
)

