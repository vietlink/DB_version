/****** Object:  Procedure [dbo].[uspSoftDeleteEmployeePositionsByEmployeeID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspSoftDeleteEmployeePositionsByEmployeeID](@empId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @unassignedId int = 0;
	SELECT @unassignedId = id FROM position WHERE IsUnassigned = 1
	UPDATE EmployeePosition SET IsDeleted = 1, primaryposition = 'N' WHERE EmployeeID = @empId AND PositionID <> @unassignedId
	UPDATE EmployeePosition SET IsDeleted = 0, primaryposition = 'Y' WHERE EmployeeID = @empId AND PositionID = @unassignedId
END

