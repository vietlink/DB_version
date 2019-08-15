/****** Object:  Procedure [dbo].[uspGetPrevNextHistoryByCurrentID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPrevNextHistoryByCurrentID](@listid int, @empid int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT * FROM (
	SELECT
		LAG(cl.id, 2, NULL) OVER (ORDER BY cg.[SortOrder] ASC, cg.[Description] ASC, c.SortOrder ASC, c.[Description] ASC) as PreviousPreviousRowListID,
		LAG(cl.id) OVER (ORDER BY cg.[SortOrder] ASC, cg.[Description] ASC, c.SortOrder ASC, c.[Description] ASC) as PreviousRowListID,
		LAG(ecl.id) OVER (ORDER BY cg.[SortOrder] ASC, cg.[Description] ASC, c.SortOrder ASC, c.[Description] ASC) as PreviousRowEmployeeListID,
		cl.id as CurrentRow,
		LAG(cl.id) OVER (ORDER BY cg.[SortOrder] DESC, cg.[Description] DESC, c.SortOrder DESC, c.[Description] DESC) as NextRowListID,
		LAG(ecl.id) OVER (ORDER BY cg.[SortOrder] DESC, cg.[Description] DESC, c.SortOrder DESC, c.[Description] DESC) as NextRowEmployeeListID,
		LAG(cl.id, 2, NULL) OVER (ORDER BY cg.[SortOrder] DESC, cg.[Description] DESC, c.SortOrder DESC, c.[Description] DESC) as NextNextRowListID
	FROM 
		EmployeeCompetencyList ecl
	INNER JOIN
		CompetencyList cl
	ON 
		cl.id = ecl.CompetencyListId
	INNER JOIN
		Competencies c
	ON 
		c.id = cl.CompetencyId
	INNER JOIN
		CompetencyGroups cg
	ON
		cg.id = cl.CompetencyGroupId
	WHERE
		c.[Type] = 2 AND ecl.Employeeid = @empid
--	ORDER BY
	--	cg.[SortOrder], cg.[Description], c.SortOrder, c.[Description]
) as rs WHERE rs.CurrentRow = @listid
END


