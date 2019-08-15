/****** Object:  Procedure [dbo].[uspUpdateEpManager]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateEpManager](@personEpId int, @managerEpId int, @updatedBy varchar(255))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @currentEmpId int;
	DECLARE @currentPosId int;
	DECLARE @currentStartDate datetime;
	DECLARE @currentEndDate datetime;

	SELECT
		@currentEmpId = employeeid,
		@currentPosId = positionid,
		@currentStartDate = startdate,
		@currentEndDate = enddate
	FROM
		EmployeePosition
	WHERE
		id = @personEpId;

	DECLARE @epHistoryId int = 0;

	SELECT
		@epHistoryId = id
	FROM
		EmployeePositionHistory
	WHERE
		Employeeid = @currentEmpId AND
		Positionid = @currentPosId AND
		StartDate = @currentStartDate

	IF @epHistoryId <> 0
		EXEC dbo.uspUpdateManager @epHistoryId, @managerEpId, @updatedBy
END


