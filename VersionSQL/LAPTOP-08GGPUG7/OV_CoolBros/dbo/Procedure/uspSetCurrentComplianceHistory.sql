/****** Object:  Procedure [dbo].[uspSetCurrentComplianceHistory]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspSetCurrentComplianceHistory](@eclId int, @listid int, @employeeid int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @currentHistoryId int = 0;

	SELECT TOP 1 @currentHistoryId = isnull(id,0) FROM EmployeeComplianceHistory WHERE employeeid = @employeeid AND listid = @listid AND (CAST(GETDATE() as date) BETWEEN datefrom AND dateto) ORDER BY dateto desc;
	IF @currentHistoryId = 0 BEGIN
		SELECT TOP 1 @currentHistoryId = isnull(id,0) FROM EmployeeComplianceHistory WHERE employeeid = @employeeid AND listid = @listid AND nolongerrequireddate is not null ORDER BY nolongerrequireddate asc;
	END
	IF @currentHistoryId = 0 BEGIN
		SELECT TOP 1 @currentHistoryId = isnull(id,0) FROM EmployeeComplianceHistory WHERE employeeid = @employeeid AND listid = @listid AND (datefrom > CAST(GETDATE() as date)) ORDER BY datefrom asc;
	END
	IF @currentHistoryId = 0 BEGIN
		SELECT TOP 1 @currentHistoryId = isnull(id,0) FROM EmployeeComplianceHistory WHERE employeeid = @employeeid AND listid = @listid AND (dateto < CAST(GETDATE() as date)) ORDER BY dateto desc;
	END
	IF @currentHistoryId = 0 BEGIN
		SELECT TOP 1 @currentHistoryId = isnull(id,0) FROM EmployeeComplianceHistory WHERE employeeid = @employeeid AND listid = @listid;
	END

	UPDATE
		EmployeeComplianceHistory
	SET 
		EmployeeCompetencyListID = NULL
	WHERE
		employeeid = @employeeid AND listid = @listid;

	UPDATE EmployeeComplianceHistory SET EmployeeCompetencyListID = @eclId WHERE id = @currentHistoryId;

	-- get the details of the current history to update the main ecl
	DECLARE @newDateFrom datetime;
	DECLARE @newDateTo datetime;
	DECLARE @newRef varchar(50);
	DECLARE @newIsMandatory bit;
	DECLARE @newHasCompliance bit;
	DECLARE @newNoLongerRequiredDate datetime;

	SELECT @newDateFrom = datefrom, @newDateTo = dateto, @newRef = reference, @newIsMandatory = ismandatory, @newHasCompliance = hasCompliance, @newNoLongerRequiredDate = nolongerrequireddate FROM EmployeeComplianceHistory WHERE id = @currentHistoryId

	-- Update the current record if specified
	IF @eclId > 0 AND @newIsMandatory IS NOT NULL BEGIN
		UPDATE
			EmployeeCompetencyList
		SET
			DateFrom = @newDateFrom,
			DateTo = @newDateTo,
			Reference = @newRef,
			IsMandatory = @newIsMandatory,
			HasCompliance = @newHasCompliance,
			NoLongerRequiredDate = @newNoLongerRequiredDate
		WHERE
			id = @eclId
	END
END


