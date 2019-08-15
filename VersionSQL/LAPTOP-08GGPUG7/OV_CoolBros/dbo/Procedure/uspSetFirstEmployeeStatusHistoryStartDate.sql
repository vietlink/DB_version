/****** Object:  Procedure [dbo].[uspSetFirstEmployeeStatusHistoryStartDate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspSetFirstEmployeeStatusHistoryStartDate](@empId int, @date datetime)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @id int = 0;
	SELECT TOP 1 @id = id FROM EmployeeStatusHistory WHERE EmployeeID = @empId ORDER BY StartDate ASC
	UPDATE EmployeeStatusHistory SET StartDate = @date WHERE id = @id;    

	DECLARE @unassignedId int = 0;
	SELECT @unassignedId = id FROM Position WHERE IsUnassigned = 1;

	IF (SELECT COUNT(id) FROM EmployeePositionHistory WHERE EmployeeID = @empId AND primaryposition = 'Y') = 1 BEGIN
		DECLARE @startDate datetime;
		SELECT TOP 1 @id = id, @startDate = StartDate FROM EmployeePositionHistory WHERE primaryposition = 'Y' AND EmployeeID = @empId AND positionid = @unassignedId AND EndDate IS NULL

		IF @id IS NOT NULL BEGIN
			UPDATE EmployeePositionHistory SET StartDate = @date WHERE id = @id;
			IF (SELECT COUNT(id) FROM EmployeePosition WHERE EmployeeID = @empId AND PrimaryPosition = 'Y' AND IsDeleted = 0) = 1
				UPDATE EmployeePosition SET StartDate = @date WHERE Employeeid = @empId AND positionid = @unassignedId AND primaryposition = 'Y' AND IsDeleted = 0
		END
	END
END

