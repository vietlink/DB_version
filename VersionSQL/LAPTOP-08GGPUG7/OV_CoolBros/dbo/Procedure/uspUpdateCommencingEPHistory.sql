/****** Object:  Procedure [dbo].[uspUpdateCommencingEPHistory]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateCommencingEPHistory](@empId int, @date datetime)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF (SELECT COUNT(*) FROM EmployeePositionHistory WHERE employeeid = @empId) = 1 BEGIN
		DECLARE @unassignedId int = 1;
		SELECT @unassignedId = id FROM Position WHERE IsUnassigned = 1;

		UPDATE EmployeePosition SET StartDate = @date WHERE employeeid = @empId AND positionid = @unassignedId
		UPDATE EmployeePositionHistory SET StartDate = @date WHERE employeeid = @empId AND positionid = @unassignedId
	END
END


