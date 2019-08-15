/****** Object:  Procedure [dbo].[uspGetCurrentUserDocumentSize]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCurrentUserDocumentSize](@empId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT
		ISNULL(SUM(CAST(d.Size as int)), 0) as Size
	FROM
		Documents d
	LEFT OUTER JOIN
		EmployeeCompetencyList ecl
	ON
		ecl.Id = d.DataID AND (d.PageType LIKE 'Competency' OR d.PageType LIKE 'Compliance')
	WHERE
		d.IsDeleted = 0 AND (ecl.Employeeid = @empId OR (d.DataID = @empId AND d.PageType LIKE 'Personal'))
END

