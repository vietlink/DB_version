/****** Object:  Procedure [dbo].[uspAddIfNotExistsEmployeeCompetency]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspAddIfNotExistsEmployeeCompetency](@compListId int, @employeeId int, @dateFrom datetime, @dateTo datetime, @iHaveThis bit, @reference varchar(50), @rankingId int = null)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF NOT EXISTS (SELECT CompetencyListId FROM EmployeeCompetencyList WHERE CompetencyListId = @compListId
		AND Employeeid = @employeeId) BEGIN -- add, it doesn't exist
			INSERT INTO EmployeeCompetencyList(Employeeid, CompetencyListId, EmployeeCompetencyRankingId, DateFrom, DateTo, iHaveThis, Reference)
				VALUES(@employeeId, @compListId, @rankingId, @dateFrom, @dateTo, @iHaveThis, @reference);
		END
		ELSE -- update as it exists
			UPDATE
				EmployeeCompetencyList
			SET
				EmployeeCompetencyRankingId = @rankingId,
				DateFrom = @dateFrom,
				DateTo = @dateTo,
				iHaveThis = @iHaveThis,
				Reference = @reference
			WHERE
				CompetencyListId = @compListId AND Employeeid = @employeeId
		END

