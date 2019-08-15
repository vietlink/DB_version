/****** Object:  Procedure [dbo].[uspRemoveEmployeeComplianceRequirement]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspRemoveEmployeeComplianceRequirement](@employeeid int, @posid int, @listid int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @requirementCount int = 0;

	SELECT
		@requirementCount = COUNT(ep.id)
	FROM
		EmployeePosition ep
	INNER JOIN
		PositionCompetencyList pcl
	ON
		pcl.PositionId = ep.PositionID
	INNER JOIN
		Position p
	ON
		p.id = pcl.PositionId
	WHERE
		EmployeeID IN(
		-- get all positions with this
			SELECT
				employeeid
			FROM
				EmployeePosition ep
			INNER JOIN
				Position p
			ON
				p.id = ep.positionid
			INNER JOIN
				Employee e
			ON
				e.id = ep.employeeid
			WHERE
				p.id = @posid AND ep.isdeleted = 0 AND e.IsDeleted = 0 AND ep.employeeid = @employeeid
		) 
		AND pcl.CompetencyListId = @listid AND ep.IsDeleted = 0 AND p.IsDeleted = 0

	DECLARE @dateFrom datetime;
	DECLARE @dateTo datetime;
	DECLARE @issueDate datetime;
	DECLARE @noLongerRequiredDate datetime;

	IF @requirementCount = 1 BEGIN
		SELECT @dateFrom = dateFrom, @dateTo = dateTo, @noLongerRequiredDate = NoLongerRequiredDate FROM EmployeeCompetencyList WHERE Employeeid = @employeeid AND CompetencyListId = @listid

		IF @dateFrom IS NULL AND @dateTo IS NULL AND @noLongerRequiredDate IS NULL BEGIN
			DELETE FROM EmployeeComplianceHistory WHERE	Employeeid = @employeeid AND ListId = @listid
			DELETE FROM EmployeeCompetencyList WHERE Employeeid = @employeeid AND CompetencyListId = @listid
		END
		ELSE BEGIN
			UPDATE
				EmployeeCompetencyList
			SET
				IsPositionRequirement = 0
			WHERE
				Employeeid = @employeeid AND CompetencyListId = @listid
		END
	END
END


