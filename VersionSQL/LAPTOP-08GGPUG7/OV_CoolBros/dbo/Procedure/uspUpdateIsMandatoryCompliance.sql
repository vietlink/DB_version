/****** Object:  Procedure [dbo].[uspUpdateIsMandatoryCompliance]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateIsMandatoryCompliance](@posId int, @listid int, @removePositionMandatory bit = 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @removePositionMandatory = 0 BEGIN
		-- update the ecl
		UPDATE ecl
			SET ecl.isMandatory = 1
		FROM
			EmployeePosition ep
		INNER JOIN
			Employee e
		ON
			e.id = ep.employeeid
		INNER JOIN
			EmployeeCompetencyList ecl
		ON
			ecl.employeeid = e.id and ecl.CompetencyListId = @listid
		INNER JOIN
			EmployeeComplianceHistory ech
		ON
			ech.EmployeeCompetencyListID = ecl.id
		WHERE
			ep.PositionID = @posid AND ep.IsDeleted = 0 AND e.IsDeleted = 0
	END
	-- update the history
	IF @removePositionMandatory = 0 BEGIN
		UPDATE ech
			SET ech.isMandatory = 1,
			ech.IsPositionMandatory = 1
		FROM
			EmployeePosition ep
		INNER JOIN
			Employee e
		ON
			e.id = ep.employeeid
		INNER JOIN
			EmployeeCompetencyList ecl
		ON
			ecl.employeeid = e.id and ecl.CompetencyListId = @listid
		INNER JOIN
			EmployeeComplianceHistory ech
		ON
			ech.EmployeeCompetencyListID = ecl.id
		WHERE
			ep.PositionID = @posid AND ep.IsDeleted = 0 AND e.IsDeleted = 0
	END
	ELSE BEGIN
	-- remove the is position mandatory flag from history
		UPDATE ech
			SET ech.IsPositionMandatory = 0
		FROM
			EmployeePosition ep
		INNER JOIN
			Employee e
		ON
			e.id = ep.employeeid
		INNER JOIN
			EmployeeCompetencyList ecl
		ON
			ecl.employeeid = e.id and ecl.CompetencyListId = @listid
		INNER JOIN
			EmployeeComplianceHistory ech
		ON
			ech.EmployeeCompetencyListID = ecl.id
		WHERE
			ep.PositionID = @posid AND ep.IsDeleted = 0 AND e.IsDeleted = 0
	END
END


