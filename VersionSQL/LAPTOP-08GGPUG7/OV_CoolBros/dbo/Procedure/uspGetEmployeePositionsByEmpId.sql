/****** Object:  Procedure [dbo].[uspGetEmployeePositionsByEmpId]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeePositionsByEmpId](@empId int, @filterDeleted int = 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT ep.*, p.Title as PositionTitle, p.Identifier as PositionIdentifier FROM EmployeePosition ep
	INNER JOIN
	Position p
	ON
	p.id = ep.positionid
	WHERE employeeid = @empid AND (@filterDeleted = 0 OR (@filterDeleted = 1 AND ep.IsDeleted = 0))
	ORDER BY ep.primaryposition desc, ep.startdate desc
END

