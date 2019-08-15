/****** Object:  Procedure [dbo].[uspGetVisibleChartByEmpPosID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetVisibleChartByEmpPosID](@id int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT
		ISNULL(s.IsVisibleChart, 0) as IsVisible
	FROM
		EmployeePosition ep
	INNER JOIN
		Position p
	ON
		ep.positionid = p.id
	INNER JOIN
		Employee e
	ON
		ep.employeeid = e.id
	INNER JOIN
		[Status] s
	ON
		e.[status] = s.[Description]
	WHERE
		ep.id = @id and p.IsVisibleChart = 1
END

