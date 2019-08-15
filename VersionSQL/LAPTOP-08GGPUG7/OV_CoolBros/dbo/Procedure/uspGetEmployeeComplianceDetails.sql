/****** Object:  Procedure [dbo].[uspGetEmployeeComplianceDetails]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeeComplianceDetails](@empid int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT case when rstitles.positiontitles <> '' then 'Position requirement for:&' + rstitles.positiontitles else rstitles.positiontitles end as positiontitles, rsdocuments.documentcount, rsnotes.notecount, ecl.*, c.id as complianceid, cg.id as groupid,
	cg.[Description] as [group], c.[Description] as compliance, (SELECT TOP 1 _ech.id FROM EmployeeComplianceHistory _ech WHERE _ech.employeeid = @empId AND _ech.listid = ecl.CompetencyListId AND _ech.EmployeeCompetencyListID IS NOT NULL) as HistoryID,
	ecl.HasCompliance, ecl.NoLongerRequiredDate
	FROM EmployeeCompetencyList ecl
	INNER JOIN
	CompetencyList cl
	ON cl.id = ecl.CompetencyListId
	INNER JOIN
	Competencies c
	ON c.id = cl.CompetencyId
	INNER JOIN
	CompetencyGroups cg
	ON cg.id = cl.CompetencyGroupId
	CROSS APPLY(
	SELECT isnull(stuff((
SELECT CHAR(13) + p.title FROM EmployeePosition ep
		INNER JOIN Position p ON p.id = ep.positionid 
		INNER JOIN PositionCompetencyList pcl ON pcl.PositionId = p.id
		INNER JOIN CompetencyList _cl ON _cl.id = pcl.CompetencyListId
		WHERE ep.employeeid = @empid AND ep.IsDeleted = 0 and _cl.id = cl.id
		for xml path('')
    ),1,1,''), '') as positiontitles) rstitles
	CROSS APPLY(
		SELECT isnull(COUNT(*), 0) as documentcount FROM Documents WHERE pagetype = 'Compliance' AND dataid = ecl.id AND IsDeleted = 0
	) rsdocuments
	CROSS APPLY(
		SELECT isnull(COUNT(*), 0) as notecount FROM NotesCompetencyRelations WHERE CompetencyID = ecl.id
	) rsnotes
	WHERE c.[Type] = 2 AND ecl.Employeeid = @empid
	ORDER BY cg.[SortOrder], cg.[Description], c.SortOrder, c.[Description]
END


