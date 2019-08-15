/****** Object:  Procedure [dbo].[uspGetEmployeesForPosition]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeesForPosition](@positionId int, @dontFilterVisible bit = 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT
		e.id as EmployeeID, ep.id as EmpPosID, e.displayname, e.identifier, e.picture
	FROM
		EmployeePosition ep
	INNER JOIN
		Employee e
	ON
		e.id = ep.employeeid
	INNER JOIN
		[Status] s
	ON
		s.[Description] = e.[status]
	WHERE e.isplaceholder=0 and ep.IsDeleted = 0 AND e.IsDeleted = 0 AND ep.positionid = @positionId AND ((@dontFilterVisible = 0 AND s.IsVisibleChart = 1) OR @dontFilterVisible = 1)
	ORDER by e.surname
END

